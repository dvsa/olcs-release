#!/bin/sh

# Define all versions
source ./versions.sh

#cp api.erb ../release/api/$BACKEND.erb
#cp iuweb.erb ../release/iuweb/$INTERNAL.erb
#cp ssweb.erb ../release/ssweb/$SELFSERVE.erb
#cp address.erb ../release/address-service/$ADDRESS_SERVICE.erb

# New way of doing this
cp api.erb ../release/api-$BACKEND.erb
cp iuweb.erb ../release/iuweb-$INTERNAL.erb
cp ssweb.erb ../release/ssweb-$SELFSERVE.erb
cp address.erb ../release/address-service-$ADDRESS_SERVICE.erb
cp iuauth.erb ../release/iuuath-$OPENAM_CONFIG.erb
cp ssauth.erb ../release/ssuath-$OPENAM_CONFIG.erb
cp dir.erb ../release/dir-$OPENAM_CONFIG.erb


# create tar for olcs-addressbase (address ETL scripts)
if [ ! -f ../release/olcs-addressbase/$ADDRESS_ETL.tar.gz ]; then
    rm -rf olcs-addressbase
    git clone git@gitlab.inf.mgt.mtpdvsa:sc/address-base.git olcs-addressbase
    cd olcs-addressbase
    git checkout $ADDRESS_ETL
    tar -czvf ../../release/olcs-addressbase/$ADDRESS_ETL.tar.gz *
    cd ..
fi

# create tar for olcs-elasticsearch scripts
if [ ! -f ../release/olcs-elasticsearch/$ELASTIC.tar.gz ]; then
    rm -rf olcs-elasticsearch
    git clone git@gitlab.inf.mgt.mtpdvsa:olcs/olcs-elasticsearch.git
    cd olcs-elasticsearch
    git checkout $ELASTIC
    tar -czvf ../../release/olcs-elasticsearch/$ELASTIC.tar.gz *
    cd ..
fi

# OpenAM
if [ ! -f ../release/olcs-oa/openam-$OPENAM.tar.gz ]; then
	rm -rf olcs-oa
	git clone git@gitlab.inf.mgt.mtpdvsa:olcs/olcs-oa.git
	cd olcs-oa
	git checkout $OPENAM_CONFIG

	tar -czvf ../../release/olcs-oa/openam-$OPENAM.tar.gz openam/*
	tar -czvf ../../release/olcs-oa/opendj-$OPENAM.tar.gz opendj/*
	cd ..
fi

# create tar for olcs-templates
if [ ! -f ../release/olcs-templates/$TEMPLATES.tar.gz ]; then
    rm -rf olcs-templates
    git clone git@gitlab.inf.mgt.mtpdvsa:olcs/olcs-templates.git
    cd olcs-templates
    git checkout $TEMPLATES
    tar -czvf ../../release/olcs-templates/$TEMPLATES.tar.gz *
    cd ..
fi

if [ ! -f ../release/txc/$TXCHANGE.war ]; then
    if [ ! -d olcs-txt ]; then
        git clone git@gitlab.inf.mgt.mtpdvsa:olcs/olcs-txc.git
    fi
    (cd olcs-txc && git checkout $TXCHANGE)
    cp olcs-txc/txc.war ../release/txc/$TXCHANGE.war
fi

# Jasper reports
if [ ! -f ../release/olcs-reporting/$REPORTS.tar.gz ]; then
    rm -rf olcs-reporting
    git clone git@gitlab.inf.mgt.mtpdvsa:olcs/olcs-reporting.git
    cd olcs-reporting
    git checkout $REPORTS
    mkdir -p ../../release/olcs-reporting/
    make tar FILE=../../release/olcs-reporting/$REPORTS.tar.gz
    cd ..
fi


cd ../release

tar --transform='flags=r;s|\/|-|' -czf OLCS-$OLCS_VERSION.tar.gz \
api-$BACKEND.erb \
iuweb-$INTERNAL.erb \
ssweb-$SELFSERVE.erb \
address-service-$ADDRESS_SERVICE.erb \
iuuath-$OPENAM_CONFIG.erb \
ssuath-$OPENAM_CONFIG.erb \
dir-$OPENAM_CONFIG.erb \
olcs-backend/$BACKEND.tar.gz \
olcs-internal/$INTERNAL.tar.gz \
olcs-selfserve/$SELFSERVE.tar.gz \
olcs-static/$STATIC.tar.gz \
olcs-addressbase/$ADDRESS_ETL.tar.gz \
address-service/$ADDRESS_SERVICE.tar.gz \
olcs-elasticsearch/$ELASTIC.tar.gz \
olcs-templates/$TEMPLATES.tar.gz \
olcs-etl/$ETL.tar.gz \
txc/$TXCHANGE.war \
olcs-oa/opendj-$OPENAM.tar.gz \
olcs-oa/openam-$OPENAM.tar.gz \
olcs-guides/$GUIDES.tar.gz \
olcs-reporting/$REPORTS.tar.gz
