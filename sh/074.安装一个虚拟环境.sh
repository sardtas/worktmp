安装虚拟环境

$ sudo pip install virtualenv virtualenvwrapper
$ sudo rm -rf ~/get-pip.py ~/.cache/pip

更新我们的  ~/.bashrc  file.

（3） 配置virtualenv and virtualenvwrapper
$export WORKON_HOME=$HOME/.virtualenvs
$export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
$source /usr/local/bin/virtualenvwrapper.sh
 


$ echo -e "\n# virtualenv and virtualenvwrapper" >> ~/.bashrc
$ echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.bashrc
$ echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
$ echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc

接下来, source the ~/.bashrc  file:
$ source ~/.bashrc

（4）创建一个 Python 3 virtual environment ，并命名为cv
$ mkvirtualenv cv -p python3

进去虚拟环境

$ workon cv











