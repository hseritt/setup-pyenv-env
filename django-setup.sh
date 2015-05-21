#!/usr/bin/env bash

source ./lib.sh

SKIPPYENVINST=0

function usage {
	echo "usage: django-setup.sh [options]"
	echo "    options: "
	echo "        --skip-pyenv-install  Do not install pyenv"
	echo "        --help                Show help options"
	echo
}

while [[ $# > 0 ]]
do
	key="$1"
	case $key in
		--skip-pyenv-install)
			SKIPPYENVINST=1
			shift
			;;
		--help)
			usage
			exit
			;;
		*)
			echo "Option: $key not recognized." 
			sleep 1
			break
			;;
	esac
done

if [ "$SKIPPYENVINST" == 0 ]
then
	install_pyenv
fi

install_python
set_python_version
create_project
get_end_msg
