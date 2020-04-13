path = require('path')
gulp = require('gulp')
mocha = require('gulp-mocha')
gutil = require('gulp-util')
coffee = require('gulp-coffee')

OPTIONS =
	files:
		coffee: [ 'lib/**/*.coffee', 'tests/**/*.spec.coffee', 'gulpfile.coffee' ]
		app: 'lib/**/*.coffee'
		tests: 'tests/**/*.spec.coffee'

gulp.task 'coffee', ->
	gulp.src(OPTIONS.files.app)
		.pipe(coffee(bare: true, header: true)).on('error', gutil.log)
		.pipe(gulp.dest('build/'))

gulp.task 'test', ->
	gulp.src(OPTIONS.files.tests, read: false)
		.pipe(mocha({
			require: ['coffeescript/register']
			reporter: 'min'
		}))

gulp.task 'build', gulp.series [
	'coffee'
	'test'
]

gulp.task 'watch', gulp.series 'build', ->
	gulp.watch(OPTIONS.files.coffee, [ 'build' ])
