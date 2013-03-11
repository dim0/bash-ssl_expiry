#!/bin/bash

SUBJECT="[CAUTION]: Your certificate for $HOSTNAME EXPIRES"
# Email To ?
EMAIL="admin@yourdomain.eu"
# Email text/message
EMAILMESSAGE="/tmp/emailcertificates.txt"
# send an email using /usr/bin/mail

CERTFILE=$1


CERTIFICATE=$1
        cert_expiry_date=$(echo "$openssl_output" \
         | openssl x509 -noout -in $CERTFILE -enddate \
         | awk -F= ' /notAfter/ { printf("%s\n",$NF); } ');

        seconds_until_expiry=$(echo "$(date --date="$cert_expiry_date" +%s) - $(date +%s)" |bc);
        days_until_expiry=$(echo "$seconds_until_expiry/(60*60*24)" |bc);

        if [ $days_until_expiry -ge 0 ]; then

                echo "$days_until_expiry days until expiration";

        else

                echo "EXPIRED ($days_until_expiry days)";

                exit 0
        fi
        if [ $days_until_expiry -le 100 ]; then
                echo "$days_until_expiry";
                rm -f $EMAILMESSAGE
                touch $EMAILMESSAGE
                echo "WARNING" >> $EMAILMESSAGE
                echo "=======" >> $EMAILMESSAGE
                echo "Your certificate for the portal via $HOSTNAME will expire in $days_until_expiry days, please make sure you perform the necessary steps to prolong the certificate" >> $EMAILMESSAGE
                echo "  " >> $EMAILMESSAGE
                echo "This mail was sent by your friendly server." >> $EMAILMESSAGE
                echo "   " >> $EMAILMESSAGE
                echo "Kind regards," >> $EMAILMESSAGE
                echo $HOSTNAME  >> $EMAILMESSAGE
                SUBJECT="[CAUTION]: Your certificate for the portal via $HOSTNAME EXPIRES in $days_until_expiry"
                /usr/bin/mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE


                exit 0
        else
                echo "Nothing to do here!!!";
        fi




