#!/bin/bash

if [ $# -ne 2 ]; then
	echo "usage : $0 <old attribute> <new attribute>"
	exit 1
fi

OLDATTR="${1}"
NEWATTR="${2}"

LDAPHOST=example.com
LDAPBASE="DC=example,DC=com"
LDAPFILTER="(objectclass=user)"

for OLDID in $(grep -Rh --exclude-dir=.git "gerrit:" .|sed -e "s/.*gerrit:\(.*\)\"\]/\1/"); do
	NEWID=$(ldapsearch -LLL -o ldif-wrap=no -h ${LDAPHOST} -s sub -b ${LDAPBASE} "(&${LDAPFILTER}(${OLDATTR}=${OLDID})(${NEWATTR}=*))" dn ${NEWATTR} 2>&1 |grep ${NEWATTR}|sed -e "s/${NEWATTR}: //")
	if [ "x${NEWID}" = "x" ]; then
		echo "skipping ${OLDID} : no ${NEWATTR} entry"
		continue
	else
		echo "updating ${OLDID} with ${NEWID}"
		$(dirname ${0})/update-username.sh ${OLDID} ${NEWID}
	fi
done	
