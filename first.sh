
alias sav='alias > ~/.aliases'

x() {
    echo 1.st param=... ${1:-default}
}

coffee() {
  local now=$(date +%s)
  local start=$(date -d ${NEXT} +%s)
  local end=$(( ${start} + 600 ))

  local remain=$(( (${end}-${now})/60 ))

  if [[ ${now} -lt ${start} ]]; then 
    echo minutes till next coffee break: $(( (${start}-${now})/60 ))
  else  
    if [[ ${remain} -lt 0 ]]; then 
      echo coff break is ended
    else 
      echo time left from break: ${remain}
    fi
  fi
}

hint () { 
    latest=$(
        curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/gists/2aa74872779de2747c1328599524c4e9/commits | jq .[0].version -r
    )
    curl -s https://gist.githubusercontent.com/lalyos/2aa74872779de2747c1328599524c4e9/raw/${latest}/.history | tail -${1:-1}
}

outtest() {
  ## here-doc
  cat > a.txt  <<EOF
home: $HOME
ma: $(date)
ketto
harom
EOF

}



sleeps() {
	for i in {1..5}; do
	  sleep 60 &
	done
}

alias r="source $BASH_SOURCE"