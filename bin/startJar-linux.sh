#!/bin/sh
if [ "$1" = "full" ]; then
  rake rawr:clean
fi
rake rawr:jar
java -d32 -client -Xverify:none  -Xbootclasspath/a:lib/java/jruby-complete.jar -jar package/jar/compass-app.jar
