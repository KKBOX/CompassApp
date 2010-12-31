#!/bin/sh
if [ "$1" = "full" ]; then
  rm `pwd`/lib/java/swt*
  cp `pwd`/lib/swt/swt_osx32.jar `pwd`/lib/java/swt.jar
  rake rawr:clean
fi
rake rawr:jar
java -d32 -client -Xverify:none -XstartOnFirstThread -Xbootclasspath/a:lib/java/jruby-complete.jar -jar package/jar/compass-app.jar
