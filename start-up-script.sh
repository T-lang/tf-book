#!/bin/bash
set -e
echo 'Initialising....'
echo 'Starting Script....'

update(){
    echo 'Updating ....'
    sudo apt update
}

install_python_pip(){
    echo 'Installing python, pip....'
    sudo apt install python3 python3-dev python3-venv
    sudo apt-get install python3-pip
}

install_git(){
    echo 'Installing git....'
    sudo apt install git
    echo 'Enter your Github repo url Example https://github.com/user/project'
    read giturl
    echo 'Cloning git repo....'
    git clone $giturl
    echo 'Enter your project name'
    read projectname
    ls
    cd ~/"$projectname"
}

install_virtualenv_flask(){
    echo '############################### Starting install_virtualenv_flask ###############################'
    echo 'Setting up flask and virtual enviroment....'
    python3 -m venv env
    ls
    source env/bin/activate
    echo 'Installing items in requirements.txt file....'
    set +e
    pip3 install -r requirements.txt
    set -e
    pip3 install "Flask==1.1.2"
    pip3 install "Flask-migrate==2.7.0"
    pip3 install flask-script
    sudo apt-get install gunicorn3

}

setupDatabase(){
    echo '############################### Starting setupDatabase ###############################'
    echo 'Setting up Database Connection.....'
    echo 'Enter your username'
    read username
    echo 'Enter the password for ${username}'
    read pass
    echo 'Enter your database ip address'
    read ip
    echo 'Enter your database name'
    read db
    export APP_SETTINGS="config.DevelopmentConfig"
    echo "DATABASE_URL="postgresql://${username}:${pass}@${ip}:5432/${db}""
    export DATABASE_URL="postgresql://${username}:${pass}@${ip}:5432/${db}"
}

startApp(){
    gunicorn3 --bind 0.0.0.0:8080 manage:app --daemon
    #tes
    ##python3 manage.py runserver
}

main(){
    update
    #install_git
    install_python_pip
    install_virtualenv_flask
    setupDatabase
    startApp
}

main