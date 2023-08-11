#variables declaration
sender="loganpq@gmail.com"
receiver="loganpq@gmail.com"
subject='Changes in IPs'
body='Attached is denoting the changes in ips'
gapp= source "/home/logan/Documents/gapp"
pids=""
FILE=/home/logan/scriptoutputs/$(date --date ' 2 days ago' '+%F')ips.txt
todaysips=/home/logan/scriptoutputs/$(date +F%)ips.txt
yesterdaysips=/home/logan/scriptoutputs/$(date --date ' 1 days ago' '+%F')ips.txt
changesinips=/home/logan/scriptoutputs/$(date +%F)changesinips.txt

for ip in {1..254}
do
    ping -i 0.2 -c1 192.168.1.$ip >/dev/null 2>&1 && echo "Success for 192.168.1.$ip" > $todaysips &
done
pids="$pids $!"
wait $pids
diff $todaysips $yesterdaysips >> $changesinips

#housekeeping--removing old log files from two days ago.
test -f $FILE
echo $?
if [ $? -eq 1 ]
then
    rm -r $FILE
fi
#sending email of reports
curl -v --ssl-reqd \
--url 'smtps://smtp.gmail.com:465' \
--user $sender:$gapp \
--mail-from "$sender"\
--mail-rcpt "$receiver" \
-d "@$changesinips" \
From: "$sender" \
To: " $receiver"\
Subject: "$subject"
echo "$body"