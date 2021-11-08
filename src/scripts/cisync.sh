Cisync() {
    cat .circleci/config.yml

    echo ${MERGE_FROM}
    echo ${MERGE_TO}

    # _from=`git branch --show-current`
    # git config --global user.name "cisync"
    # git config --global user.email "cisync@miraibox"
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
