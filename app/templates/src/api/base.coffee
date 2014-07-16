( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require "q"
            require "madlib-console"
            require "madlib-hostmapping"
            require "madlib-object-utils"
            require "madlib-xhr"
            require "underscore"
            require "moment"
        )
    else if typeof define is "function" and define.amd
        define( [
            "q"
            "madlib-console"
            "madlib-hostmapping"
            "madlib-object-utils"
            "madlib-xhr"
            "underscore"
            "moment"
        ], factory )

)( ( Q, console, HostMapping, objectUtils, XHR, _, moment ) ->

    ###*
    #   The base class for all API service calls
    #
    #   @author         mdoeswijk
    #   @class          BaseService
    #   @constructor
    #   @version        0.1
    ###
    class BaseService

        ###*
        #   Identifies the service to the api
        #
        #   @property baseService
        ###
        name: "baseService"

        ###*
        #   The constructor is used to setup the type of service call.
        #   It specifies XmlHttpRequest parameters and response handling
        #
        #   @function   BaseService
        #   @params     {Object}    params              Parameter dictionary
        #       @param  {String}    params.name         The name of the services (ex. FindAddress)
        #       @param  {String}    params.url          The url for the service (ex. /b2c/generic/findAddress)
        #       @param  {String}    params.type         The type of response (ex. xml, json, text)
        #       @param  {String}    params.method       The method used for the request (ex. POST/GET)
        #       @param  {String}    params.hostType     The madLib host mapping type of host (default: api)
        ###
        constructor: ( params = {} ) ->
            @name = params.name or "BaseService"

            # Service location URL and type
            #
            @url      = params.url or "/unknown"
            @type     = params.type or "json"

            # Default call method. Can be overridden for each call
            #
            @method   = params.method or "GET"

            # hostMapping host type
            #
            @hostType = params.hostType or "api"

            # Response can also be provided to restore a previously stored service call
            #
            @response = params.response or undefined

        ###*
        #   Performs the actual service call for the service
        #
        #   @function   call
        #   @params     {Object}    settings    Madlib settings instance. Used for XHR, hostMapping and cross-domain resolving.
        #   @params     {String}    requestBody The request content
        #   @return     {Promise}
        ###
        call: ( settings, requestBody, urlFragments = {} ) ->
            deferred = Q.defer()

            hostMapping = new HostMapping( settings )
            apiHost     = hostMapping.getHostName( @hostType )
            headers     = {}
            contentType

            if @type is "json"
                contentType = "application/json"

            # Prepare the call URL
            #
            url = @url

            # Replace any URL fragments we might have
            #
            for urlFragment, urlValue of urlFragments
                url = url.replace( ":#{urlFragment}", urlValue )

            # Add user token if set
            #
            userToken = settings.get( "userToken" )
            if userToken?
                headers.Authorization = "bearer #{userToken}"

            console.log( "[#{@name}] Calling service #{apiHost}#{url}", requestBody )

            xhr = new XHR( settings )
            xhr.call(
                url:            "#{apiHost}#{url}"
                method:         @method
                type:           @type
                data:           JSON.stringify( requestBody )
                headers:        headers
                contentType:    contentType
            )
            .then(
                # Success response
                #
                ( data ) =>
                    responseStatus = parseInt( data.status, 10 )
                    console.log( "[#{@name}] Service call completed", responseStatus )

                    @response = data

                    # Perform any needed response processing
                    #
                    @response.response = @processResponse( data.response )

                    deferred.resolve( @response )
            ,
                # Error response
                #
                ( error ) =>
                    console.log( "[#{@name}] Service call error", error )
                    deferred.reject( error )
            )
            .done()

            return deferred.promise

        ###*
        #   Response processing function. Override to perform custom processing.
        #
        #   @function   processResponse
        #   @params     {Mixed}     response    The service response that is to be processed
        #   @return     {Mixed}     The processed response
        ###
        processResponse: ( response ) ->
            return response

        ###*
        #   Response processing function. Override to perform custom processing.
        #
        #   @function   getResponse
        #   @return     {Mixed}     The service response if available
        ###
        getResponse: () ->
            return @response.response

        ###*
        #   Used to format a JavaScript date as an RFC date string
        #   Momentjs is used for the actual formatting
        #
        #   @function   formatXSDDate
        #   @params     {Date}      date    The date to be formatted
        #   @return     {String}    The formatted date string
        ###
        formatXSDDate: ( date ) ->
            # We need a date as input
            #
            return date if not _.isDate( date )

            # Formats a date object for usage in services
            #
            return moment( date ).format( "YYYY-MM-DD" )

        ###*
        #   Used to format a JavaScript date as an RFC date/time string
        #   Momentjs is used for the actual formatting
        #
        #   @function   formatXSDDateTime
        #   @params     {Date}      date    The date to be formatted
        #   @return     {String}    The formatted date/time string
        ###
        formatXSDDateTime: ( date ) ->
            # We need a date as input
            #
            return date if not _.isDate( date )

            # Formats a date object for usage in services
            #
            return moment( date ).format( "YYYY-MM-DDTHH:mm:ss" )
)
