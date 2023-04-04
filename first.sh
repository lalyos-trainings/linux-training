echo first.sh bol frissitve

hint () { 
 latest=$(
 curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/gists/2aa74872779de2747c1328599524c4e9/commits | jq .[0].version -r
 )
 curl -s https://gist.githubusercontent.com/lalyos/2aa74872779de2747c1328599524c4e9/raw/${latest}/.history | tail -${1:-1}
}


coffee(){

    local now=$(date +%s)
    local start=$(date -d ${NEXT} +%s)
    local end=$(( ${start} + 600 ))
    local remain=$(( ( ${end} - ${now} ) / 60 ))
    
    if [[ ${now} -lt ${start} ]]; then
        echo minutes until next coffeebreak: $(( ($start - $now) / 60 ))
    else
        if [[ ${remain} -lt 0 ]]; then 
            echo coffeebreak is ended
        else
            echo time left from break: ${remain}
        fi
    fi 

}

miko () { 
    local time=${1:-${NEXT:-1730}}
    local now=$(date +%s)
    local pause=$(date -d ${time} +%s)
    echo time left until ${time} : $(( ( ${pause} - ${now} ) /60  )) minutes 
}



#masodikhet
creadir() {
  if mkdir x 2>/dev/null; then
    echo created
  else
    echo directory already exists
  fi
}

names() {
  i=0
  for name in bela geza jeno; do 
    echo === $name
    i=$(( $i + 1))
    echo $i: doing something $name
  done
}


sleeps () {
  i=1
  for i in 1 2 3 4 5; do 
    sleep 60 &
    i=$(( $i + 1))
  done
}


isa() {
    select key in  ~/.ssh/id_rsa*.pub; do 
    ssh-add ${key%.pub}
    if [[ $REPLY == "q" ]]; then
        break;
    fi
    done

    #ssh-add -l
}


#x(){
#    echo 1st param = ${1:-default
#}
#}