module.exports = (grunt) ->
  
  grunt.initConfig

    # This will generate new docs for the project
    docco: 
      debug: {
        src: ['README.md', 'src/**/*.coffee'],
        options: {
          output: 'docs/'
        }
      }
    # This should be used in conjuction with docco
    # grunt docco2ghpages
    # will essentially checkout gh-pages branch, git add /docs, git commit
    # you can then rm the /docs folder
    'gh-pages': 
      options: {
        base: 'docs'
        message: 'Auto-generated commit: Updating docs'
      },
      src: ['**/*']

  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-gh-pages'

  grunt.registerTask 'docco2ghpages', ['docco', 'gh-pages']
