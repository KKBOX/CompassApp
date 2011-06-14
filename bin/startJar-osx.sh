#!/bin/sh
if [ "$1" = "full" ]; then
  rake rawr:clean
fi
rake rawr:jar
#java -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails \
#  -Xms128m  -Xmn32m -Xmx128m \
java  -d32 -client -Xverify:none -XstartOnFirstThread -Xbootclasspath/a:lib/java/jruby-complete.jar -jar package/jar/compass-app.jar
