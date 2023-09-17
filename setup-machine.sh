#!/bin/bash

# Error handling
set -e # Exit script immediately on first error.

echo -e "\e[31m✨ Script started! ✨\e[0m"

# Install core packages
install_core(){
    install_brew

    brew install git
    brew install python

    brew install minikube
    brew install k9s
    brew install kubectl
    brew install kubectx

    brew install go
    brew install go-task
}

install_brew(){
    
    if ! [command -v brew]; then
        echo "Brew could not be found. Installing brew..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            echo "Installing brew for linux..."
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
            test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
            test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
            test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
            echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo "Installing brew for mac..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "OS not supported"
            exit 1
    fi
    else
        echo "Brew is already installed. Updating brew..."
        brew cleanup --prune=all 
        brew update
        # break or return
        return 0
    fi
}

# Install optional packages
install_optional(){
    brew install tldr
    brew install gh
}

# Shortcuts for terminal
add_shortcuts(){
    echo alias k=kubectl >> ~/.zshrc 
    echo alias ctx=kubectx >> ~/.zshrc
    echo alias ns=kubens >> ~/.zshrc

    #Enable kubectl autocompletion
    echo 'autoload -Uz compinit' >> ~/.zshrc
    echo 'compinit' >> ~/.zshrc
    echo 'source <(kubectl completion zsh)' >>~/.zshrc

    echo alias python=/Library/Frameworks/Python.framework/Versions/3.9/bin/python3 >> ~/.zshrc
}

main(){
    install_core
    install_optional
    add_shortcuts
}

main

if [ $? -eq 0 ]; then
    echo -e "\e[32m✨ Script executed successfully! ✨\e[0m"
else
    echo -e "\e[31m❌ An error occurred! ❌\e[0m"
fi