'use strict';
//browserify -t coffeeify  --extension=".coffee" -e lib/index.coffee -s DungeonGenerator
module.exports = function (grunt) {
  grunt.initConfig({
    browserify: {
      main: {
        src: ['lib/**/*.coffee'],
        dest: 'build/dungeon_generator.js',
        options: {
          browserifyOptions: {
            entries: './lib/index.coffee',
            // debug: true,
            transform: ['coffeeify'],
            extensions: ['.coffee'],
            standalone: 'DungeonGenerator'
          }
        }
      }
    },

    mochacli: {
      options: {
        // bail: true
      },
      all: ['test/*.coffee']
    }
  });

  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-mocha-cli');
  grunt.registerTask('test', 'mochacli');
  grunt.registerTask('build', 'browserify');
  grunt.registerTask('default', ['test', 'build']);
};