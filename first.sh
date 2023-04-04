json_ketto() {
  cat <<EOF
{
  "body":"${1:? body required}"
}
EOF
}

post_comment(){
  declare numb=$2 body=$1
  : ${numb:=89}
  : ${body:? required}
  json=$(json_ketto "${body}")
  ghub /repos/lalyos-trainings/git-wed/issues/${numb}/comments -d "${json}"
}

ghub /repos/lalyos-trainings/git-wed/issues/89/comments -d '{"body":"test"}'