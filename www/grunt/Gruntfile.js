/**
 * npm install
 */
module.exports = function(grunt) {
		var pkg = grunt.file.readJSON('package.json');
		var RELATIVE_HTDOCS_DIR = '../htdocs/';
		var ASSETS_DIR = RELATIVE_HTDOCS_DIR + '/assets';
		grunt.initConfig({
				pkg: pkg,
				dir: {
						dev: RELATIVE_HTDOCS_DIR,
						assets: ASSETS_DIR,
						prod:'../htdocs.prod'
				},
				getProductDir: function () {
					var date = new Date ();
					var now =  date.getFullYear()
						+ '-' + (date.getMonth() + 1)
						+ '-' + date.getDate ()
						+ '.' + date.getHours ()
						+ '-' + date.getMinutes()
						+ '-' + date.getSeconds();
					return this.dir.prod + '/' + now + '.htdocs';
				},
				copy: {
					prod: {
						expand: true,
						cwd: '<%= dir.dev %>/',
						src: ['**/*'],
						dest: '<%= getProductDir() %>'
					}
				},
				// js文法チェック
				 jshint: {
					 options: {
						 //jshintrc: '<%= dir.dev %>/<%= dir.js %>/.jshintrc'
					 },
					 src: {
						src: '<%= dir.dev %>/**/*.js'
					 }
				 },
				// CSS文法チェック
				csslint: {
						check: {
							expand: true,
							src: '<%= dir.dev %>/**/*.css',
						}
				},
				// ベンダープレフィックス
				autoprefixer: {
					options: {
						browsers: ['last 2 version', 'ie 8', 'ie 9']
					},
					files: {
						expand: true,
						flatten: true,
						src: '<%= dir.dev %>/**/*.css'
					}
				},
				// HTMLを圧縮
				htmlmin: {
						prod: {
								options: {
										removeComments: true,
										removeCommentsFromCDATA: true,
										removeCDATASectionsFromCDATA: true,
										collapseWhitespace: true,
										removeRedundantAttributes: true,
										removeOptionalTags: true
								},
								expand: true,
								src: '<%= dir.prod %>/**/*.html'
						}
				},
				 // JSを圧縮
				uglify: {
						all: {
							expand: true,
							src: '<%= dir.prod %>/**/*.js'
						}
				},
				// CSSを圧縮
				cssmin: {
						all: {
							expand: true,
							src: '<%= dir.prod %>/**/*.css'
						}
				},
				// 不要なファイルを削除
				clean: {
				},
				// Compassの設定
				compass: {
						dist: {
								options: {
									httpPath: '/',
									basePath: '<%= dir.assets %>/',
									sassDir: 'sass/',
									javascriptDir: 'js/',
									imagesDir: 'img/',
									cssDir: 'css/',
									environment: 'production',
								}
						}
				},
				// ファイルを監視
				watch: {
						html: {
								files: '<%= dir.dev %>/**/*.html',
								tasks: [],
								options: {
										nospawn: true
								}
						},
						js: {
								files: '<%= dir.dev %>/**/*.js',
								tasks: [],
								options: {
										nospawn: true
								}
						},
						sass: {
								files: '<%= dir.dev %>/**/*.scss',
								tasks: ['compass'],
								options: {
										nospawn: true
								}
						}
				},
				open: {
				},
		});

		// package.jsonに記載されているパッケージを自動読み込み
		for(var taskName in pkg.devDependencies) {
				if(taskName.substring(0, 6) == 'grunt-') {
						grunt.loadNpmTasks(taskName);
				}
		}

		// コマンド定義
		grunt.registerTask('default', ['watch']);
		// lint系
		grunt.registerTask('jslint', ['jshint']);
		grunt.registerTask('csslint', ['csslint']);
		grunt.registerTask('lint', ['csslint', 'jshint']);

		// 納品版ミニファイデータ書き出し
		grunt.registerTask('prod-min',
		[
		'copy:prod',
		'htmlmin',
		'cssmin',
		'uglify',
		]);

		grunt.registerTask('eatwarnings', function() {
				grunt.warn = grunt.fail.warn = function(warning) {
						grunt.log.error(warning);
				};
		});
};
