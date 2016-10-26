#!/bin/sh

set -x
set -e

: ${NODE_VERSION?"NODE_VERSION has not been set."}

my_dir=`dirname $0`
root_dir="$my_dir/.."

if [ -z "${CIRCLE_NODE_TOTAL}" ] || [ -z "${CIRCLE_NODE_INDEX}" ]; then
  echo "Not running on CircleCI"
  exit 1
fi
IFS="
"

our_scripts="\
${my_dir}/test_meteor_app.sh
${my_dir}/test_bundle_local_mount.sh
${my_dir}/test_bundle_web.sh
${my_dir}/test_phantomjs.sh
${my_dir}/test_no_app.sh
"

our_scripts="${our_scripts}$( \
  cat ${my_dir}/meteor_versions_to_test | \
  xargs -n1 echo ${my_dir}/test_meteor_app.sh
)"

our_work="$( \
  echo "${our_scripts}" | \
  awk "NR % ${CIRCLE_NODE_TOTAL} == ${CIRCLE_NODE_INDEX}"
)"

if [ -z "${our_work}" ]; then
  echo "more parallelism than tests"
  exit 0
fi

echo "${our_work}" | tr '\n' '\0' | xargs -n1 -0 -I% -t sh -c "%"