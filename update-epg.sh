#!/bin/bash
# Update CherryEPG db with WebGrab++


function send_telegram {

        DATUM=$(date +%k:%M%t%d.%m.%Y)
        DATUM=$(echo $DATUM|tr -s '\n' ' ')
        curl -s -i -X POST "https://api.telegram.org/bot293473042:AAEeyWkTLdDfEKm07_UaDvgPR1nRUH9yRXM/sendMessage?chat_id=-185459335&parse_mode=html&text=$1 - %0A$DATUM"

}


# update dtv file using WebGrab++
/home/yuvideo/.wg++/run.sh

grep 'Unhandled Exception' /home/yuvideo/update-epg.log >> /dev/null && send_telegram "WebGrab prekinuo grebovanje zbog exception, proveri log."

NOSHOW_LIST=$(grep -B 2 'no shows' /home/yuvideo/update-epg.log | grep xmltv_id=)
SEND=$(echo $NOSHOW_LIST | grep -oP 'xmltv_id=\K.+?(?=\))' | tr '\n' ', ')
[ -z "$SEND" ] || send_telegram "Za ove kanale nema emisija: $SEND"

sudo su - -c \
'rm /var/lib/cherryepg/stock/*.xml && cp /home/yuvideo/.wg++/xml/wg_dtv.xmltv /var/lib/cherryepg/stock/wg_dtv.xml &&
cd /var/lib/cherryepg/stock &&
/var/lib/cherryepg/cherryTool/bin/guideSplitter /var/lib/cherryepg/stock/wg_dtv.xml' cherryepg
~                                                                                                     
