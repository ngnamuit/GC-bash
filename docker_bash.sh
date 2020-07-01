######## ================ "Docker start"
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
docker inspect gc_postgres_dl | grep -oP '(?<="IPAddress": ")[^"]*' | head -n1   # find ip of docker image
docker run -it image_id || image_name  # run docker image
docker exec -it image_id || image_name bash  # cd to docker image
... # how to build a docker image?
######## ================ end commands    =================== ######