#! /bin/bash

set -euo pipefail

set -x

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

clang --version
exit 1
