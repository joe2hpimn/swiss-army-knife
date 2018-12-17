#!/usr/bin/env bash

# source /usr/local/bin/virtualenvwrapper.sh

# which deactivate > /dev/null || workon tools

python-vim-init(){
	# pip install neovim jedi
	pip3 install neovim jedi psutil setproctitle
}

python-aliyun-install-sdk(){
	pip install --upgrade aliyun-python-sdk-core  aliyun-python-sdk-ecs aliyun-python-sdk-cdn \
		aliyun-python-sdk-rds aliyun-python-sdk-cms aliyun-python-sdk-mts aliyun-python-sdk-vod \
		aliyun-python-sdk-live aliyun-python-sdk-push aliyun-python-sdk-iot  aliyun-python-sdk-domain \
		aliyun-python-sdk-httpdns aliyun-python-sdk-green aliyun-python-sdk-emr aliyun-python-sdk-kms \
		aliyun-python-sdk-slb aliyun-python-sdk-cloudphoto aliyun-python-sdk-sas-api aliyun-python-sdk-ons aliyun-python-sdk-vpc \
		aliyuncli aliyun-ros-cli
}
