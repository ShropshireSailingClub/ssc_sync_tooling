CONNECTION_ARGS=--progress --no-update-modtime
EXCLUDES=--exclude '.git/**' --exclude .DS_Store
REMOTE_SSC=sscftp:public_html/
LOCAL_SSC=../www.shropshiresailingclub.co.uk

.PHONY: default
# You're looking at it
help:
	awk '$$1 == "#" { help = $$0 }; $$1 ~ /^[^.][a-zA-Z0-9]*:$$/ { print $$1 "\t" help ; help = "" }' $(abspath $(lastword $(MAKEFILE_LIST)))
	@echo

.PHONY: check
# Check and output which files differ remotely to local
check:
	rclone check ${CONNECTION_ARGS} ${EXCLUDES} ${REMOTE_SSC} ${LOCAL_SSC}

.PHONY: download
# Grab remote content into local folder
download:
	rclone copy ${CONNECTION_ARGS} ${EXCLUDES} ${REMOTE_SSC} ${LOCAL_SSC}

.PHONY: upload_branch
# Given local copy is on a branch, upload the diff to master
upload_branch:
	GIT_DIR=${LOCAL_SSC}/.git git diff --name-only master..HEAD | tee tmp/files_to_upload.txt | sed 's/^/ -> /'
	@echo
	rclone copy -v ${CONNECTION_ARGS} --include-from tmp/files_to_upload.txt ${LOCAL_SSC} ${REMOTE_SSC}
	rm -rf tmp/files_to_upload.txt
