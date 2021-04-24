#! /bin/bash

docker build -q -t mvi .
docker run --rm --name mvi -d -p 8080:8080 mvi


sleep 5
RESULT=$(curl -s --header "Content-Type: application/json" \
  --request POST \
  --data '{"id":"abcd", "opcode":6,"state":{"a":181,"b":0,"c":0,"d":0,"e":0,"h":0,"l":0,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":true},"programCounter":0,"stackPointer":0,"cycles":0}}' \
  http://localhost:8080/api/v1/execute\?operand1=10)
EXPECTED='{"id":"abcd", "opcode":6,"state":{"a":181,"b":10,"c":0,"d":0,"e":0,"h":0,"l":0,"flags":{"sign":false,"zero":false,"auxCarry":false,"parity":false,"carry":true},"programCounter":0,"stackPointer":0,"cycles":7}}'

docker kill mvi

if [ "$RESULT" = "$EXPECTED" ]; then
    echo -e "\e[32mMVI Test Pass \e[0m"
    exit 0
else
    echo -e "\e[31mMVI Test Fail  \e[0m"
    echo "$RESULT"
    echo "$EXPECTED"
    exit 1
fi