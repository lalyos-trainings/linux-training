ghub() {
    declare path=$1
    : ${path:? required}
    shift
    curl \
      -H "Authorization: Bearer $GH_TOKEN" \
      https://api.github.com/${path#/} \
     "$@"
}

comment_json(){

cat <<EOF
{
  "body":"$1"
}
EOF
}

comment(){
 declare mess_id=${1:-89}
 declare mess=${2:- "no com"} 
 
 com=$(comment_json "${mess_id}")
 ghub repos/lalyos-trainings/git-wed/issues/89/comments -d "${com}"
}

react_a(){
  declare reaction=$1
  :  ${reaction:? required}

  cat <<EOF
{
 
  "body":"$reaction"
}
EOF
}
#heart

react (){
if [ $# -eq 0 ]; then
  echo "Add meg az issue azonositojat"
fi

declare issue=$1 reaction=$2

if [ $# -eq 1 ]; then
  echo "$issue issue reakcioi:"
  ghub repos/lalyos-trainings/git-wed/issues/89/reactions -s | jq .[].content -r
fi

if [ $# -eq 2 ]; then
  echo "Az issue #$issue hozzaadva a $reaction reakcio"
  b= $(react_a "$reaction")
  ghub repos/lalyos-trainings/git-wed/issues/89/reactions -d "${b}"
 
fi
}
