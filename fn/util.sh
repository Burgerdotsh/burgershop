#!/usr/bin/env bash

#Text formatting
#TODO add support for html output
t_underline=$(tput sgr 0 1)             # Underline
t_bold=$(tput bold)                     # Bold
t_red=$(tput setaf 1)                   # Red
t_green=$(tput setaf 2)                 # Green
t_yellow=$(tput setaf 3)                # Yellow
t_blue=$(tput setaf 6)                  # Blue
t_white=$(tput setaf 7)                 # White
t_reset=$(tput sgr0)                    # Reset

# Prints a red error message
# Params:
# $1: message string
#
error() {
    printf "%s\n" "${t_bold}${t_red}(!) ${1} ${t_reset}"
}

# Prints a yellow warning message
# Params:
# $1: message string
#
warning() {
    printf "%s\n" "${t_bold}${t_yellow}(!) ${1} ${t_reset}"
}

# Prints a blue info message
# Params:
# $1: message string
#
info() {
    printf "%s\n" "${t_bold}${t_blue}(!) ${1}${t_reset}"
}

# Prints a green success message
# Params:
# $1: message string
#
success() {
    printf "%s\n" "${t_bold}${t_green}(!) ${1}${t_reset}"
}

# Check if bash command is in PATH
# Params:
# $1: command
#
check() {

	AVAIL="$(hash $1 2>&1 1>/dev/null)";

	if [ -z "$AVAIL" ]; then true; else
		warning "Dependency '$1' is not in your PATH ... ";
		exit 1;
	fi

}

# Removes lines containing hash from file
# Params:
# $1: filename
#
cleanhashedlines() {

    local tmp_file;

    tmp_file=$(echo "${1}" | openssl md5);
    tmp_file="/tmp/${tmp_file}.chl";

    if [ -f "${1}" ]; then

        grep -v '^#' "${1}" > "${tmp_file}"
        mv "${tmp_file}" "${1}"

    fi

}

# Removes empty lines from file
# Params:
# $1: filename
#
cleanemptylines() {

    local tmp_file;

    tmp_file=$(echo "${1}" | openssl md5);
    tmp_file="/tmp/${tmp_file}.cel";

    if [ -f "${1}" ]; then

        grep -Ev "^$" "${1}" > "${tmp_file}"
        mv "${tmp_file}" "${1}"

    fi

}

# Removes double quotes from start and end of string, "str" -> str
# Params:
# $1: string
#
unquote() {

    # Removes double quotes from start and end of string, "str" -> str

	temp="${1%\"}";
	temp="${temp#\"}";

	if [[ "$temp" == "null" ]]; then
		echo '';
	else
		echo ${temp} | tr -d '\n';
	fi

}

locked() {

    #Check if a folder has a .lockfile

    if [ -d "${1}" ]; then

        if [ -f "${1}/.lockfile" ]; then
            echo "locked";
        fi

     fi

     echo "";

}

lock() {

    # Puts .lockfile in folder.
    # Echoes "locked" on success, empty string for failure

    # Lockfile Ref
    LOCK_REFD=$(date +%Y.%m)
    LOCK_FILE=".lockfile.${LOCK_REFD}"

    # Tries (how many times we should try to lock it)
    TRIES=2;

    # Wait time between tries
    WAIT=1;

    if [ -z "${2}" ]; then true; else
        TRIES=${2};
    fi

    if [ -z "${3}" ]; then true; else
        WAIT=${3};
    fi

    if [ -d "${1}" ]; then

        if [ -f "${1}/${LOCK_FILE}" ]; then false; else

            timestamp=$(date +%s)
            echo ${timestamp} > "${1}/${LOCK_FILE}";

            echo "locked";

        fi

     fi

}

unlock() {

    #Removes .lockfile from folder
    LOCK_REFD=$(date +%Y.%m)
    LOCK_FILE=".lockfile.${LOCK_REFD}"

    #Unlink file
    unlink "${1}/${LOCK_FILE}"

}

header() {

    #Retrieve URI header

    HEADER="$(echo $2 | tr '[:upper:]' '[:lower:]')"
    VALUE=$(curl -sI "$1" |  tr '[:upper:]' '[:lower:]' | grep ${HEADER} | head -1);

    echo "${VALUE}";

}

httpcode() {

    STATUS=$(curl --write-out "%{http_code}\n" --silent --output /dev/null "${1}")

    echo "${STATUS}";

}

urlcode() {

    STATUS=$(httpcode "${1}");

    if [[ "301" == "${STATUS}" ]] || [[ "302" == "${STATUS}" ]]; then

        #Retrieve effective url
        URL=$(curl -LsI -o /dev/null -w %{url_effective} "$1");
        STATUS=$(httpcode "${URL}");

    fi

    echo "${STATUS}";

}

#Check file if is a valid json
# Params:
# $1: path or url to check
#
# Return: empty string on success, json error on failure
#TODO check against schema
jqcheck() {

    #checking an url
    if case ${1} in http*) true;; *) false;; esac; then
        CHECK=$(curl -L -s "${1}" | jq '.' 2>&1 1>/dev/null);
    else
        CHECK=$(jq '.name' "${1}" 2>&1 1>/dev/null);
    fi

    if case ${CHECK} in *error*) true;; *) false;; esac; then

        #Invalid json
        echo "${CHECK}";

    fi

    # Valid json
    echo "";

}

jqfile() {

	#Set default
	if [ -z "$3" ]; then
		DEFAULT='';
	else
		DEFAULT="$3";
	fi

    if case ${2} in http*) true;; *) false;; esac; then
        # Url
        VAL=$(curl -L -s "${2}" | cat | jq $1);
    else
        # File
        VAL=$(jq $1 "${2}");
    fi

	VAL=$(unquote "${VAL}");

	if [ -z "${VAL}" ] || [[ false == ${VAL} ]]; then
		echo "${DEFAULT}";
	else
		echo "${VAL}";
	fi

}

dockerfile() {

	if [ -f "${1}" ]; then

        # Append new line before each comment

	    if case ${2} in \#*) true;; *) false;; esac; then
            echo "" >> "${1}";
        fi

	else

	    # Dockerfile does not exists

		touch "${1}";

	fi

	# TODO check for valid command

	# Append command to file

	echo "${2}" >> "${1}";

}