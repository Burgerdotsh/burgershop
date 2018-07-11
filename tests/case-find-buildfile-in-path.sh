#!/usr/bin/env bash

#Initialize
source './_setup.sh';

#Set Workdir to tests/samples
cd "./samples";

#Testing build from dir
#info "Test locate default Burgerfile.json in folder root";
EXPECT="./Burgerfile.json";
RESULT=$(brgr-initbuild)

testeq "${RESULT}" "${EXPECT}";

#Testing build from dir with Burgerfile.json
EXPECT="folder-with-burgerfile/Burgerfile.json";
RESULT=$(brgr-initbuild "folder-with-burgerfile")

testeq "${RESULT}" "${EXPECT}";

#Testing build from dir with .burger/Burgerfile.json
EXPECT="folder-with-dotburger/.burger/Burgerfile.json";
RESULT=$(brgr-initbuild "folder-with-dotburger")

testeq "${RESULT}" "${EXPECT}";

#Testing build from file autodetect json
EXPECT="development.json";
RESULT=$(brgr-initbuild "development")

testeq "${RESULT}" "${EXPECT}";

#Testing build from file
EXPECT="production.json";
RESULT=$(brgr-initbuild "production.json")

testeq "${RESULT}" "${EXPECT}";

#Testing build from folder/file
EXPECT="folder-with-burgerfile/production.json";
RESULT=$(brgr-initbuild "folder-with-burgerfile/production")

#Testing build from folder:file
EXPECT="folder-with-burgerfile/production.json";
RESULT=$(brgr-initbuild "folder-with-burgerfile:production")

testeq "${RESULT}" "${EXPECT}";

#Testing build from with .burger folder:file
EXPECT="folder-with-dotburger/.burger/development.json";
RESULT=$(brgr-initbuild "folder-with-dotburger:development")

testeq "${RESULT}" "${EXPECT}";

# Restore workdir
cd "../";

#Teardown
source './_teardown.sh';