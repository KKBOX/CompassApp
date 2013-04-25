HTTP Parser
===========

This is a parser for HTTP written in Java, based quite heavily on
the Ryan Dahl's C Version: `http-parser` available here:

  http://github.com/ry/http-parser

It parses both requests and responses. The parser is designed to be used
in performance HTTP applications. 

Features:

  * No dependencies (probably won't be able to keep it up)
  * Handles persistent streams (keep-alive).
  * Decodes chunked encoding.
  * Upgrade support

The parser extracts the following information from HTTP messages:

  * Header fields and values
  * Content-Length
  * Request method
  * Response status code
  * Transfer-Encoding
  * HTTP version
  * Request path, query string, fragment
  * Message body

Building
--------

use `ant compile|test|jar`

Usage
-----

  TODO: in the present form, usage of the Java version of the parser
  shouldn't be too difficult to figure out for someone familiar with the
  C version.

  More documentation will follow shortly, in case you're looking for an
  easy to use http library, this lib is probably not what you are
  looking for anyway ...

  All text after this paragraph (and most of the text above it) are from
  the original C version of the README and are currently only here for
  reference. In case you encounter any difficulties, find bugs, need
  help or have suggestions, feel free to contact me at
  (tim.becker@kuriositaet.de).

