#!/bin/ksh
# https://antonyfb.com/blog/my-cwm-config.html
getbatt() {
	BATTERY=$(apm -l)
	STATUS=$(apm -b)
	echo -n "$BATTERY"
	[ $STATUS == "3" ] && echo -n " +"
}

getlight() {
	LIGHT=$(xbacklight -get | sed 's/\..*//')
	echo -n "light $LIGHT"
}

getvol() {
	MUTE=$(sndioctl output.mute | sed 's/.*=//')
	VOL=$(sndioctl output.level | sed 's/.*=//')
	if [ $MUTE = 1 ] ; then
	echo -n "muted"
	else
	echo -n "vol $VOL"
	fi
}

while true ; do
	echo " ${r}$(getbatt)  $(getlight)  $(getvol)"
	sleep 1
done
