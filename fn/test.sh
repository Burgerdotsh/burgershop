#!/usr/bin/env bash

testeq() {

    local MSG="$3";

    if [ -z "${MSG}" ]; then
        MSG="assert that '$2' equals '$1'";
    fi

    if [[ "$2" == "$1" ]]; then
        #Test passed
        success "Passed: ${MSG}";
    else
        #Test failed
        error "Failed to ${MSG}";
    fi


}

testneq() {

    local MSG="$3";

    if [ -z "${MSG}" ]; then
        MSG="assert that '$2' is not equal to '$1'";
    fi

    if [[ "$2" != "$1" ]]; then
        #Test passed
        success "Passed: ${MSG}";
    else
        #Test failed
        error "Failed to ${MSG}";
    fi

}

testgte() {

    local MSG="$3";

    if [ -z "${MSG}" ]; then
        MSG="assert that '$1' is greater then or equal to '$2'";
    fi

    if [ "$1" -ge "$2" ]; then
        #Test passed
        success "Passed: ${MSG}";
    else
        #Test failed
        error "Failed to ${MSG}";
        exit 1;
    fi

}

testendswith(){

    local STR="${1}";
    local SUB_STR="*${2}";

    local MSG="$3";

    if [ -z "${MSG}" ]; then
        MSG="assert that '$1' ends with '$2'";
    fi

    if case ${STR} in ${SUB_STR}) true;; *) false;; esac; then
        #Test passed
        success "Passed: ${MSG}";
    else
        #Test failed
        error "Failed to ${MSG}";
        exit 1;
    fi

}

}
testsamecontent(){

    local MSG="$3";

    if [ -z "${MSG}" ]; then
        MSG="assert that file '$2' has the same contents as '$1'";
    fi

    ha=$(openssl sha1 "${1}" | cut -d' ' -f 2);
    hb=$(openssl sha1 "${2}" | cut -d' ' -f 2);

    if [[ "$2" == "$1" ]]; then
        #Test passed
        success "Passed: ${MSG}";
    else
        #Test failed
        error "Failed to ${MSG}";
        exit 1;
    fi

}

testdirexists(){

    local MSG="$3";

    if [ -z "${MSG}" ]; then
        MSG="assert that folder '$1' exists and is readable.";
    fi

    if [ -d "${1}" ]; then
        #Test passed
        success "Passed: ${MSG}";
    else
        #Test failed
        error "Failed to ${MSG}";
        exit 1;
    fi

}