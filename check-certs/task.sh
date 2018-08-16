#/bin/bash
# todo: check cert and key are related
# support ROUTING_CUSTOM_CA_CERTIFICATES
# Param 1: Apps Domain
# Param 2: system domain
# Param 3: filename of cert1 to check
# Param 4: filename of cert2 to check (optional)
# Param 5: filename of cert3 to check (optional)

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

echo "Specified in Parameters:"
echo "========================"
echo "System Domain: $SYSTEM_DOMAIN"
echo "Apps Domain: $APPS_DOMAIN"
echo "UAA Domain: $UAA_DOMAIN"
echo "Login Domain: $LOGIN_DOMAIN"
echo

echo "Certificates:"
echo "============="
#echo "Certificate 1:"
# echo $POE_SSL_CERT1
# echo $POE_SSL_KEY1

string="$(echo $POE_SSL_CERT1 |   perl -pe 's/\\n/\n/g' | openssl x509 -noout -text | grep DNS)"

echo "Certificate 1:"
if [[ $string = *"${WILDCARD_APPS_DOMAIN}"* ]]; then
  echo "Contains APPS SAN: ${WILDCARD_APPS_DOMAIN}"
  FOUND_APPS=1
  else
  echo "Apps domain (*.apps.<system domain>) is missing"
fi
if [[ $string = *"${WILDCARD_SYSTEM_DOMAIN}"* ]]; then
  echo "Contains SYSTEM SAN: ${WILDCARD_SYSTEM_DOMAIN}"
  FOUND_SYSTEM=1
  else
  echo "System domain (*.<system domain>) is missing!"
fi

if [[ $string = *"${UAA_DOMAIN}"* ]]; then
  echo "Contains UAA SAN: ${UAA_DOMAIN}"
  FOUND_UAA=1
  else
  echo "UAA (*.uaa.<system domain>) domain is missing!"
fi

if [[ $string = *"${LOGIN_DOMAIN}"* ]]; then
  echo "contains LOGIN SAN: ${LOGIN_DOMAIN}"
  FOUND_LOGIN=1
  else
  echo "login (*.login.<system domain>) domain is missing!"
fi

if [ $FOUND_APPS -eq 0 ] || [ $FOUND_UAA -eq 0 ] || [ $FOUND_LOGIN -eq 0 ] || $FOUND_SYSTEM -eq 0 ]; then
  exit 1
fi

exit 0


$POE_SSL_NAME1:
$POE_SSL_CERT1:
$POE_SSL_KEY1:

POE_SSL_CERT2:
POE_SSL_KEY2:
POE_SSL_NAME2:

POE_SSL_NAME2:
POE_SSL_CERT2:
POE_SSL_KEY2:


function isPopulated() {
    local true=0
    local false=1
    local envVar="${1}"

    if [[ "${envVar}" == "" ]]; then
        return ${false}
    elif [[ "${envVar}" == null ]]; then
        return ${false}
    else
        return ${true}
    fi
}

# Check POE_SSL_NAME1 is populated


# Decode Cert and grab DNS entries
echo $POE_SSL_CERT1 |   perl -pe 's/\\n/\n/g' | openssl x509 -noout -text | grep DNS

# 
if [[ $string = *"${UAA_DOMAIN}"* ]]; then
  echo "It's there!"
fi

cat cert |  openssl x509 -noout -text | grep DNS:


if [[ "${POE_SSL_NAME1}" == "" || "${POE_SSL_NAME1}" == "null" ]]; then
  domains=(
    "*.${SYSTEM_DOMAIN}"
    "*.${APPS_DOMAIN}"
    "*.login.${SYSTEM_DOMAIN}"
    "*.uaa.${SYSTEM_DOMAIN}"
  )


else