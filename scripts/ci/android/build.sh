#!/bin/bash
set -ev
ROOT=${TRAVIS_BUILD_DIR:-"$( cd "$(dirname "$0")/../../.." ; pwd -P )"}
export ANDROID_NDK_HOME=$(cd ~/$NDK_DIR && pwd)

if [ -z ${GRADLE_TARGET+x} ]; then
    GRADLE_TARGET=compileArm7DebugSources
fi

gradle wrapper --gradle-version 3.3

~/projectGenerator/projectGenerator_linux -p"android" -o"$ROOT" $ROOT/examples/android/androidEmptyExample
~/projectGenerator/projectGenerator_linux -p"android" -o"$ROOT" $ROOT/examples/android/androidOpenCVExample
~/projectGenerator/projectGenerator_linux -p"android" -o"$ROOT" $ROOT/examples/android/androidAssimpExample

echo "ANDROID_NDK_HOME: $ANDROID_NDK_HOME"
echo "org.gradle.caching=true" > $ROOT/examples/android/androidEmptyExample/gradle.properties
echo "org.gradle.caching=true" > $ROOT/examples/android/androidOpenCVExample/gradle.properties
echo "org.gradle.caching=true" > $ROOT/examples/android/androidAssimpExample/gradle.properties

./gradlew -b $ROOT/examples/android/androidEmptyExample/build.gradle $GRADLE_TARGET
./gradlew -b $ROOT/examples/android/androidOpenCVExample/build.gradle $GRADLE_TARGET
./gradlew -b $ROOT/examples/android/androidAssimpExample/build.gradle $GRADLE_TARGET
