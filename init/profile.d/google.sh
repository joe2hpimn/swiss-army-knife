#!/usr/bin/env bash
#shellcheck disable=1090

# The next line updates PATH for the Google Cloud SDK.
if [[ -f "${OPT}/google-cloud-sdk/path.zsh.inc" ]]; then
	source "${OPT}/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [[ -f "${OPT}/google-cloud-sdk/completion.zsh.inc" ]]; then
	source "${OPT}/google-cloud-sdk/completion.zsh.inc"
fi

gcp-login(){
	gcloud auth login
}

gcp-login-workstation1(){
	gcloud compute \
		--project "data-gp-toolsmiths" \
		ssh --zone "asia-east1-a" "pivotal@gp-toolsmiths-workstation-1" \
		--ssh-flag=-A
}

gcp-login-workstation2(){
	gcloud compute \
		--project "data-gp-toolsmiths" \
		ssh --zone "asia-east1-a" "gpadmin@gp-toolsmiths-workstation-2" \
		--ssh-flag=-A
}
