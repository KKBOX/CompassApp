#!/bin/bash 
cp packages/compass.app.windows* packages/compass.app.windows.$1.zip
cp packages/compass.app.osx* packages/compass.app.osx.$1.zip
cp packages/compass.app.linux* packages/compass.app.linux.$1.zip
ls -lot packages
