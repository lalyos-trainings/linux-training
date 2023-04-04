
start-rh() {
    img=projects/rocky-linux-cloud/global/images/rocky-linux-8-optimized-gcp-v20230306

    start rocky ${img}
}

start() {
    declare name=$1
    : ${name:=debian}
    : ${image:=projects/debian-cloud/global/images/debian-11-bullseye-v20230306}

    gcloud compute instances create ${name} \
      --project=cs-k8s \
      --zone=europe-west3-b \
      --machine-type=e2-medium \
      --network-interface=network-tier=PREMIUM,subnet=default \
      --metadata=startup-script=curl\ -sL\ https://get.docker.com\ \|\ sh$'\n'apt-get\ install\ -y\ jq\ tree \
      --no-restart-on-failure \
      --maintenance-policy=TERMINATE \
      --provisioning-model=SPOT \
      --instance-termination-action=STOP \
      --service-account=244914469317-compute@developer.gserviceaccount.com \
      --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
      --tags=http-server,https-server \
      --create-disk=auto-delete=yes,boot=yes,device-name=training,image=${image},mode=rw,size=10,type=projects/cs-k8s/zones/europe-west3-b/diskTypes/pd-balanced \
      --no-shielded-secure-boot \
      --shielded-vtpm \
      --shielded-integrity-monitoring \
      --labels=ec-src=vm_add-gcloud \
      --reservation-affinity=any

}

setup() {
    #addgroup elite

    team=$(curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/organizations/2652852/team/7635002/members | jq -r .[].login)
    for name in ${team}; do 
      add-user ${name,,}
    done
}

clean() {
    team=$(curl -s -H "Authorization: Bearer $GH_TOKEN" https://api.github.com/organizations/2652852/team/7635002/members | jq -r .[].login)
    for name in ${team}; do 
      deluser ${name} --remove-home 
    done
}

add-user() {
    declare user=$1 group=${2:-elite}
    : ${user:? required}
    
    adduser --disabled-password --gecos "" ${user}
    adduser ${user} ${group}

    mkdir /home/${user}/.ssh
    chmod 700 /home/${user}/.ssh
    chown ${user}:${user} /home/${user}/.ssh

    curl -L github.com/${user}.keys >> /home/${user}/.ssh/authorized_keys
    chmod 644 /home/${user}/.ssh/authorized_keys
    chown ${user}:${user} /home/${user}/.ssh/authorized_keys

    # if [[ -z $1 ]]; then
    #   echo please specify github username
    # fi
}