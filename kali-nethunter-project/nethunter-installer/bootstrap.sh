#!/usr/bin/env sh

GIT_ACCOUNT=kalilinux
GIT_REPOSITORY=nethunter/build-scripts/kali-nethunter-devices

ABORT() {
	[ "$1" ] && echo "Error: $*"
	exit 1
}

cd "$(dirname "$0")" || ABORT "Failed to enter script directory!"

if [ ! "$(basename "$(pwd)")" = "nethunter-installer" ]; then
	ABORT "You must run this script from the nethunter-installer directory!"
fi

if [ -d devices ]; then
	echo "The devices directory already exists, choose an option:"
	echo "   U) Update devices to latest commit (default)"
	echo "   D) Delete devices folder and start over"
	echo "   C) Cancel"
	printf "[?] Your choice? (U/d/c): "
	read -r choice
	case ${choice} in
		U*|u*|"")
			echo "[i] Updating devices (fetch & rebase)"
			cd devices || ABORT "Failed to enter devices directory!"
			git fetch && git rebase || ABORT "Failed to update devices!"
			exit 0
			;;
		D*|d)
			echo "[i] Deleting devices folder"
			rm -rf devices ;;
		*)
			ABORT ;;
	esac
fi

clonecmd="git clone"

printf "[?] Would you like to grab the full history of devices? (y/N): "
read -r choice
case ${choice} in
	y*|Y*) ;;
	*)
		clonecmd="${clonecmd} --depth 1" ;;
esac

printf "[?] Would you like to use SSH authentication (faster, but requires a GitHub account with SSH keys)? (y/N): "
read -r choice
case $choice in
	y*|Y*)
		cloneurl="git@gitlab.com:${GIT_ACCOUNT}/${GIT_REPOSITORY}" ;;
	*)
		cloneurl="https://gitlab.com/${GIT_ACCOUNT}/${GIT_REPOSITORY}.git" ;;
esac

clonecmd="${clonecmd} $cloneurl devices"
echo "[i[ Running command: ${clonecmd}"

${clonecmd} || ABORT "Failed to git clone devices!"

exit 0
