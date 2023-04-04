x(){
    echo 1.st param=... ${1:-default}
}

askname(){
    read username
    if [[ -z ${username} ]];then 
            echo No name!
        else 
            echo Ezt írtad be: $username .
    fi 
}

coffee(){
    local now=$(date +%s)
    local start=$(date -d ${NEXT} +%s)
    local end=$((${start} + 600))

    local remain=$(( (${end} - ${now})/60 ))

    if [[ ${now}-${start} -lt 0 ]] ;then
        echo minutes till next coffe: $(( (${start}-${now})/60 ))
    else
        # if test ${remanin} -lt 0
        if  [[ ${remain} -lt 0 ]];then  
            echo coffe break is end
        else 
            echo time left: ${remain}
        fi
    fi
}

setup(){
    local users=$(curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/organizations/2652852/team/7635002/members | jq .[].login)

    for user in ${users}; do
        echo ${user}
    done 
}

miko(){
    local time=${1:-${NEXT:-17:30}}
    local now=$(date +%s)
    local pause=$(date -d ${time} +%s)

    echo Time left till ${time} $((( ${pause}- ${now} ) /60  )) min.    
    # echo $((( $(date -d ${1:-17:30} +%s) - $(date +%s) ) /60  ))
} 

hint () { 
    latest=$(curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/gists/2aa74872779de2747c1328599524c4e9/commits | jq .[0].version -r)

    curl -s https://gist.githubusercontent.com/lalyos/2aa74872779de2747c1328599524c4e9/raw/${latest}/.history | tail -${1:-1}
}


# curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/organizations/2652852/team/7635002/members | jq .[].login