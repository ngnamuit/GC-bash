#!/bin/bash
PWD=`cd $(dirname "$BASH_SOURCE") && pwd`; CODE=`cd $PWD/.. && pwd`

#set -e  # DO NOT turn set -e on cause it will make xdist-run exit exit_code=1 ie failed if any rerun occurred even when that results as all-test-passed ref. https://stackoverflow.com/a/11231970/248616

# number of CPU cores for ubuntu ref. https://stackoverflow.com/a/17089001/248616
#                         macos  ref. https://github.com/memkind/memkind/issues/33#issuecomment-316615308
if [[ "$OSTYPE" = "darwin"* ]]; then cpu_cores=`sysctl -n hw.physicalcpu`; else cpu_cores=`nproc --all`; fi

if [[ $cpu_cores -lt 2 ]]; then
    echo; echo "Require CPU to have >=2 cores in xdist parallel mode - this machine has $cpu_cores";
    exit 1;
else
    echo; echo "Running pytest-xdist with $cpu_cores cores";
fi


pytest_run_log=`mktemp`
echo "Log file written to $pytest_run_log"; echo

skip_pipenv_sync=$1
if [[ $skip_pipenv_sync == '-skip_pipenv_sync' ]]; then skip_pipenv_sync=1; else skip_pipenv_sync=0; fi

XDIST_WORKER_NUM=$2
if [[ -z $XDIST_WORKER_NUM ]]; then XDIST_WORKER_NUM=4; fi

cd $CODE
    if [[ $skip_pipenv_sync == 0 ]]; then
        pipenv sync
    fi

    pipenv run pytest -p no:warnings   --tb=short        -n${XDIST_WORKER_NUM}      --dist=loadfile  --cov-report=term-missing   --cov=atlas --cov=tasks       --reruns 2        ${@:3}                          2>&1 | tee $pytest_run_log
    #                 #no warning      #traceback short  #number of worker to run                    #list out missing lines     #folders need to coverage    #time of reruns   #forward params from the 2nd                #also log to file
    #                                                                                                                                   #ref. https://stackoverflow.com/a/9057392/248616

echo "Done running xdist mode - status_code=$?"



# find number of percentage pytest-coverage
min_coverage="79"
code_coverage=`grep 'TOTAL' $pytest_run_log | grep -o -P '[0-9]*(\.[0-9]*)?(?=%)'`
echo "Minimum coverage percentage: ${min_coverage}%"; echo "Code coverage percentage: ${code_coverage}%"
if [[ "$code_coverage" -ge "$min_coverage" ]]; then
    # if parallel run :has_failed_test, we rerun those failed one(s) in normal/non-parallel mode
    has_failed_xdist_test=`grep -c  -E '=+.+failed|=+.+error'  $pytest_run_log `  # know if parallel test failed ref. https://github.com/namgivu/pytest-start/commit/a921f9bf2d66519604e5b6846afedfd17198efc1
    if [[ "$has_failed_xdist_test" == "0" ]]; then
        exit 0
    else
        pipenv run pytest  -p no:warnings  --tb=short        --lf                 2>&1 | tee $pytest_run_log
        #                  #no warning     #traceback short  #reruns last failed  #also log to file

        has_failed_2nd_run=`grep -c  -E '=+.+failed|=+.+error'  $pytest_run_log `  # know if parallel test failed ref. https://github.com/namgivu/pytest-start/commit/a921f9bf2d66519604e5b6846afedfd17198efc1
        if [[ $has_failed_2nd_run == '0' ]]; then
            exit 0
        else
            echo "All efforts failed"
            exit 1
        fi
    fi
else
    echo "Pytest coverage failed"
    exit 1
fi

echo "We should not reach here - status_code=$?"

usage_hint="
    PSQL='docker exec gc_postgres psql -Upostgres' ./db/drop_xdist_db.sh
    PSQL='docker exec gc_postgres psql -Upostgres' ./db/create_db.sh
    PSQL='docker exec gc_postgres psql -Upostgres' ./bin/modify-connections-postgresqlconf.sh 500
    docker restart gc_postgres
    docker exec gc_postgres psql -Upostgres -c 'show max_connections' -t

    ./bin/run-test-parallel.sh
    ./bin/run-test-parallel.sh  -skip_pipenv_sync
    ./bin/run-test-parallel.sh  -do_pipenv_sync          8
    #                           #whether to pipenv sync  #number of worker
"
