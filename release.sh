#!/bin/sh

# Define all versions
source ./versions.sh

cp api.erb ../release/api/$BACKEND.erb
cp iuweb.erb ../release/iuweb/$INTERNAL.erb
cp ssweb.erb ../release/ssweb/$SELFSERVE.erb
cp address.erb ../release/address-service/$ADDRESS_SERVICE.erb


# create tar for olcs-addressbase (address ETL scripts)
rm -rf olcs-addressbase
git clone git@gitlab.inf.mgt.mtpdvsa:olcs/olcs-addressbase.git
cd olcs-addressbase
git checkout $ADDRESS_ETL
tar -czvf ../../release/olcs-addressbase/$ADDRESS_ETL.tar.gz *
cd ..

# create tar for olcs-elasticsearch scripts
rm -rf olcs-elasticsearch
git clone git@gitlab.inf.mgt.mtpdvsa:olcs/olcs-elasticsearch.git
cd olcs-elasticsearch
git checkout $ELASTIC
tar -czvf ../../release/olcs-elasticsearch/$ELASTIC.tar.gz *
cd ..

# OpenAM NB This openAM bit hasn;t been tested Mat 26 Feb 2016
rm -rf olcs-oa
git clone git@gitlab.inf.mgt.mtpdvsa:olcs/olcs-oa.git
cd olcs-oa
git checkout $OPENAM_CONFIG
tar -czvf ../../release/olcs-oa/openam-$OPENAM.tar.gz openam/*
tar -czvf ../../release/olcs-oa/opendj-$OPENAM.tar.gz opendj/*
tar -czvf ../../release/olcs-oa/openam-config-$OPENAM_CONFIG.tar.gz environments/aws/*
cd ..


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
olcs-addressbase/$ADDRESS_ETL.tar.gz \
address-service/$ADDRESS_SERVICE.erb \
address-service/$ADDRESS_SERVICE.tar.gz \
olcs-elasticsearch/$ELASTIC.tar.gz \
olcs-etl/$ETL.tar.gz \
txc/$TXCHANGE.war \
olcs-oa/openam-config-$OPENAM_CONFIG.tar.gz \
olcs-oa/opendj-$OPENAM.tar.gz \
olcs-oa/openam-$OPENAM.tar.gz
