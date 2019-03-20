#!/usr/bin/env bash

cf-login-pcfcn(){
	cf login -a https://api.pcfcn.pivotal.io \
		-u ${CF_ADMIN} \
		-p ${CF_PASS} \
		-o baotingfang \
		-s www \
		--skip-ssl-validation
}

uaa-login-pcfcn(){
	uaac target uaa.pcfcn.pivotal.io --skip-ssl-validation
	uaac token client get ${UAA_CLIENT_ADMIN} -s ${UAA_CLIENT_PASS}
}

cf-login-books(){
	cf login -a https://api.10.152.11.60.xip.io \
		-u ${CF_ADMIN} \
		-p ${CF_PASS} \
		-o baotingfang \
		-s www \
		--skip-ssl-validation
}

cf-login-toolsmiths(){
	cf login -a  https://api.run.pivotal.io \
		-u ${TOOLSMITHS_CF_USER} \
		-p ${TOOLSMITHS_CF_PASS} \
		-o "GP Toolsmiths" \
		-s "development"
}


uaa-login-books(){
	uaac target uaa.10.152.11.60.xip.io --skip-ssl-validation
	uaac token client get ${UAA_CLIENT_ADMIN} -s ${UAA_CLIENT_PASS}
}

