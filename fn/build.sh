#!/usr/bin/env bash

#Retrieve buildfile from path
#Params:
buildfile() {

    FILENAME="${1}";
    DEFAULT_FILE="${2}";
    DEFAULT_FOLDER="${3}";

    #Parent dir
    PDIR='.';

    if [ -z "${FILENAME}" ]; then true; else

        if [ -f "${FILENAME}" ]; then

            echo "${FILENAME}";
            exit 0;
        fi

        if [ -f "${FILENAME}.json" ]; then

            echo "${FILENAME}.json";
            exit 0;

        else

            if [ -f "${PDIR}/${DEFAULT_FOLDER}/${FILENAME}" ]; then
                echo "${PDIR}/${DEFAULT_FOLDER}/${FILENAME}";
                exit 0;
            fi

            if [ -f "${PDIR}/${DEFAULT_FOLDER}/${FILENAME}.json" ]; then
                echo "${PDIR}/${DEFAULT_FOLDER}/${FILENAME}.json";
                exit 0;
            fi

           #Consider filename a folder
           PDIR="${FILENAME}"

        fi

    fi

    if [ -f "${PDIR}/${DEFAULT_FILE}" ]; then

        #Found .DEFAULT_FILE
        echo "${PDIR}/${DEFAULT_FILE}";
        exit 0;

    else

        if [ -f "${PDIR}/${DEFAULT_FOLDER}/${DEFAULT_FILE}" ];
        then
            echo "${PDIR}/${DEFAULT_FOLDER}/${DEFAULT_FILE}";
            exit 0;
        else
            echo '';
            exit 1;
        fi

     fi

}

#Adds argument to args list file
#Params:
# $1: Args filename
# $2: Arg name
# $2: Arg default value (optional)
argsfile(){

    local ARG_FILE="$1";
    local ARG_NAME="$2";
    local ARG_VALU="$3";

    if [ -z "$1" ]; then
        # Arg file is required
        exit 1;
    fi

    if [ -z "$2" ]; then
        # Arg name is required
        exit 1;
    fi

    if [ -z "$3" ]; then
        ARG_VALU="";
    fi

    echo "${ARG_NAME}=${ARG_VALU}" >> "${ARG_FILE}";

}

# Given a dockerfile command, detects if the command adds a new layer and generates
# a layerfile
# Params:
#   $1: Build output folder, where the Layersfiles will be saved
#   $2: Dockerfile command
# Return:
#  Exit status indicates success or error
layerfile(){

    local LAYERS_DIR="${1}";

    local COMMAND="${2}";
    local NEWLINE=$'\n';

    # Current layer
    local LAYER=1;

    local LAYER_FILE;
    local SHORTCMD=${COMMAND:0:7}

    if [ -d "${LAYERS_DIR}" ]; then true; else
        mkdir -p "${LAYERS_DIR}";
    fi

    # Init prev layer command
    local LAYERCOMMD=$(cat "${LAYERS_DIR}/LAYERCOMMD" 2> /dev/null);

    # Init layer comments
    local LAYERCOMMENTS=$(cat "${LAYERS_DIR}/LAYERCOMMENTS" 2> /dev/null);

    # If it's a comment we put it in queue

	if case ${SHORTCMD} in \#*) true;; *) false;; esac; then

	    if [ -z "${LAYERCOMMENTS}" ]; then
            LAYERCOMMENTS="${2}";
        else
            LAYERCOMMENTS="${LAYERCOMMENTS}${NEWLINE}${2}";
        fi

        # Save comment in buffer
        echo "${LAYERCOMMENTS}" > "${LAYERS_DIR}/LAYERCOMMENTS";

        # Done
        return 0;

    fi

    #Calculate next layer index
    local INDEX=1;

    # TODO folder may have spaces in it!

    for filename in $(find ${LAYERS_DIR}/Layerfile.* 2> /dev/null); do
        INDEX=$((INDEX+1));
    done

    if [[ ${INDEX} > 1 ]]; then
        LAYER=$((INDEX-1));
    fi

    case "${SHORTCMD}" in

        \RUN*)

            # Only switch to new layer if the prev command is different than FROM
            if [[ "${LAYERCOMMD}" == "FROM" ]]; then
                LAYER_FILE="Layerfile.${LAYER}";
            else
                LAYER_FILE="Layerfile.${INDEX}";
            fi

            # Set layer command
            LAYERCOMMD="RUN";

        ;;

        \FROM*)

            LAYER_FILE="Layerfile.${INDEX}";
            LAYERCOMMD="FROM";

        ;;

        *)
            LAYER_FILE="Layerfile.${LAYER}";
        ;;

    esac

    LAYER_FILE="${LAYERS_DIR}/${LAYER_FILE}";

    if [ -z "${LAYERCOMMENTS}" ]; then true; else
        echo "${LAYERCOMMENTS}" >> "${LAYER_FILE}";
    fi

    # Remove comments buffer
    unlink "${LAYERS_DIR}/LAYERCOMMENTS" 2> /dev/null;

    # Store prev. cmd buffer
    echo "${LAYERCOMMD}" > "${LAYERS_DIR}/LAYERCOMMD";

    # Add command to layer
    echo "${COMMAND}" >> "${LAYER_FILE}";

    # TODO we should run hadolint on every step

}

#Runs Hadolint (https://github.com/hadolint/hadolint) on file
#Params:
# $1: Dockerfile path
# $2: Ignore rules
dockerfilelint(){

    local OUT;

    OUT=$(hadolint "${1}");

    if [ -z "${OUT}" ]; then true; else

        # Remove path from warning
        OUT=$

        warning "${OUT}";
    fi

    # Linter does not report any issue
    exit 0;

}