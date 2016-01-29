module.exports = function(grunt) {
  grunt.initConfig({

    pkg: grunt.file.readJSON('package.json'),
    sass: {
      dist: {
        files: {
          "theme/css/styles.css": "theme/css/styles.scss",
          "theme/css/checkout-styles.css": "theme/css/checkout-styles.scss",
        }
      }
    },
    cssmin: {
      pictureroom: {
        files: {
          "theme/css/styles.min.css": [
            "theme/css/bootstrap.css",
            "theme/css/styles.css"]
        }
      }
    },
    uglify: {
      scripts: {
        files: {
          "theme/js/scripts.min.js": [
            "theme/js/jquery.min.js", "theme/js/bootstrap.js",
            "theme/js/mustache.js",
            "theme/js/scripts.js"]
        }
      }
    },
    copy: {
      main: {
        files: [
          {src: 'theme/css/styles.min.css',
           dest: '/Volumes/Picture Room/pictureroom/store/themes/pictureroom/css/styles.min.css'},
          {src: 'theme/js/scripts.min.js',
           dest: '/Volumes/Picture Room/pictureroom/store/themes/pictureroom/js/scripts.min.js'},
          {src: 'theme/css/checkout-styles.css',
           dest: '/Volumes/Picture Room/pictureroom/store/themes/pictureroom/css/checkout-styles.css'}
        ]
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-copy');

  grunt.registerTask('default', [
    'sass',
    'cssmin:pictureroom',
    'uglify:scripts',
  ]);
};
