post_comment(){
  declare title=$1 body=$2
  : ${title:? required} ${body:? required}
  json=$(issue-json "$@")
  ghub repos/lalyos-trainings/git-wed/issues/comments/1495894990/comments -X POST -d {"body":"test120"}'
}