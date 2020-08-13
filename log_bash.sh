# check log service when don't know log address
journalctl -f -u atlas-api.service -n100


##========== CIRCLECI REGION    =================##
# 1. setup circleci
  # 1.1 Should be a docker to run as an os
  # 1.2 Follow ref https://www.youtube.com/watch?v=0OjEx2UzLUI


##=========== CIRCLECI ENDREGION =================##


# FIND TOTAL and find number %
perl -pe 's/.*?TOTAL.*?(\d+%)/$1/s/%//' tmp.txt