#!/bin/sh

# Define all versions
source ./versions.sh

cd ../release

tar -czf OLCS-$OLCS_VERSION.tar.gz \
olcs-backend/$BACKEND.tar.gz \
olcs-internal/$INTERNAL.tar.gz \
olcs-selfserve/$SELFSERVE.tar.gz \
olcs-static/$STATIC.tar.gz \
olcs-email/$EMAIL.tar.gz \
olcs-scanning/$SCANNING.tar.gz
