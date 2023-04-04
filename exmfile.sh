#old=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
#new=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

#old=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

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

addReaction(){
    cat <<EOF
{"content": "$1"}
EOF
}

passIss(){
    declare issNum=${1:-89}
    declare comment=${2:-"no comment here"}
    
    getCommJson=$(jsonCom "${comment}")
    ghub /repos/lalyos-trainings/git-wed/issues/${issNum}/comments -d "${getCommJson}"
}

#https://api.github.com/repos/lalyos-trainings/git-wed/comments/COMMENT_ID/reactions

# listReactions 89 valami
# ha már van: +1, -1, új: laugh, confused, heart, hooray, rocket, eyes
listReactions(){
    declare id=${1:-89}
    # ha nincs id írja ko hogy kötelező!

    #ghub repos/lalyos-trainings/git-wed/issues/${id}/reactions -s | jq .[].content # ki kell listáznia!
    if [ $2  ];then 
        contenJson=$(addReaction "$2")
        #ghub repos/lalyos-trainings/git-wed/issues/${id}/reactions -d "${contenJson}"
    fi


}
