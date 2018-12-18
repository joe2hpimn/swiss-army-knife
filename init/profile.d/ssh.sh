#!/usr/bin/env bash

if [[ ! -d "/tmp/ssh" ]]; then
   mkdir /tmp/ssh
fi

ssh-add-key(){
	 [[ -f ${WB}/prod-keys/id_rsa_baotingfang ]] && ssh-add -t 600 ${WB}/prod-keys/id_rsa_baotingfang && return

	# just work in zsh shell
	read -s pass
	echo
	openssl enc -d -aes-256-cfb -in ${BASE_DIR}/config/ssh/sample.txt  -pass pass:${pass} | ssh-add -t 600 -
}

cert-generate(){
	 test $# -ne 1 && echo "uage: $(basename $0) cert_name" && exit 1
	 openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $1_private.key -out $1.crt
}

cert-generate-by-private-key(){
	 test $# -ne 2 && echo "usage: $(basename $0) private_key ca_file_name" && exit 1

	 private_key=$1
	 ca_file_name=$2
	 openssl req -x509 -days 365 -new -key ${private_key} -out ${ca_file_name}
}

cert-get-public-key-from-cert(){
	 ca_file=$1
	 test $# -ne 1 && echo "usage: $(basename $0) certificate-file" && exit 1
	 openssl x509 -in ${ca_file} -noout -pubkey
}

cert-get-public-key-from-private-key(){
	 # extract public key from ssh private key
	 # public key format: PEM
	 test $# -ne 1 && echo "usage: $(basename $0) private-key-file" && exit 1
	 openssl rsa -in $1 -pubout 2>/dev/null
}

ssh-convert-to-pem-pubkey(){
	 # CONVERT SSH PUB KEY TO PEM PUB KEY
	 ssh_public_key=$1
	 test $# -ne 1 && echo "usage: $(basename $0) ssh-pubkey-file" && exit 1
	 ssh-keygen -f ${ssh_public_key} -e -m pem
}

ssh-convert-pem-to-ssh-public-key(){
	 # get ssh public key from pem public key
	 # pem public key format: PEM
	 pem_public_key=$1
	 test $# -ne 1 && echo "usage: $(basename $0) pem-pubkey-file" && exit 1
	 ssh-keygen -i -m PKCS8 -f ${pem_public_key}
}

ssh-extract-ssh-public-key-from-ssh-private-key(){
	 # extract public key from ssh private key
	 # return ssh public key

	 ssh_private_key=$1
	 test $# -ne 1 && echo "usage: $(basename $0) ssh-prikey-file" && exit 1
	 ssh-keygen -f ${ssh_private_key} -y
}
