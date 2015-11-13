#!/bin/sh

# Define all versions
source ./versions.sh

cp api.erb ../release/olcs-backend/api-$BACKEND.erb
cp iuweb.erb ../release/olcs-internal/iuweb-$INTERNAL.erb
cp ssweb.erb ../release/olcs-selfserve/ssweb-$SELFSERVE.erb

cd ../release

tar --transform='flags=r;s|\/|-|' -czf OLCS-$OLCS_VERSION.tar.gz \
olcs-backend/$BACKEND.tar.gz \
olcs-backend/api-$BACKEND.erb \
olcs-internal/$INTERNAL.tar.gz \
olcs-internal/iuweb-$INTERNAL.erb \
olcs-selfserve/$SELFSERVE.tar.gz \
olcs-selfserve/ssweb-$SELFSERVE.erb \
olcs-static/$STATIC.tar.gz \
olcs-scanning/$SCANNING.tar.gz
