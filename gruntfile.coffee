module.exports = (grunt) ->
  
  grunt.initConfig

    # codo and gh-pages should be used in conjunction
    # grunt codo
    # <check docs>
    # grunt gh-pages
    # will essentially checkout gh-pages branch, git add /docs, git commit
    # you can then rm the /docs folder
    codo: 
      options:
        title: 'Dialekt-js',
        output: 'docs/',
        inputs: ['src', 'README.md']
    
    'gh-pages': 
      options: 
        base: 'docs'
        message: 'Auto-generated commit: Updating docs'
      src: ['**/*']

  grunt.loadNpmTasks 'grunt-gh-pages'
  grunt.loadNpmTasks 'grunt-codo'

