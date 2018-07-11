#!/usr/bin/env bash

# Initialize
source './_setup.sh';

# Testing init cache label
TEST_DIR=$(realpath "./tmpdir");
TEST_DIR="${TEST_DIR}/.cache";

EXPECT="${TEST_DIR}/de2b14a";

RESULT=$(brgr-cache init "default" "${TEST_DIR}");
COMPARE=$(brgr-cache init "default" "${TEST_DIR}");

testeq "${RESULT}" "${EXPECT}";
testeq "${RESULT}" "${COMPARE}";

# Test init another cache label
EXPECT="${TEST_DIR}/3740570";
RESULT=$(brgr-cache init "another" "${TEST_DIR}");

testeq "${RESULT}" "${EXPECT}";

# Cleanup
rm -rf "${TEST_DIR}";

# Teardown
source './_teardown.sh';