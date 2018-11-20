#!/usr/bin/env bash

set -ex
native-image -ea --no-server -H:Name=jpc-graal -H:Class=com.github.joostvdg.demo.App -H:+ReportUnsupportedElementsAtRuntime --static --verbose -cp target/*:target/lib/*


