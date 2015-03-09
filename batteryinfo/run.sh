sed -n '/^Statistics/,/^Statistics/p' $1 > $1.stat
sed -n '3,6p' $1.stat
egrep "^Total received|wakelock time|Signal levels|Radio types|Wifi on|Amount discharged while screen" $1.stat
# Wakelock names contains spaces and colon. Hard to parse. giving up.
# Not interested in per proc. Wifi stuff
sed -n '/0:/,/^Statistics/p' $1.stat | grep -v Statistics | grep -v "Wake lock" | grep -iv WIFI > $1.proc
./batteryinfo < $1.proc
rm $1.stat $1.proc
