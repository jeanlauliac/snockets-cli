# snockets-cli

Snockets command-line tool. Very useful to use
[Snockets](https://npmjs.org/package/snockets) from a build system,
for example.

# Install

Most of the time:

```bash
$ npm install snockets-cli --save-dev
```

# Usage

```bash
$ node_modules/.bin/snockets --help

  Usage: snockets <in> [options]

  Options:

    -h, --help           output usage information
    --minify             minify output with uglifyJS
    -o, --output <file>  output the result in a file
    --dep-file <file>    generate a Makefile-compatible dependency file
    --color              force color display out of a TTY

$ node_modules/.bin/snockets foo.coffee -o foo.js --dep-file foo.coffee.d
```

# Limitations

Just do the bare minimum of Snockets, and only supports the concatetaned
mode. You may want to fork add some more features for your needs, in
which case, please share.

This tool won't probably support the hypothetical Snockets 2 out-of-the-box.
Here again, feel free to add the support.

# Contribute

Feel free to fork and submit pull requests.
