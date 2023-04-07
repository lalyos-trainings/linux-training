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

# ha már van: +1, -1, új: laugh, confused, heart, hooray, rocket, eyes
listReactions(){
    # ha nincs id írja ko hogy kötelező!
    declare id=${1:? required}

    echo Válassz emot "(+1=Like) (-1=Not Like) "\ "ha befejezted ctrl+d" 
    emo=$(selectEmo)

    echo $(getreactions "$id")

    printf '%12s\n' "ALL REACTIONS"

    cat emos.sh | while read reactions; do  
        echo ${reactions}
    done

    echo $(postReaction "$id" "$emo") 

}

selectEmo(){
    select emo in "+1" "-1" laugh confused heart hooray rocket eyes
    do
        echo ${emo}
    done
}

getreactions(){
    # listáza ki
    ghub repos/lalyos-trainings/git-wed/issues/$1/reactions -s | jq .[].content > emos.sh
}

postReaction(){
    #adja hozzá az emo-t
    contenJson=$(addReaction "$2")
    ghub repos/lalyos-trainings/git-wed/issues/$1/reactions -d "${contenJson}" -s | jq .[] > /dev/null
}
