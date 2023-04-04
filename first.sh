x (){
    echo 1.st param=...${1:-default}
}

coffee() {
    local now=$(date +%s)
    local start=$(date -d ${NEXT} +%s)
    local end=$(( ${start} + 600 ))

    local remain=$(( (${end}-${now})/60 ))

    if [[ ${now} -lt ${start} ]]; then 
      echo minutes till next coffee: $(( (${start}-${now})/60 ))
    else  
      if [[ ${remain} -lt 0 ]]; then 
        echo coff break is ended
      else 
        echo time left: ${remain}
      fi
    fi
}

end=${1:-$(( ${start} + 600 ))}

miko(){
    local time=${1:-${NEXT:-1730}}
    local now=$(date +%s)
    local pause=$(date -d ${time}  +%s)
    echo time left till ${time} : $(( (${pause} - ${now} ) /60 )) 
}

hint () { 
    latest=$(
        curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/gists/2aa74872779de2747c1328599524c4e9/commits | jq .[0].version -r
    )
    curl -s https://gist.githubusercontent.com/lalyos/2aa74872779de2747c1328599524c4e9/raw/${latest}/.history | tail -${1:-1}
}

echo ${key%.pub}

isa() {
  select key in ~/.ssh/id*.pub 
    do chmod 600 ${key%.pub}
    ssh-add ${key%.pub}
    break
  done
}