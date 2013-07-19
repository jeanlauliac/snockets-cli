# # Snockets CLI Compiler
#
# This tool is used to:
#
# * compile coffee file to JS files using the
#   [Snockets](https://github.com/pthrasher/snockets) library;
# * generate a Makefile-compatible dependency file at the same time.
#
# The Snocket library does not provide a CLI tool, this script fill thus the
# lack. A CLI tool is needed so we can call it from a build system, notably.
# Dependency determination is needed as well so that the build system can
# provide consistent minimal recompilation. Eg: the Ninja build system.
'use strict'
require('source-map-support').install()
Snockets    = require 'snockets'
fs          = require 'fs'
commander   = require 'commander'
log         = require('yadsil')('snockets')

# Process CLI arguments and return the commander.js instance.
processCli = ->
    commander
        .usage('<in> [options]')
        .option('--minify',            'minify output with uglifyJS')
        .option('-o, --output <file>', 'output the result in a file')
        .option('--dep-file <file>',
                'generate a Makefile-compatible dependency file')
        .option('--color', 'force color display out of a TTY')
        .parse(process.argv)
    log.color commander.color
    log.fatal 2, 'no enough file arguments' if commander.args.length < 1
    log.fatal 2, 'too many file arguments' if commander.args.length > 1
    commander

# Write a Makefile dependency file.
writeDepFile = (snockets, sourcePath, depfile) ->
    chain = snockets.scan(sourcePath, {async: false}).getChain(sourcePath)
    deps = "#{sourcePath}: #{chain.join(' ')}"
    fs.writeFileSync(depfile, deps)

# Entry point of the script. It directly uses Snockets feature to concatenate
# the scripts and get the dependency list.
module.exports = ->
    commander = processCli()
    sourcePath = commander.args[0]
    targetPath = commander.output
    try
        snockets = new Snockets()
        if commander.depFile?
            writeDepFile snockets, sourcePath, commander.depFile
        js = snockets.getConcatenation sourcePath, {
            async: false, \
            minify: commander.minify}
        if targetPath?
            fs.writeFileSync(targetPath, js)
            return
        process.stdout.write js
    catch ex
        log.fatal 1, ex.message
