#!/bin/bash

# support ROUTING_CUSTOM_CA_CERTIFICATES
# Param 1: Apps Domain
# Param 2: system domain
# Param 3: filename of cert1 to check
# Param 4: filename of cert2 to check (optional)
# Param 5: filename of cert3 to check (optional)

# Checks: 
# 1. The required SANs are correct in the cert
# 2. The Cert chain is correct.
# 3. The Private Key matches the cert chain
# 4. Check that expiry isn't too close to now.(default 6 months) - PRINT BIG WARNING
# 5. Check that the private key doesn't have a password

# SYSTEM_DOMAIN: {{system_domain}}
# APPS_DOMAIN: {{apps_domain}}

UAA_DOMAIN="*.uaa.${SYSTEM_DOMAIN}"
LOGIN_DOMAIN="*.login.${SYSTEM_DOMAIN}"
WILDCARD_SYSTEM_DOMAIN="*.${SYSTEM_DOMAIN}"
WILDCARD_APPS_DOMAIN="*.${APPS_DOMAIN}"

FOUND_UAA=0
FOUND_LOGIN=0
FOUND_SYSTEM=0
FOUND_APPS=0

# echo $UAA_DOMAIN
# echo $LOGIN_DOMAIN
# echo $POE_SSL_CERT1
# echo $POE_SSL_KEY1
# echo $TRUSTED_CERTS


if [[ -z "$TRUSTED_CERTS" ]]; then
echo "No Trusted Root Certs"
echo "================"
echo "You have not included any trusted root certs as part of this deployment - this means you must be using publically trusted certs to avoid ssl errors"
fi


# Check that the certs contain the required SANS to cover PCF + Spring Cloud Services
string="$(echo $POE_SSL_CERT1 |   perl -pe 's/\\n/\n/g' | openssl x509 -noout -text | grep DNS)"
echo ""
echo "Certificate 1:"
echo "=============="
if [[ $string = *"${WILDCARD_APPS_DOMAIN}"* ]]; then
  echo "Contains APPS SAN: ${WILDCARD_APPS_DOMAIN}"
  FOUND_APPS=1
  else
  echo "Missing ${WILDCARD_APPS_DOMAIN}"
fi
if [[ $string = *"${WILDCARD_SYSTEM_DOMAIN}"* ]]; then
  echo "Contains SYSTEM SAN: ${WILDCARD_SYSTEM_DOMAIN}"
  FOUND_SYSTEM=1
  else
  echo "Missing ${WILDCARD_SYSTEM_DOMAIN}"
fi

if [[ $string = *"${UAA_DOMAIN}"* ]]; then
  echo "Contains UAA SAN: ${UAA_DOMAIN}"
  FOUND_UAA=1
  else
  echo "Missing ${UAA_DOMAIN}"
fi

if [[ $string = *"${LOGIN_DOMAIN}"* ]]; then
  echo "Contains LOGIN SAN: ${LOGIN_DOMAIN}"
  FOUND_LOGIN=1
else
  echo "Missing ${LOGIN_DOMAIN}"
fi

if [[ $FOUND_LOGIN == 0 ]]; then
  exit 1
fi
 if [[ $FOUND_UAA == 0 ]]; then 
 exit 1
 fi

 if [[ $FOUND_SYSTEM == 0 ]]; then
 exit 1
 fi
 
 if [[ $FOUND_APPS == 0 ]]; then
 exit 1
 fi


# Put the variables into temp files so that we can use openssl commands that need files.
# command will validate that the root ca and site are a chain.
# openssl verify -CAfile root.pem -untrusted ca.cert site.pem
# will echo 'error' for anything that's not correctly chained.

echo $POE_SSL_CERT1 |perl -pe 's/\\n/\n/g' > /tmp/server.cert
echo $POE_SSL_KEY1 |perl -pe 's/\\n/\n/g' > /tmp/server.key
echo $TRUSTED_CERTS |perl -pe 's/\\n/\n/g' > /tmp/trusted.cert

# we need to split server cert from intermediate certs for our testing
# note only supports one intermediate cert
csplit -f /tmp/split- /tmp/server.cert '/-----BEGIN CERTIFICATE-----/' '{*}'

# openssl verify allows you to put multiple root ca certs in the trusted cert section
# openssl verify -CAfile root.pem -untrusted ca.cert site.pem
#if `openssl verify -CAfile ca.cert -untrusted /tmp/split-ab /tmp/split-aa | grep -i "error"`; then
#[[ $(/usr/local/bin/monit --version) != *5.5* ]]
if [[ `openssl verify -CAfile /tmp/trusted.cert -untrusted /tmp/split-02 /tmp/split-01` != *error* ]]; then
echo 
echo "Certificate chain is valid"
echo 
else

echo "ERROR - certificate chain is invalid!"
exit 1
fi

# Check date cert expires
#  $ openssl x509 -enddate -noout -in  site.pem
#  notAfter=Aug 10 15:42:41 2027 GMT

ENDDATE=$(openssl x509 -enddate -noout -in  /tmp/split-01)
echo Server Certificate expires on ${ENDDATE#*=}
if openssl x509 -checkend 15552000 -noout -in /tmp/split-01
then
  echo "Certificate is good for at least 6 months!"
else
  echo "Certificate has expired or will do so within 6 months!"
  echo "(or is invalid/not found)"
  exit 1
fi

# The Private Key must match the cert
#hnrglobal.com.key
MOD_KEY="$(openssl rsa -noout -modulus -in /tmp/server.key)"
MOD_SERVER="$(openssl x509 -noout -modulus -in /tmp/split-01)"
if [[  $MOD_KEY == $MOD_SERVER ]]; then
echo "This key is the correct key for the server cert"
else
echo "ERROR: KEY AND SERVER CERTIFICATE DO NOT MATCH"
exit 1
fi

# Everything is good.
exit 0