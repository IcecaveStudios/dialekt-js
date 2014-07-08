module.exports = (grunt) ->
  
  grunt.initConfig

    # This will generate new docs for the project
    docco: 
      debug:
        src: ['README.md', 'src/**/*.coffee'],
        options: 
          output: 'docs/docco'

    # This should be used in conjuction with docco
    # grunt docco2ghpages
    # will essentially checkout gh-pages branch, git add /docs, git commit
    # you can then rm the /docs folder
    'gh-pages': 
      options: 
        base: 'docs'
        message: 'Auto-generated commit: Updating docs'
      src: ['**/*']

    codo: 
      options:
        title: 'Dialekt-js',
        output: 'docs/codo',
        inputs: ['src', 'README.md']
    
  grunt.loadNpmTasks 'grunt-docco'
  grunt.loadNpmTasks 'grunt-gh-pages'
  grunt.loadNpmTasks 'grunt-codo'

  grunt.registerTask 'docco2ghpages', ['docco', 'gh-pages']
