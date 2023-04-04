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
react (){
    declare issue=${1:-89}
    declare reaction=${2:- "no reaction"} 
: ${issue:? required} ${reaction:? required}
if (issue="required" && reaction="required"); then
  echo issue: ${issue}
fi 



}
