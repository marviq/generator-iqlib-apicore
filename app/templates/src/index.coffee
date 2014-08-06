( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require( "madlib-console" )
            require( "madlib-settings" )
            require( "madlib-hostmapping" )
            require( "q" )
            require( "http-custom-errors" )
            require( "./api/login" )
            require( "./api/addCompany" )
            require( "./api/addAdminEmployee" )
        )
    else if typeof define is "function" and define.amd
        define( [
            "madlib-console"
            "madlib-settings"
            "madlib-hostmapping"
            "q"
            "./http-custom-errors"
            "./api/login"
            "./api/addCompany"
            "./api/addAdminEmployee"
        ], factory )
)( ( console, settings, HostMapping, Q, HTTPErrors, services... ) ->

    api =
        initialised:    false
        settings:       null
        serviceMapping: {}

    api.init = ( userSettings ) ->

        # Use provided madlib-settings instance. If omitted we will use the
        # self-included version instead
        #
        if userSettings?
            console.log( "[API] Using provided settings" )
            api.settings = userSettings
        else
            throw new Error( "[API] No settings provided...." )

        # Create our hostMapping instance
        #
        api.hostMapping = new HostMapping( api.settings )

        # Create the service mapping
        #
        for service in services
            if service.name
                api.serviceMapping[ service.prototype.name ] = service
            else
                console.warn( "[API] Service supplied without an name" )

        # Mark the API as initialised
        #
        api.initialised = true

    api.call = ( serviceName, params = {} ) ->
        # First check if the API has been properly initialised
        #
        if not api.initialised
            throw new Error( "[API] Not initialized yet, tried to call service: #{serviceName}" )

        # Find the correct service to call
        #
        Service = api.serviceMapping[ serviceName ]

        # If the service was found call it
        #
        if Service
            console.log( "[API] Calling #{serviceName}" )
            return new Service( api.settings ).call( api.settings, params )

        # Unknown service call
        #
        else
            console.log( "[API] Unknown service called: #{serviceName}" )

            error = new HTTPErrors.NotFoundError( "unknown service #{serviceName}" )

            return Q.reject( error )

    return api
)
