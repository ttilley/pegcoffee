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
        files: ['src/**/*.coffee']
        tasks: ['build']
      js:
        files: 'lib/pegcoffee.js'
        tasks: ['lint']


  grunt.loadNpmTasks task for task in [
    'grunt-contrib-watch'
    'grunt-contrib-clean'
    'grunt-coffee-redux'
    'grunt-contrib-jshint'
    'grunt-markdown'
  ]

  grunt.registerTask 'build', ['clean', 'coffeeredux']
  grunt.registerTask 'lint', ['jshint']

  grunt.registerTask 'default', ['build', 'lint']
