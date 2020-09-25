#! /bin/bash

set -euo pipefail

clang -fprofile-instr-generate -fcoverage-mapping -o common common.cpp
clang -fprofile-instr-generate -fcoverage-mapping -o main main.cpp
clang -fprofile-instr-generate -fcoverage-mapping -o main2 main2.cpp
