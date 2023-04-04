



ghub() {
    declare path=$1
    : ${path:? required}
    shift
    curl \
      -H "Authorization: Bearer $GH_TOKEN" \
      https://api.github.com/${path#/} \
     "$@"
}

com-json() {
    cat << EOF
{
  "body":"${1}"
}
EOF
}

add-comment() {
    declare body=$1 id=${2:-89}
    : ${body:? required}
    comment=$(com-json "$@")
    ghub repos/lalyos-trainings/git-wed/issues/${id}/comments -d "${comment}"
}


# ha nem kap parametert akkor issue number közelező
# második paraméter nincs meg akkor listáz
# ha megad reactiont, akkor rárakja



