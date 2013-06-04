module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean:
      lib: ['lib']

    coffeeredux:
      options:
        bare: no
        sourceMap: no
      compile:
        files: [
          expand: yes
          cwd: 'src/'
          src: ['**/*.coffee']
          dest: 'lib/'
          ext: '.js'
        ]

    jshint:
      options:
        jshintrc: '.jshintrc'
      main: 'lib/pegcoffee.js'

    watch:
      coffee:
        files: [
          'src/**/*.coffee'
          'test/**/*.coffee'
        ]
        tasks: ['test', 'build']
      js:
        files: 'lib/pegcoffee.js'
        tasks: ['lint']

    mochacli:
      options:
        require: ['should']
        compilers: ['coffee:coffee-script']
        reporter: 'spec'
      coffee: ['test/*.coffee']

  grunt.loadNpmTasks task for task in [
    'grunt-contrib-watch'
    'grunt-contrib-clean'
    'grunt-coffee-redux'
    'grunt-contrib-jshint'
    'grunt-markdown'
    'grunt-mocha-cli'
  ]

  grunt.registerTask 'test', ['mochacli']
  grunt.registerTask 'build', ['clean', 'coffeeredux']
  grunt.registerTask 'lint', ['jshint']

  grunt.registerTask 'default', ['test', 'build', 'lint']
