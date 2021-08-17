#!/usr/bin/env sh

set -e

while [ ! -s /certs/ca.crt ]
do
    echo Wating for CA.crt to be present...
    sleep 2
done

exec /cockroach/cockroach start --cluster-name=example-dot-com --logtostderr=WARNING --log-file-verbosity=WARNING --certs-dir=/certs --listen-addr=roach0.crdb.io:26257 --advertise-addr=roach0.crdb.io:26257 --join=roach0.crdb.io