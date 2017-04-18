#!/usr/bin/env bash

echo "list current directory for debugging";
ls -lah;

echo "update ca certs";
update-ca-certificates;

echo "run server.js";
/usr/local/bin/node server.js;
