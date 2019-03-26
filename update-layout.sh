#!/bin/bash

if [ -f $(ls -d *|head -1) ]; then
	echo "Flat. Faning-out"
	for FILE in *; do
		PREFIX=$(echo -n "${FILE}"|cut -c -2)
		SUFFIX=$(echo -n "${FILE}"|cut -c 3-)
		if [ ! -d "${PREFIX}" ]; then
			mkdir "${PREFIX}"
		fi
		git mv "${FILE}" "${PREFIX}/${SUFFIX}"
	done
	git commit -m "fanout files"
else
	echo "Already fanout"
fi
