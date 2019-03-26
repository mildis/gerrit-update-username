#!/bin/bash

SHABIN="sha1sum"

OLDID="${1}"
NEWID="${2}"

OLDEXTID=":${1}"

for OLDREF in $(grep -Rl --exclude-dir=.git "${OLDEXTID}" .); do
	OLDKEY=$(grep "${OLDEXTID}" ${OLDREF}|sed -e 's/\[externalId "\(.*\)"\]/\1/')
	NEWKEY=$(echo -n ${OLDKEY}|sed -e "s/${OLDID}/${NEWID}/")
	NEWREF=$(echo -n ${NEWKEY}|${SHABIN}|cut -d' ' -f1)

	NEWREFDIR=$(echo ${NEWREF}|cut -c -2)
	NEWREFFILE=$(echo ${NEWREF}|cut -c 3-)

	if [ ! -d ${NEWREFDIR} ]; then
		mkdir ${NEWREFDIR}
	fi

	sed -e "s/${OLDKEY}/${NEWKEY}/" ${OLDREF} > ${NEWREFDIR}/${NEWREFFILE}

	git rm -q ${OLDREF}
	git add ${NEWREFDIR}/${NEWREFFILE}
	git commit -m "update ${OLDKEY} to ${NEWKEY}"
done	
