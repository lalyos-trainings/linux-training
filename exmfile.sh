GH_TOKEN=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

alias r="source $BASH_SOURCE"

ghub() {
    declare path=$1
    : ${path:? required}
    shift
    curl \
        -H "Authorization: Bearer $GH_TOKEN" \
        https://api.github.com/${path#/} \
    "$@"
}

jsonCom(){
cat <<EOF
{"body": "$1"}
EOF
}

passIss(){
    declare issNum=${1:-89}
    declare comment=${2:-"no comment here"}
    
    getCommJson=$(jsonCom "${comment}")
    ghub /repos/lalyos-trainings/git-wed/issues/${issNum}/comments -d "${getCommJson}"
}