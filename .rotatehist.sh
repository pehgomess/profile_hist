#!/bin/bash

DATE=$(date +"%d-%m-%Y")
SIZE="1024"
MAIOR=`du -m /var/.HISTORY | tail -n1 | awk '{print $1}'`
if [ $MAIOR -ge $SIZE ]; then
        logger "Criate rotate hist"
        tar -cjvf /var/.HISTORY.tar.bz2_$DATE /var/.HISTORY/ >/dev/null 2>&1
else
        exit 1
fi

