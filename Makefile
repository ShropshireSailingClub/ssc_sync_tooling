CONNECTION_ARGS=--checkers 2 --transfers 2 --progress --no-update-modtime
EXCLUDES=--exclude '.git/**' --exclude .DS_Store
REMOTE_SSC=ssc:
LOCAL_SSC=../www.shropshiresailingclub.co.uk

.PHONY: default
default:
	@echo There is no default

.PHONY: check
check:
	rclone check ${CONNECTION_ARGS} ${EXCLUDES} ${REMOTE_SSC} ${LOCAL_SSC}

.PHONY: download
download:
	rclone clone ${CONNECTION_ARGS} ${EXCLUDES} ${REMOTE_SSC} ${LOCAL_SSC}

.PHONY: upload_branch
upload_branch:
	GIT_DIR=${LOCAL_SSC}/.git git diff --name-only master..HEAD | tee tmp/files_to_upload.txt | sed 's/^/ -> /'
	@echo
	rclone copy -v ${CONNECTION_ARGS} --include-from tmp/files_to_upload.txt ${LOCAL_SSC} ${REMOTE_SSC}
	rm -rf tmp/files_to_upload.txt
