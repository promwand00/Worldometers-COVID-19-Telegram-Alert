#!/bin/bash
# Worldometers COVID-19 Telegram Alert
# By github.com/panophan

COUNTRY="Indonesia"
TELEGRAM_API_KEY=""
TELEGRAM_CHAT_ID=""

function sendTelegram() {
	printf "Worldometers COVID-19 Alert\n\n" > worldometers-data.tmp
	printf "**$COUNTRY** COVID-19 new reports\n\n" >> worldometers-data.tmp
	printf '```\n' >> worldometers-data.tmp
	printf "Total Cases  : $1\n" >> worldometers-data.tmp
	printf "New Cases    : $2\n" >> worldometers-data.tmp
	printf "Total Deaths : $3\n" >> worldometers-data.tmp
	printf "New Deaths   : $4\n" >> worldometers-data.tmp
	printf "Recovered    : $5\n" >> worldometers-data.tmp
	printf "Active Cases : $6\n" >> worldometers-data.tmp
	printf '```\n' >> worldometers-data.tmp
	printf "Data by worldometers.info\n" >> worldometers-data.tmp
	cat worldometers-data.tmp
	echo ""
	urldata=$(python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1])" "$(cat worldometers-data.tmp)")
	rm worldometers-data.tmp
	curl -s "https://api.telegram.org/bot${TELEGRAM_API_KEY}/sendMessage?chat_id=${TELEGRAM_CHAT_ID}&parse_mode=Markdown&text=${urldata}%20-%20Source%20github.com%2Fpanophan"
}

LASTUPDATEFILE=".worldometers-corona.log"

RAW=$(curl -s "https://www.worldometers.info/coronavirus/" | sed 's/<tr/\n<tr/g' | grep "${COUNTRY}" | grep ^'<tr' | sed 's/<td/\n<td/g' | grep -v '> </td>' | sed 's/> />/g' | sed 's/ </</g' | sed 's/<!--//g' | grep -Po '>\K.*?(?=<)' | sed ':a;N;$!ba;s/\n/|/g')

TC=$(echo ${RAW} | awk -F '|' '{print $2}')
NC=$(echo ${RAW} | awk -F '|' '{print $4}')
TD=$(echo ${RAW} | awk -F '|' '{print $5}')
ND=$(echo ${RAW} | awk -F '|' '{print $6}')
RC=$(echo ${RAW} | awk -F '|' '{print $7}')
AC=$(echo ${RAW} | awk -F '|' '{print $8}')

if [[ ! -z ${TC} ]]; then
	if [[ -f ${LASTUPDATEFILE} ]]; then
		CMP1=$(printf "${TC}|${NC}|${TD}|${ND}|${RC}|${AC}" | md5sum | awk '{print $1}')
		CMP2=$(md5sum ${LASTUPDATEFILE} | awk '{print $1}')
		if [[ ${CMP1} != ${CMP2} ]]; then
			sendTelegram "${TC}" "${NC}" "${TD}" "${ND}" "${RC}" "${AC}"
			printf "${TC}|${NC}|${TD}|${ND}|${RC}|${AC}" > ${LASTUPDATEFILE}
		fi
	else
		sendTelegram "${TC}" "${NC}" "${TD}" "${ND}" "${RC}" "${AC}"
		printf "${TC}|${NC}|${TD}|${ND}|${RC}|${AC}" > ${LASTUPDATEFILE}
	fi
fi
