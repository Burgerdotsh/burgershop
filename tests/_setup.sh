#!/usr/bin/env bash

cd $(dirname "$0") && INCLUDEPATH="../";

# Include functions
source "../fn/util.sh";
source "../fn/build.sh";
source "../fn/test.sh";

#Add .bin folder to PATH
BKTH=$PATH;
PATH="$PATH:$INCLUDEPATH/bin/order::$INCLUDEPATH/bin/tools";

# Extract test case name
CASE_NAME=$(echo "${0/.\//}");
CASE_NAME=$(echo "${CASE_NAME/.sh/}");
CASE_NAME=$(echo "${CASE_NAME//-/ }");
CASE_NAME=( ${CASE_NAME} );
CASE_NAME=$(echo "${CASE_NAME[@]^}");

echo "";
echo "------------------------------------------------------------------------";
info "${CASE_NAME} ...";
echo "";