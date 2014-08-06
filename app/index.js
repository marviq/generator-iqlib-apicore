( function()
{
    'use strict';
    var path    = require( 'path' );
    var util    = require( 'util' );
    var path    = require( 'path' );
    var yeoman  = require( 'yeoman-generator' );

    // Determine packageName based on current folder name
    //
    var fullPath    = process.cwd();
    var packageName = fullPath.split( path.sep ).pop()

    var IqLibApicoreGenerator = module.exports = function IqLibApicoreGenerator( args, options, config )
    {
        yeoman.generators.Base.apply( this, arguments );

        this.on( 'end', function( )
        {
            this.installDependencies(
            {
                skipInstall: options[ 'skip-install' ]
            } );
        } );

        this.pkg         = JSON.parse( this.readFileAsString( path.join( __dirname, '../package.json' ) ) );
        this.currentYear = new Date().getFullYear()
    };

    util.inherits( IqLibApicoreGenerator, yeoman.generators.Base );

    IqLibApicoreGenerator.prototype.askFor = function askFor( )
    {
        var callback = this.async();

        // Have Yeoman greet the user
        //
        console.log( this.yeoman );

        // Ask the user for the webapp details
        //
        var prompts = [
            {
                name:       'packageName'
            ,   message:    'What is the name of this API core?'
            ,   default:    packageName
            }
        ,   {
                name:       'packageDescription'
            ,   message:    'What is the purpose (description) of this API core?'
            }
        ,   {
                name:       'mainName'
            ,   message:    'What is the main JavaScript file name for this API core?'
            ,   default:    'index'
            }
        ,   {
                name:       'authorName'
            ,   message:    'What is your name?'
            ,   default:    this.user.git.username
            }
        ,   {
                name:       'authorEmail'
            ,   message:    'What is your email?'
            ,   default:    this.user.git.email
            }
        ];

        this.prompt( prompts, function( props )
        {
            this.packageName        = props.packageName;
            this.packageDescription = props.packageDescription;
            this.mainName           = props.mainName;
            this.authorName         = props.authorName;
            this.authorEmail        = props.authorEmail;

            callback();
        }.bind( this ) );
    };

    IqLibApicoreGenerator.prototype.app = function app( )
    {
        // Create base folders
        //
        this.mkdir( 'src'     );
        this.mkdir( 'src/api' );
        this.mkdir( 'test'    );

        this.template( '_package.json',         'package.json'            );
        this.template( 'README.md',             'README.md'               );
        this.template( 'LICENSE',               'LICENSE'                 );

        this.copy( 'GruntFile.coffee',          'GruntFile.coffee'        );
        this.copy( 'src/index.coffee',          'src/' + this._.slugify( this.mainName ) + '.coffee' );
        this.copy( 'src/api/base.coffee',       'src/api/base.coffee'     );
    };

    IqLibApicoreGenerator.prototype.projectfiles = function projectfiles( )
    {
        this.copy( 'editorconfig',  '.editorconfig' );
        this.copy( 'jshintrc',      '.jshintrc'     );
        this.copy( 'gitignore',     '.gitignore'    );
    };
} )();
