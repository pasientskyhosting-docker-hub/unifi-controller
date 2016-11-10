#!/bin/bash
/usr/bin/java -Dapple.awt.UIElement=true -Xmx${UNIFI_XMXMEM:-1024}M -jar /usr/lib/unifi/lib/ace.jar $1