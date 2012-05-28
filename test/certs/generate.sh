#!/bin/sh

if [ ! -f ca1.crt -o ! -f ca1.key ] ; then
	openssl req -new -batch -config ca1.cnf -x509 -days 3650 -nodes -keyout ca1.key -out ca1.crt
fi

if [ ! -f tsa1.crt ] ; then
	openssl req -new -batch -config tsa1.cnf -nodes -keyout tsa1.key -out tsa1.req && \
	openssl x509 -extfile tsa1.cnf -extensions ext -days 3650 -req -in tsa1.req -out tsa1.crt \
       		-set_serial 01 -CA ca1.crt -CAkey ca1.key && \
	rm -f tsa1.req
fi

if [ ! -f sign1.crt ] ; then
	openssl req -new -batch -config sign1.cnf -nodes -keyout sign1.key -out sign1.req && \
	openssl x509 -extfile sign1.cnf -extensions ext -days 3650 -req -in sign1.req -out sign1.crt \
       		-set_serial 02 -CA ca1.crt -CAkey ca1.key && \
	rm -f sign1.req
fi

if [ ! -f bad_tsa.crt ] ; then
	openssl req -new -batch -config bad_tsa.cnf -nodes -keyout bad_tsa.key -out bad_tsa.req && \
	openssl x509 -extfile bad_tsa.cnf -extensions ext -days 3650 -req -in bad_tsa.req -out bad_tsa.crt \
       		-set_serial 03 -CA ca1.crt -CAkey ca1.key && \
	rm -f bad_tsa.req
fi

if [ ! -f bad_sign.crt ] ; then
	openssl req -new -batch -config bad_sign.cnf -nodes -keyout bad_sign.key -out bad_sign.req && \
	openssl x509 -extfile bad_sign.cnf -extensions ext -days 3650 -req -in bad_sign.req -out bad_sign.crt \
       		-set_serial 04 -CA ca1.crt -CAkey ca1.key && \
	rm -f bad_sign.req
fi

if [ ! -f ca2.crt -o ! -f ca2.key ] ; then
	openssl req -new -batch -config ca2.cnf -x509 -days 3650 -nodes -keyout ca2.key -out ca2.crt
fi

if [ ! -f tsa2.crt ] ; then
	openssl req -new -batch -config tsa2.cnf -nodes -keyout tsa2.key -out tsa2.req && \
	openssl x509 -extfile tsa2.cnf -extensions ext -days 3650 -req -in tsa2.req -out tsa2.crt \
       		-set_serial 01 -CA ca2.crt -CAkey ca2.key && \
	rm -f tsa2.req
fi

if [ ! -f sign2.crt ] ; then
	openssl req -new -batch -config sign2.cnf -nodes -keyout sign2.key -out sign2.req && \
	openssl x509 -extfile sign2.cnf -extensions ext -days 3650 -req -in sign2.req -out sign2.crt \
       		-set_serial 02 -CA ca2.crt -CAkey ca2.key && \
	rm -f sign2.req
fi

if [ ! -f expired_ca.crt -o ! -f expired_ca.key ] ; then
	openssl req -new -batch -config expired_ca.cnf -x509 -days 1 -nodes -keyout expired_ca.key -out expired_ca.crt
fi

if [ ! -f expired_tsa.crt ] ; then
	openssl req -new -batch -config expired_tsa.cnf -nodes -keyout expired_tsa.key -out expired_tsa.req && \
	openssl x509 -extfile expired_tsa.cnf -extensions ext -days 1 -req -in expired_tsa.req -out expired_tsa.crt \
       		-set_serial 01 -CA expired_ca.crt -CAkey expired_ca.key && \
	rm -f expired_tsa.req
fi

if [ ! -f expired_sign.crt ] ; then
	openssl req -new -batch -config expired_sign.cnf -nodes -keyout expired_sign.key -out expired_sign.req && \
	openssl x509 -extfile expired_sign.cnf -extensions ext -days 1 -req -in expired_sign.req -out expired_sign.crt \
       		-set_serial 02 -CA expired_ca.crt -CAkey expired_ca.key && \
	rm -f expired_sign.req
fi

rm -f trusted1.jks || :
rm -f trusted2.jks || :
rm -f expired.jks || :
rm -f all.jks || :

keytool -keystore trusted1.jks -storepass 123456 -importcert -noprompt -trustcacerts -alias ca1 -file ca1.crt
keytool -keystore trusted2.jks -storepass 123456 -importcert -noprompt -trustcacerts -alias ca2 -file ca2.crt
keytool -keystore expired.jks -storepass 123456 -importcert -noprompt -trustcacerts -alias expired_ca -file expired_ca.crt
keytool -keystore all.jks -storepass 123456 -importcert -noprompt -trustcacerts -alias ca1 -file ca1.crt
keytool -keystore all.jks -storepass 123456 -importcert -noprompt -trustcacerts -alias ca2 -file ca2.crt
keytool -keystore all.jks -storepass 123456 -importcert -noprompt -trustcacerts -alias expired_ca -file expired_ca.crt



