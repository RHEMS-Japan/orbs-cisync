Cisync() {
    merge_from=$(eval echo "${MERGE_FROM}")
    merge_to=${MERGE_TO}
    if [ "${merge_to}" = "ALL" ]; then
        git branch -r | grep -v '\->' | while read -r remote; do
            git branch --track "${remote#origin/}" "$remote" || true
        done
        git fetch --all
        merge_to=$(git for-each-ref --format="%(refname:short)" refs/heads/ | grep -v "${merge_from}")
    fi

    echo "===="
    echo "from: ${merge_from}"
    echo "  to: ${merge_to}"
    echo "===="

    cp -Rp .circleci ../
    git config --global user.name "${USER_NAME}"
    git config --global user.email "${USER_EMAIL}"

    for _sync_branch in ${merge_to}; do
        echo "${_sync_branch}"
        git checkout "${_sync_branch}"
        rm -rf .circleci
        cp -Rp ../.circleci ./
        git add .circleci
        git diff-index --quiet HEAD || git commit -m "[skip ci] cisync auto merge from ${merge_from} -> ${_sync_branch}"
        git push
    done

    echo "OK"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Cisync
fi
