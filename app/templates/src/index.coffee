( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require "madlib-console"
            require "madlib-settings"
            require "madlib-hostmapping"
            require "q"
            require "./api-settings"
        )
    else if typeof define is "function" and define.amd
        define( [
            "madlib-console"
            "madlib-settings"
            "madlib-hostmapping"
            "q"
            "./api-settings"
        ], factory )
)( ( console, settings, HostMapping, Q, defaultSettings, services... ) ->

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
            console.log( "[API] Using own settings" )
            api.settings = settings

        # Initialise the settings for the API
        #
        defaultSettings.applyTo( api.settings )

        # Create our hostMapping instance
        #
        api.hostMapping = new HostMapping( api.settings )

        # Create the service mapping
        #
        for service in services 
            if service.name 
                serviceMapping[ service.name ] = service
            else 
                console.warn( "[API] Service supplied without an name" )


        # Mark the API as initialised
        #
        api.initialised = true

    api.call = ( serviceName, params = {} ) ->
        # First check if the API has been properly initialised
        #
        if not api.initialised
            console.log( "[API] Auto-initialising due to service call: #{serviceName}" )
            api.init()

        # Find the correct service to call
        #
        Service = serviceMapping[ serviceName ]

        # If the service was found call it
        #
        if service 
            return new Service().call( api.settings, params )

        # Unknown service call
        #
        else
            console.log( "[API] Unknown service called: #{serviceName}" )
            deferred = Q.defer()
            deferred.reject(
                status:     404
                statusText: "unknown service #{serviceName}"
                request:    serviceName
                response:   null
            )

            # Abort due to error
            #
            return deferred.promise

    return api
)
