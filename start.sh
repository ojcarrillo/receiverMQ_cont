#!/bin/bash
echo "======================================================="
echo "compila aplicacion"
mvn clean package -Dmaven.test.skip=true
echo "======================================================="
echo "======================================================="
echo "compila imagen docker - dk_receivermq_cont "
docker build -t dk_receivermq_cont .
echo "======================================================="
echo "======================================================="
echo "corre imagen del contenedor"
docker run --name dk_receivermq_cont --net=backend \
-d -p 4021:21 -p 4020:20 -p 14020:12020 -p 14021:12021 -p 14022:12022 -p 14023:12023 -p 14024:12024 -p 14025:12025  \
-e "USER=touresbalon" -e "PASS=verysecretpwd" \
-v /data/ftp/receivermq_cont:/ftp \
-it dk_receivermq_cont
echo "======================================================="
echo "======================================================="
echo "fin"
