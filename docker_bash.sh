######## ================ .stack.env   =================== #######
# id for your stack
GC_INSTANCE_ID=nn  # eg al, nn, ll, ht, tt, dn, tn, etc.
# ip of targeted server
PUBLISHED_HOST=34.87.182.148  # eg staging5 as 34.87.120.231, staging4 as 34.87.96.34
# 0/1 for dont/do pull latest code
SKIP_GIT_PULL=0
# rebuild all the Docker image
REMOVE_CURRENT_BUILD=1
# just build container in list, put blank to run all container " venta sentinel essentials"
ONLY_CONTAINERS=atlas
SKIP_DB_RESET=1
# git repo uri
GIT_URI=bitbucket.org:gigacover
# git branch to deploy for each app
     ATLAS_GIT_BRANCH=replicate_release
  SENTINEL_GIT_BRANCH=develop
     VENTA_GIT_BRANCH=feature/gc-ducle-docker-stack2
ESSENTIALS_GIT_BRANCH=feature/gc-ducle-docker-stack
       MER_GIT_BRANCH=release
      DASH_GIT_BRANCH=release
######## ================ end commands =================== ######


######## ================ DOCKER START =================== #######
function start_docker_atlas() {
  stack_env='./gc-staging/.stack.env'
  # fill in  your stack info in .stack.env
    # fill in by below command
    rm -rf $stack_env; echo "
        GC_INSTANCE_ID=ll
        PUBLISHED_HOST=34.87.182.148
        SKIP_GIT_PULL=0
        REMOVE_CURRENT_BUILD=1
        SKIP_DB_RESET=1
        ONLY_CONTAINERS='atlas'
        GIT_URI=bitbucket.org:gigacover
             ATLAS_GIT_BRANCH=$1
    " > $stack_env
  # review stack config before run
  cat $stack_env
  # spin the stack up
  ./gc-staging/up-localhost.sh
}
######## ================ end commands    =================== ######


######## ================ Docker commands =================== ######
docker ps --filter name=_nn -aq | xargs docker start  # start docker by the way which filter docker image name
jq -c ".postgres.host = \"${your_ip}\"" config.test.json > tmp.1.json && mv tmp.1.json  config.test.json
docker inspect gc_postgres_nn | grep -oP '(?<="IPAddress": ")[^"]*' | head -n1   # find ip of docker image
docker run -it image_id || image_name  # run docker image
docker exec -it image_id || image_name bash  # cd to docker image
... # how to build a docker image?
######## ================ end commands    =================== ######



####### ================
# check moh via  https://prs.moh.gov.sg/prs/internet/profSearch/getSearchDetails.action?hpe=SMC&regNo={}&psearchParamVO.language=eng