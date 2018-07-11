#!/usr/bin/env bash

#Initialize
source './_setup.sh';

#Set Workdir to tests/samples
cd "./samples";

#Purge cache
../bin/brgr-cache-purge

#Testing Dockerfile gen. - Avocado Flavour
#Testing Dockerfile gen. - Raspberry Flavour
#Testing Dockerfile gen. - Wholemeal Bread


# Restore workdir
cd "../";

#Teardown
source './_teardown.sh';