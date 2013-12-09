module.exports = (grunt) ->

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json')
    coffee: {
      glob_to_multiple: {
        expand: true
        cwd: './src'
        src: ['**/*.coffee']
        dest: './lib'
        ext: '.js'
      }
    }
    watch: {
      files: ['./src/**/*.coffee']
      tasks: ['default', 'notify:watch']
      options: {
        spawn: false
      }
    }
    notify: {
      watch: {
        options: {
          title: 'Pocket Node SDK Update'
          message: 'All source files have been recompiled.'
        }
      }
    }
  })

  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-notify')

  grunt.registerTask('default', ['coffee'])