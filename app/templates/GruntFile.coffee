module.exports = (grunt) ->

  # Project configuration
  #
  grunt.initConfig
    pkg:    grunt.file.readJSON( "package.json" )

    clean:
        dist:
            src: [ "lib" ]

    coffee:
      default:
        files: [
            expand: true            # Enable dynamic expansion.
            cwd: "src/"             # Src matches are relative to this path.
            src: [ "**/*.coffee" ]  # Actual pattern(s) to match.
            dest: "lib/"            # Destination path prefix.
            ext: ".js"              # Dest filepaths will have this extension.
        ]

    watch:
        src:
            files: [ "src/**/*.coffee" ]
            tasks: [ "coffee" ]

    coffeelint:
        options:
            configFile: 'coffeelint.json'

        default:
            files:
                src:    [ "src/**/*.coffee" ]

    mochaTest:
        test:
            options:
                reporter:   "spec"
                require:    "coffee-script"
                timeout:    30000
            src: [ "test/**/*.js", "test/**/*.coffee" ]

    # These plugins provide the necessary tasks
    #
    grunt.loadNpmTasks "grunt-coffeelint"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-compress"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-mocha-test"

    # Default tasks
    #
    grunt.registerTask "default", [ "clean", "coffeelint", "coffee" ]
    grunt.registerTask "test",    [ "clean", "coffeelint", "coffee", "mochaTest" ]
