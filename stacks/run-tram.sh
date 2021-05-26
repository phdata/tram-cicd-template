#!/bin/bash
java -cp ".:tram-provisioning.jar" \
  -Dlog4j.configurationFile=log4j2.xml \
  -Dloader.main="io.phdata.tram.App" \
  org.springframework.boot.loader.PropertiesLauncher "$@"
