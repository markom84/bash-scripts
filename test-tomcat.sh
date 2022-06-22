#!/bin/bash

totalstatus=1

echo "Starting Tomcat instances check"

URLDEV="https://tomcat-dev.example.com:8443"

URLTEST="https://tomcat-test.example.com:8443"
URLSTAGING="https://tomcat-staging.example.com:8443"

curl -s -o /dev/null -m 3 $URLDEV && echo "DEV instance up"
devstatus=$?

curl -s -o /dev/null -m 3 $URLTEST && echo "TEST instance up"
teststatus=$?

curl -s -o /dev/null -m 3 $URLSTAGING && echo "STAGING instance up"
stagingstatus=$?

HOSTRE="\/\/(.*):"

while [ $totalstatus -ne 0 ]
do

        #nc $([[ $URLDEV =~ $HOSTRE ]] && echo ${BASH_REMATCH[1]}) 8443 -w 1
        #PORTOPEN=$?
        if [ $devstatus -ne 0 ] # && [ $PORTOPEN -eq 0 ]
        then
#       echo "Checking DEV instance..."
        curl -s -o /dev/null -m 3 $URLDEV && echo "DEV instance up"
        devstatus=$?
        fi


        if [ $teststatus -ne 0 ]
        then
#       echo "Checking TEST instance..."
        curl -s -o /dev/null -m 3 $URLTEST && echo "TEST instance up"
        teststatus=$?
        fi


        if [ $stagingstatus -ne 0 ]
        then
#       echo "Checking STAGING instance..."
        curl -s -o /dev/null -m 3 $URLSTAGING && echo "STAGING instance up"
        stagingstatus=$?
        fi


        if [ $teststatus -eq 0 ] && [ $stagingstatus -eq 0 ] && [ $devstatus -eq 0 ]
        then
        totalstatus=0
        fi
done
echo "All Tomcat instances up, exiting"
