echo hello

x() {
    echo 1.st param=  ${1:-default}
}

miko () { 
    local time=${1:-${NEXT:-1730}}
    local now=$(date +%s)
    local pause=$(date -j -f "%H%M" ${time} +%s)
    echo time left till ${time} : $(( ( ${pause} -  ${now}) /60  )) minutes
}

coffee() {
    local now=$(date +%s)
    local start=$(date -j -f "%H%M" ${NEXT} +%s)
    local end=$(( ${start} + 600 ))

    local remain=$(( (${end} - ${now}) / 60 ))

    if [[ ${now} -lt ${start} ]]; then
        echo minutes till next coffee: $(( (${start} - ${now}) / 60 ))
    else
        if [[ ${remain} -lt 0 ]]; then
            echo coffee break is ended
        else 
            echo time left: ${remain}
        fi
    fi

}