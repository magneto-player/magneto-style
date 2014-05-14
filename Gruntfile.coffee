"use strict"

module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  require("time-grunt") grunt

  # Configurable paths
  config =
    app: "app"
    dist: "dist"

  # Define the configuration for all the tasks
  grunt.initConfig

    # Project settings
    config: config

    # Watches files for changes and runs tasks based on the changed files
    watch:
      bower:
        files: ["bower.json"]
        tasks: ["bowerInstall"]

      js:
        files: ["<%= config.app %>/scripts/{,*/}*.js"]
        tasks: ["jshint"]
        options:
          livereload: true

      jstest:
        files: ["test/spec/{,*/}*.js"]
        tasks: ["test:watch"]

      gruntfile:
        files: ["Gruntfile.js"]

      sass:
        files: ["<%= config.app %>/**/*.{scss,sass}"]
        tasks: ["sass:server"]

      livereload:
        options:
          livereload: "<%= connect.options.livereload %>"

        files: [
          "<%= config.app %>/{,*/}*.html"
          ".tmp/styles/{,*/}*.css"
          "<%= config.app %>/images/{,*/}*"
        ]


    # The actual grunt server settings
    connect:
      options:
        port: 9000
        open: true
        livereload: 35729

        # Change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [
              connect.static(".tmp")
              connect().use("/bower_components", connect.static("./bower_components"))
              connect.static(config.app)
            ]

      test:
        options:
          open: false
          port: 9001
          middleware: (connect) ->
            [
              connect.static(".tmp")
              connect.static("test")
              connect().use("/bower_components", connect.static("./bower_components"))
              connect.static(config.app)
            ]


    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            "<%= config.dist %>/*"
            "!<%= config.dist %>/.git*"
          ]
        ]

      server: ".tmp"


    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: ".jshintrc"
        reporter: require("jshint-stylish")

      all: [
        "Gruntfile.js"
        "<%= config.app %>/scripts/{,*/}*.js"
        "!<%= config.app %>/scripts/vendor/*"
        "test/spec/{,*/}*.js"
      ]


    # Mocha testing framework configuration options
    mocha:
      all:
        options:
          run: true
          urls: ["http://<%= connect.test.options.hostname %>:<%= connect.test.options.port %>/index.html"]


    # Compiles Sass to CSS and generates necessary files if requested
    sass:
      options:
        includePaths: ["bower_components"]

      dist:
        files: [
          expand: true
          cwd: "<%= config.app %>/styles"
          src: ["*.scss"]
          dest: "<%= config.dist %>/styles"
          ext: ".css"
        ]

      server:
        options:
          includePaths: ["bower_components"]
          imagePath: "/images"

        files: [
          expand: true
          cwd: "<%= config.app %>/styles"
          src: ["*.scss"]
          dest: ".tmp/styles"
          ext: ".css"
        ]

    # Automatically inject Bower components into the HTML file
    bowerInstall:
      app:
        src: ["<%= config.app %>/index.html"]
        exclude: ["bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap.js"]

      sass:
        src: ["<%= config.app %>/styles/{,*/}*.{scss,sass}"]

    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= config.app %>"
          dest: "<%= config.dist %>"
          src: [
            "bower_components/**/*.css",
            "bower_components/video.js/font/*",
            "styles/fonts/{,*/}*.*",
            "images/*"
          ]
        ]


    # Run some tasks in parallel to speed up build process
    concurrent:
      server: ["sass:server"]
      test: [""]
      dist: ["sass"]

    release:
      options:
        npm: false

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "connect:dist:keepalive"
      ])
    grunt.task.run [
      "clean:server"
      "concurrent:server"

      "connect:livereload"
      "watch"
    ]
    return

  grunt.registerTask "server", "serve"

  grunt.registerTask "test", (target) ->
    if target isnt "watch"
      grunt.task.run [
        "clean:server"
        "concurrent:test"
      ]

    grunt.task.run [
      "connect:test"
      "mocha"
    ]
    return

  grunt.registerTask "build", [
    "clean:dist"
    "concurrent:dist"
    "copy:dist"
  ]
  grunt.registerTask "default", [
    "newer:jshint"
    "test"
    "build"
  ]
