Cisync() {
    echo "===="
    echo "${MERGE_FROM}"
    echo "${MERGE_TO}"

    if [ "${MERGE_FROM}" = "CIRCLE_BRANCH" ]; then
        MERGE_FROM=$CIRCLE_BRANCH
    fi
    if [ "${MERGE_TO}" = "ALL" ]; then
        MERGE_TO=$(git for-each-ref --format="%(refname:short)" refs/heads/ | grep -v "${MERGE_FROM}")
    fi

    echo "===="
    echo "${MERGE_FROM}"
    echo "${MERGE_TO}"

    # FOR LOCAL
    # MERGE_FROM="alpha"
    # MERGE_TO=$(git for-each-ref --format="%(refname:short)" refs/heads/ | grep -v "${MERGE_FROM}")

    cp -Rp .circleci ../

    echo "LOOP"
    for _sync_branch in ${MERGE_TO}
    do
        echo "${_sync_branch}"
        git checkout "${_sync_branch}"
        cp -Rp ../.circleci ./
        git add .circleci/*
        git commit -m "[skip ci] cisync auto merge from ${MERGE_FROM} -> ${_sync_branch}"
        git push
    done

    # _from=`git branch --show-current`
    # git config --global user.name "cisync"
    # git config --global user.email "cisync@rhems-japan.co.jp"
    # cp -Rip .circleci ../
    # # cp -Rip ReadMe.md ../

    # for _sync_branch in `cat .circleci/cisync/config | egrep -v "^#|${_from}"`
    # do
    #     git checkout ${_sync_branch}
    #     rm -Rf .circleci
    #     cp -Rip ../.circleci ./
    #     # cp ../ReadMe.md ./
    #     git add .circleci/*
    #     git commit -m "[skip ci] cisync auto merge from ${_from} -> ${_sync_branch}"
    #     git push
    # done

    echo "OK"
}

# Will not run if sourced for bats-core tests.
# View src/tests for more information.
ORB_TEST_ENV="bats-core"
if [ "${0#*$ORB_TEST_ENV}" == "$0" ]; then
    Cisync
fi
