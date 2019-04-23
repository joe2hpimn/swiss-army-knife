#!/usr/bin/env bash

pivnet-login-staging(){
	pivnet login --api-token="${PIVNET_TOKEN-STAGING}" --host=${PIVNET_HOST_STAGING}
}