assert = require 'assert'
fs = require 'fs'
{spawn} = require 'child_process'

testWithArgs = (args, expected, callback) ->
    process = spawn 'bin/snockets', args
    output = ''
    process.stdout.on 'data', (data) ->
        output += data
    process.on 'close', (code) ->
        assert.equal code, 0
        assert.equal output, expected
        callback()

describe 'snockets-cli', ->
    it 'should compile the snockets file', (callback) ->
        testWithArgs ['test/samples/foo.coffee'],
            """
            (function() {
              console.log('bar');

            }).call(this);

            (function() {
              console.log('foo');

            }).call(this);\n
            """, callback

    it 'should compile and minify the snockets file', (callback) ->
        testWithArgs ['test/samples/foo.coffee', '--minify'], \
            '(function(){console.log("bar")}).call(this),' \
          + 'function(){console.log("foo")}.call(this)', callback

    it 'should generate dependency information', (callback) ->
        process = spawn 'bin/snockets',
            ['test/samples/baz.coffee', '--dep-file', 'test/baz.d']
        process.on 'close', (code) ->
            assert.equal code, 0
            assert.equal fs.readFileSync('test/baz.d', 'utf-8'), \
                "test/samples/baz.coffee: test/samples/bar.coffee " \
              + "test/samples/foo.coffee"
            callback()

