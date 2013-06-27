#!/bin/sh
if [ "$1" = "full" ]; then
  bundle exec rake rawr:clean
fi
bundle exec rake rawr:jar
#java -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -Djruby.reify.classes=true -Djruby.compat.version="1.9" \
#java -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -Djruby.reify.classes=true  \
#java -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails  -Xms512m -Xmn128m \
java -XX:-UseParallelOldGC -XX:NewRatio=4  -Xmx384m -Xms128m -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails  \
-client -Xverify:none  -Xbootclasspath/a:lib/java/jruby-complete.jar -jar package/jar/compass-app.jar
