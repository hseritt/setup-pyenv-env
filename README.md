# Set up Python environment for a directory with Pyenv

## How do I set up a Python environment with Pyenv?

### Versions

- Ubuntu 14.04
- Python 2.7.6 (default install with Ubuntu 14.04)

### Prerequisites

- Ubuntu 14.04 installed
- root access not required

### Steps

- Install build dependencies:

`# sudo apt-get install curl git-core gcc make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libssl-dev`

- Install Pyenv:

curl -L https://raw.github.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

- Add code to ~/.bashrc:

`export PATH="$HOME/.pyenv/bin:$PATH"`
`eval "$(pyenv init -)"`
`eval "$(pyenv virtualenv-init -)"

- Re-source your ~/.bashrc file:

`# source ~/.bashrc

- Install the version of Python to use. We'll use 2.7.9 which is the most up-to-date version at this time:

`# pyenv install 2.7.9`

- Use this version:

`# pyenv global 2.7.9`

- Create your directory:

`# pyenv virtualenv myproject`

`# pyenv mkdir myproject`

- Set the environment:

`# cd myproject`
`# pyenv local myproject`

### Commentary

Pyenv along with virtualenv allows you to better control your Python environment for a particular project. To begin with, you'll need to make sure all the proper dependent packages are in place. Next, you will install pyenv and add some initialization code to your user's .bashrc or .profile file. Afterwards, you simply install the Python version you want, create a Django project and set this Python environment for it.

### Links

- http://fgimian.github.io/blog/2014/04/20/better-python-version-and-environment-management-with-pyenv/
- https://github.com/yyuu/pyenv-installer
- http://davebehnke.com/python-pyenv-ubuntu.html

### Scripts

You can use 'django-setup.sh' to run the processes described above. The only difference is that it specifically sets up a Django project for you. It has been tested on these OS's:

- Ubuntu 14.04
- CentOS and RHEL 6
- CentOS and RHEL 7