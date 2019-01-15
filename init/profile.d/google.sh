#!/usr/bin/env bash

# The next line updates PATH for the Google Cloud SDK.
if [[ -f "${OPT}/google-cloud-sdk/path.zsh.inc" ]]; then
	source "${OPT}/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [[ -f "${OPT}/Cells/google-cloud-sdk-218.0.0/completion.zsh.inc" ]]; then
	source "${OPT}/Cells/google-cloud-sdk-218.0.0/completion.zsh.inc"
fi

gcp-login(){
	gcloud auth login
}

gcp-login-workstation(){
	gcloud compute \
		--project "data-gp-toolsmiths" \
		ssh --zone "asia-east1-a" "gpadmin@gp-toolsmiths-workstation-2" \
		--ssh-flag=-A
}