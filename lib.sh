
ubuntu_str="Ubuntu"
centos_str6="CentOS"
centos_str7="Kernel"
rhel_str="Red Hat"

ubuntu_found_msg="Ubuntu Linux is detected."
ubuntu_profile=".bashrc"
ubuntu_install="apt-get install"

rh_found_msg="CentOS or RHEL is detected."
rh_profile=".bash_profile"
rh_install="yum install"

pyenv_inst_url="https://raw.github.com/yyuu/pyenv-installer/master/bin/pyenv-installer"
pyenv_inst_msg='"pyenv" is not installed. We will try an install now.'
pyenv_installed_msg='"pyenv" appears to be installed:'

db_options="MySQL-python psycopg2 pysqlite"

project_dirs=("templates" "static/css" "static/js" "static/img")

function check_os {
	ubuntu=$(cat /etc/issue|grep $ubuntu_str|wc -l)
	centos=$(cat /etc/issue|grep $centos_str6|wc -l)
	centos=$(cat /etc/issue|grep $centos_str7|wc -l)
	redhat=$(cat /etc/issue|grep $rhel_str|wc -l) 
}

function handle_ubuntu {
	echo $ubuntu_found_msg
	sleep 2
	profile=ubuntu_profile
	sudo $ubuntu_install curl git-core gcc make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libssl-dev
}

function handle_redhat {
	echo $rh_found_msg
	sleep 2
	profile=$rh_profile
	sudo $rh_install curl git gcc make zlib-devel bzip2-devel bzip2-libs readline-devel sqlite-devel openssl-devel
}

function run_pyenv_installer {
	curl -L $pyenv_inst_url | bash
}

function set_pyenv_profile {
	echo >> $HOME/$profile
	echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> $HOME/$profile
	echo 'eval "$(pyenv init -)"' >> $HOME/$profile
	echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/$profile
	echo >> $HOME/$profile
	source $HOME/$profile
}

function install_pyenv {

	source $HOME/.bashrc

	pyenv_installed=$(which pyenv|wc -l)

	if [ "$pyenv_installed" == 0 ]
	then
		echo $pyenv_inst_msg

		check_os

		if [ "$ubuntu" == 1 ]
		then
			handle_ubuntu
		fi

		if [ "$centos" == 1 ] || [ "$redhat" == 1 ]
		then
			handle_redhat
		fi

		run_pyenv_installer
		set_pyenv_profile

	else
		echo $pyenv_installed_msg
		pyenv --version
		sleep 1
	fi

	echo
}

function install_python {
	echo -n "Which version of Python will this project use? (example: 2.7.6) "
	read python_version

	versions_installed=$(pyenv versions)
	python_installed=$(echo $versions_installed | grep $python_version | wc -l)

	if [ "$python_installed" == 0 ]
	then
		echo "This version has not been installed."
		echo "Python version ${python_version} will be installed."
		pyenv install $python_version
	else
		echo "Python version ${python_version} is already installed."
		echo "We will use ${python_version} for this project."
		sleep 1
	fi

	echo
}

function set_python_version {
	pyenv global $python_version
}

function get_db_settings {

	echo "Which database server do you plan to use with ${project_name}?"
	echo "Options are:"
	echo $db_options
	echo -n ": "
	read db_module

	echo "Installing module for ${db_module}"
	sleep 1
	pip install $db_module
	pip install django

	case $db_module in
		MySQL-python)
			db_type="    'ENGINE': 'django.db.backends.mysql',"
			;;
		psycopg2)
			db_type="    'ENGINE': 'django.db.backends.postgresql_psycopg2',"
			;;
		pysqlite)
			db_type="    'ENGINE': 'django.db.backends.sqlite3',"
			;;
		*)
			db_type="    'ENGINE': 'django.db.backends.sqlite3',"
			;;
	esac

	echo
	echo -n "Enter database name: "
	read db_name
	db_name="    'NAME': '$db_name',"

	echo
	echo -n "Enter database hostname: "
	read db_host 
	db_host="    'HOST': '$db_host',"

	echo
	echo -n "Enter database port: "
	read db_port
	db_port="    'PORT': '$db_port',"

	echo
	echo -n "Enter database username: "
	read db_user
	db_user="    'USER': '$db_user',"

	echo
	echo -n "Enter database password: "
	read db_pass
	db_pass="    'PASSWORD': '$db_pass',"

}

function create_project_dirs {
	for dir in "${project_dirs[@]}"
	do
		mkdir -p $dir
	done
}

function set_template_dirs {
	echo >> $project_name/settings.py
	echo "template_dirs=(" >> $project_name/settings.py
	echo "    os.path.join(BASE_DIR, 'templates')," >> $project_name/settings.py
	echo ")" >> $project_name/settings.py
	echo >> $project_name/settings.py
}

function set_staticfiles_dirs {
	echo "staticfiles_dirs=(" >> $project_name/settings.py
	echo "    os.path.join(BASE_DIR, 'static')," >> $project_name/settings.py
	echo ")" >> $project_name/settings.py
	echo >> $project_name/settings.py
}

function set_db_settings {
	echo "DATABASES = {" >> $project_name/settings.py
	echo "    'default':{" >> $project_name/settings.py
	echo "    $db_type" >> $project_name/settings.py
	echo "    $db_name" >> $project_name/settings.py
	echo "    $db_user" >> $project_name/settings.py
	echo "    $db_pass" >> $project_name/settings.py
	echo "    $db_host" >> $project_name/settings.py
	echo "    $db_port" >> $project_name/settings.py
	echo "    }" >> $project_name/settings.py
	echo "}" >> $project_name/settings.py
}

function create_project {
	project_name="myproject"
	echo -n "Enter the project name (myproject): "
	read project_name


	echo "Creating ${project_name} directory."
	mkdir $project_name
	sleep 1

	echo
	echo "Creating virtual environment for ${project_name}"
	pyenv virtualenv $project_name

	echo
	echo "Setting Python environment for ${project_name} directory"
	cd $project_name
	pyenv local $project_name

	get_db_settings

	echo
	echo "Creating project ${project_name} ..."
	django-admin.py startproject $project_name

	cd $project_name
	create_project_dirs

	pip freeze > requirements.txt
	set_template_dirs
	set_staticfiles_dirs
	set_db_settings

	echo
}

function get_end_msg {
	echo
	echo "$project_name has now been created and is ready for use."
	echo "You can change to the project directory and run to sync " 
	echo "the Django core and auth models by running:"
	echo
	echo "# ./manage.py makemigrations"
	echo "# ./manage.py migrate"
	echo
	echo "To start the development server you can run:"
	echo "# ./manage.py runserver"
	echo 
}
