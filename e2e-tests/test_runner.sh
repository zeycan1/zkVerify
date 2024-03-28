#!/bin/bash
# This script is used to run the e2e tests locally or in the CI pipeline.
# If runned locally, be sure that the following applications are present on
# the target system:
# - node
# - npm
# - yarn
# The script automatically downloads zombienet binary and save it into the e2e-tests/bin folder.
# It also looks for a compiled nh-node binary in the folder target/release, hence make sure to 
# have a freshly compiled version of nh-node in this folder.
# Optionally, this script can be launched with the '--debug' switch, which makes it looks for
# the nh-node binary in the target/debug folder instead.

# ANSI color handles
TXT_BICYA="\033[96;1m"
TXT_BIPRP="\033[95;1m"
TXT_BIBLU="\033[94;1m"
TXT_BIYLW="\033[93;1m"
TXT_BIGRN="\033[92;1m"
TXT_BIRED="\033[91;1m"
TXT_BIBLK="\033[90;1m"
TXT_NORML="\033[0m"

# Please do not exceed 64 chars for each test filename - including the .zndsl extension
TEST_LIST=(
    '0001-simple_test.zndsl'
    '0002-custom_script.zndsl'
    '0003-transaction.zndsl'
    '0004-failing_transaction.zndsl'
    '0005-proofPath_rpc.zndsl'
);

# The return value of each zombinet invocation is always equal to the
# number of failed tests among those listed in each .zndsl.
# For this reason, we keep track of each .zndsl whose return value is not 0.
FAILED_TESTS=()
TOT_EXEC_TESTS=0
TOT_FAIL_TESTS=0

# Check if zombienet executable exists, otherwise download that from Parity Tech repo
if [ ! -f bin/zombienet-linux-x64 ]; then
    echo -e "${TXT_BIYLW}WARNING: ${TXT_BIBLK}Zombienet executable not found${TXT_NORML}"
    wget --progress=dot:giga https://github.com/paritytech/zombienet/releases/download/v1.3.94/zombienet-linux-x64 -O bin/zombienet-linux-x64
    if [ $? -ne 0 ]; then
        echo -e "${TXT_BIRED}ERROR: ${TXT_BIBLK}zombienet binary download failed.${TXT_NORML}"
        exit 2
    fi
    chmod +x bin/zombienet-linux-x64
fi

# Check if we requested a run over a debug build
if [[ "$@" == *"--debug"* ]]
then
    echo -e "${TXT_BIGRN}INFO: ${TXT_BIBLK}Running tests with a debug build${TXT_NORML}"
    BUILDSUBPATH="debug"
else
    echo -e "${TXT_BIGRN}INFO: ${TXT_BIBLK}Running tests with a release build${TXT_NORML}"
    BUILDSUBPATH="release"
fi

# Check if nh-node executable exists according tho the requested mode and print error/info messages otherwise
if [[ ${BUILDSUBPATH} == "debug" ]]
then
    if [ ! -f ../target/debug/nh-node ]
    then
        if [ -f ../target/release/nh-node ]; then
            echo -e "${TXT_BIRED}ERROR: ${TXT_BIBLK}debug binary not found; however a release binary is present. Compile nh-node in debug mode${TXT_NORML}"
            echo -e "${TXT_BIRED}       ${TXT_BIBLK}or relaunch the test runner without the '--debug' switch${TXT_NORML}"
            exit 2
        else
            echo -e "${TXT_BIRED}ERROR: ${TXT_BIBLK}nh-node binary not found. Compile nh-node in debug mode and re-launch this script${TXT_NORML}"
            exit 3
        fi
    fi
fi

if [[ ${BUILDSUBPATH} == "release" ]]
then
    if [ ! -f ../target/release/nh-node ]
    then
        if [ -f ../target/debug/nh-node ]; then
            echo -e "${TXT_BIRED}ERROR: ${TXT_BIBLK}release binary not found; however a debug binary is present. Compile nh-node in release mode${TXT_NORML}"
            echo -e "${TXT_BIRED}       ${TXT_BIBLK}or relaunch the test runner with the '--debug' switch${TXT_NORML}"
            exit 2
        else
            echo -e "${TXT_BIRED}ERROR: ${TXT_BIBLK}nh-node binary not found. Compile nh-node in release mode and re-launch this script${TXT_NORML}"
            exit 3
        fi
    fi
fi

# If all checks passed, set the full build path
FULLBUILDPATH="../target/${BUILDSUBPATH}"

# GO! GO! GO!
for TESTNAME in ${TEST_LIST[@]}; do
    echo -e "\n\n"
    echo -e "============================================================"
    echo -e ${TXT_BIBLK} "Running test: " ${TXT_NORML} "${TESTNAME}"
    echo -e "============================================================"
    ( PATH=${PATH}:${FULLBUILDPATH}; bin/zombienet-linux-x64 -p native test ./${TESTNAME} )
    current_exit_code=$?
    TOT_EXEC_TESTS=$((TOT_EXEC_TESTS+1))
    if [ ${current_exit_code} -ne 0 ]; then
        FAILED_TESTS+=($TESTNAME)
        TOT_FAIL_TESTS=$((TOT_FAIL_TESTS+1))
    fi
done


# Print a fancy table summarizing the test suit run
echo -e "\n\n\n"
echo -e "┌────────────────────────────────────────────────────────────────────────┐"
echo -e "│                              "${TXT_BIYLW}"TEST SUMMARY"${TXT_NORML}"                              │"
echo -e "├────────────────────────────────────────────────────────────────────────┤"
printf  "│ ${TXT_BIBLK} Total tests executed:  ${TXT_BIBLU} %3d ${TXT_NORML}                                          │\n" "${TOT_EXEC_TESTS}"
if [ ${TOT_FAIL_TESTS} -ne 0 ]; then
    echo -e "├────────────────────────────────────────────────────────────────────────┤"
    printf  "│ ${TXT_BIBLK} Failed tests:          ${TXT_BIRED} %3d ${TXT_NORML}                                          │\n" "${TOT_FAIL_TESTS}"
    for failed_test in ${FAILED_TESTS[@]}; do
        printf "│     - %-64s │\n" "${failed_test}"
    done
    echo -e "└────────────────────────────────────────────────────────────────────────┘"
    exit 1
fi
echo -e "└────────────────────────────────────────────────────────────────────────┘"
exit 0