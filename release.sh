#!/bin/sh

# Define all versions
source ./versions.sh

cp api.erb ../release/api/$BACKEND.erb
cp iuweb.erb ../release/iuweb/$INTERNAL.erb
cp ssweb.erb ../release/ssweb/$SELFSERVE.erb

if [ ! -d olcs-txt ]; then
    git clone git@gitlab.inf.mgt.mtpdvsa:olcs/olcs-txc.git
fi

(cd olcs-txc && git checkout $TXCHANGE)

cp olcs-txc/txc.war ../release/txc/$TXCHANGE.war

cd ../release

tar --transform='flags=r;s|\/|-|' -czf OLCS-$OLCS_VERSION.tar.gz \
olcs-backend/$BACKEND.tar.gz \
api/$BACKEND.erb \
olcs-internal/$INTERNAL.tar.gz \
iuweb/$INTERNAL.erb \
olcs-selfserve/$SELFSERVE.tar.gz \
ssweb/$SELFSERVE.erb \
olcs-static/$STATIC.tar.gz \
olcs-scanning/$SCANNING.tar.gz \
txc/$TXCHANGE.war
