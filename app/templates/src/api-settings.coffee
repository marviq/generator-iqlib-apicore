( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require "madlib-console"
        )
    else if typeof define is "function" and define.amd
        define( [
            "madlib-console"
        ], factory )
)( ( console ) ->

    ###*
    #   These are the global settings for the API
    #
    #   @author         mdoeswijk
    #   @class          settings
    #   @version        0.1
    ###
    settings =
        ###*
        #   Updates the provided madLib settings instance with the API settings for hostMapping and Cross-Domain purposes.
        #
        #   @function   applyTo
        #   @params     {Object}    settings    Madlib settings instance. Used for XHR, hostMapping and cross-domain resolving.
        ###
        applyTo: ( settings ) ->
            # Initialise settings for the API
            #
            console.log( "[API] Initialising and setting up host mapping with XDM support" )

            # Default API timeout is 30 seconds
            #
            settings.init( "xhr",
                "timeout": 30000
            )

            # Setup XHR host mappings
            #
            settings.init( "hostMapping",
                "www.myhost.nl":                "production"

                # Testing
                #
                "test.myhost.nl":               "testing"

                # Development
                #
                "localhost":                    "testing"

                # For local development purposes
                # Set this up in your /etc/hosts or equivalent to point to localhost
                #
                "localhost.myhost.nl":          "production"
            )

            settings.init( "hostConfig",
                "production":
                    "api":              "https://api.myhost.nl"

                "testing":
                    "api":              "http://test-api.myhost.nl:8080"
            )

            # Setup XHR host settings
            #
            settings.init( "xdmConfig",
                "api.myhost.nl":
                    cors:               false
                    xdmVersion:         3
                    xdmProvider:        "https://api.myhost.nl/xdm/v3/index.html"

                "test-api.myhost.nl":
                    cors:               false
                    xdmVersion:         3
                    xdmProvider:        "https://test-api.myhost.nl/xdm/v3/index.html"
            )
)