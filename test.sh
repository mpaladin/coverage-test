#! /bin/bash

set -euo pipefail

export SONARQUBE_URL=https://sonarcloud.io
export SONARQUBE_TOKEN=${SONAR_TOKEN}

export SONAR_SCANNER_VERSION=4.4.0.2170
export SONAR_SCANNER_HOME=$HOME/.sonar/sonar-scanner-$SONAR_SCANNER_VERSION-linux
curl --create-dirs -sSLo $HOME/.sonar/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip
unzip -o $HOME/.sonar/sonar-scanner.zip -d $HOME/.sonar/
export PATH=$SONAR_SCANNER_HOME/bin:$PATH
export SONAR_SCANNER_OPTS="-server"

curl -LsSO ${SONARQUBE_URL}/static/cpp/build-wrapper-linux-x86.zip
unzip build-wrapper-linux-x86.zip

which clang
ls /usr/bin/llvm*

./build-wrapper-linux-x86/build-wrapper-linux-x86-64 --out-dir cfamily-compilation-database bash build.sh
LLVM_PROFILE_FILE="common.profraw" ./common
LLVM_PROFILE_FILE="main.profraw" ./main
LLVM_PROFILE_FILE="main2.profraw" ./main2
llvm-profdata-9 merge -o report.profdata -sparse *.profraw
llvm-cov-9 show \
  -instr-profile=report.profdata \
  -object=./common \
  -object=./main \
  -object=./main2 \
  > report.txt
cat report.txt

git fetch --unshallow
sonar-scanner \
  -Dsonar.cfamily.cache.enabled=false \
  -Dsonar.host.url=${SONARQUBE_URL} \
  -Dsonar.login=${SONARQUBE_TOKEN} \
  -Dsonar.organization=mpaladin \
  -Dsonar.projectKey=mpaladin_coverage-test \
  -Dsonar.sources=. \
  -Dsonar.cfamily.build-wrapper-output=cfamily-compilation-database \
  -Dsonar.cfamily.threads=$(nproc) \
  -Dsonar.cfamily.llvm-cov.reportPath=report.txt \
  -Dsonar.projectVersion=master \
  -Dsonar.sourceEncoding=UTF-8
