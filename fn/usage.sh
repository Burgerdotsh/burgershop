#!/usr/bin/env bash

#Init defaults
if [ -z ${SCRIPTNAME+x} ]; then
    SCRIPTNAME="$(basename $0)";
fi

if [ -z ${VERSION+x} ]; then
    VERSION='0.0'
fi

usage() {

read -r -d '' HELP << EOM

${SCRIPTNAME} version ${VERSION}

Usage: ${SCRIPTNAME} <folder:file> [options...]

folder:file acts like name:tag for docker build, when "name" and "tag" 
are not present in the config file. 

You may also enter a <folder> or an url to a git repository, in which case 
Burger will look for the Burgerfile.json in that folder/repository.

optional arguments:
 --help             displays this help message
 --test             test the configuration file
 --upgrade          force upgrade of base image; 

Examples: 

    ${SCRIPTNAME} hello:latest               : build image from hello/latest.json file
	
	${SCRIPTNAME} http://server/burger.json  : downloads burger.json and builds image that config file

	${SCRIPTNAME} http://server/burger.json  : downloads burger.json and builds image that config file

EOM

    echo "$HELP" 1>&2; exit 1;

}