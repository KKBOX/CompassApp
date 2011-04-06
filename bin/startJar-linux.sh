#!/bin/sh
if [ "$1" = "full" ]; then
  rake rawr:clean
fi
rake rawr:jar
java -client -Xverify:none  -Xbootclasspath/a:lib/java/jruby-complete.jar -jar package/jar/compass-app.jar
