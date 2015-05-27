# generator-iqlib-apicore

[![npm version](https://badge.fury.io/js/generator-iqlib-apicore.svg)](http://badge.fury.io/js/generator-iqlib-apicore)
[![David dependency drift detection](https://david-dm.org/marviq/generator-iqlib-apicore.svg)](https://david-dm.org/marviq/generator-iqlib-apicore)

A [Yeoman](http://yeoman.io) based generator for madlib based webapps.


## Getting Started
First make sure yo and and the generator are installed:
```bash
$ npm install -g yo generator-iqlib-apicore
```

You may need to have sudo permissions to install globally.
After that you can create a new madlib module by creating a folder and then using the following command:
```bash
$ yo iqlib-apicore
```

Yeoman will appear and ask you a few questions. Once they have been answered he will generate the required files to get started.

## Using the api
When you want to use the api you need to supply it with a madlib-settings which contains the following settings:

* You can leave out the hostMapping if you want, then you will need to supply the setting:

overrideMapping: "environment"   ( hostConfig option, for example testing )

```bash
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
```


### What is Yeoman?

Trick question. It's not a thing. It's this guy:

![](http://i.imgur.com/JHaAlBJ.png)

Basically, he wears a top hat, lives in your computer, and waits for you to tell him what kind of application you wish to create.

Not every new computer comes with a Yeoman pre-installed. He lives in the [npm](https://npmjs.org) package repository. You only have to ask for him once, then he packs up and moves into your hard drive. *Make sure you clean up, he likes new and shiny things.*

```
$ npm install -g yo
```

### Yeoman Generators

Yeoman travels light. He didn't pack any generators when he moved in. You can think of a generator like a plug-in. You get to choose what type of application you wish to create, such as a Backbone application or even a Chrome extension.

To install generator-iqlib-apicore from npm, run:

```
$ npm install -g generator-iqlib-apicore
```

Finally, initiate the generator:

```
$ yo iqlib-apicore
```

### Getting To Know Yeoman

Yeoman has a heart of gold. He's a person with feelings and opinions, but he's very easy to work with. If you think he's too opinionated, he can be easily convinced.

If you'd like to get to know Yeoman better and meet some of his friends, [Grunt](http://gruntjs.com) and [Bower](http://bower.io), check out the complete [Getting Started Guide](https://github.com/yeoman/yeoman/wiki/Getting-Started).


## ChangeLog

Refer to the [releases on GitHub](https://github.com/marviq/madlib-iqlib-apicore/releases) for a detailed log of changes.


## License

[BSD-3-Clause](LICENSE)
