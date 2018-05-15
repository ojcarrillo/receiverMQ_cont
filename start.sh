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
-d -p 4021:21 -p 4020:20 -p 14020:14020 -p 14021:14021 -p 14022:14022 -p 14023:14023 -p 14024:14024 -p 14025:14025  \
-e "USER=touresbalon" -e "PASS=verysecretpwd" \
-v /data/ftp/receivermq_cont:/ftp \
-it dk_receivermq_cont
echo "======================================================="
echo "======================================================="
echo "fin"
