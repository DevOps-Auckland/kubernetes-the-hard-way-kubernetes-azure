# azure-training

This repo has been setup to practice Azure concepts using Infrastructure as Code (IaC). You can do it any way you want and practice your git-fu at the same time.

The main branch is currently being used for [kubernetes the hard way](https://github.com/kelseyhightower/kubernetes-the-hard-way). I am deploying it using Terraform.

## Setting up a DEV Environment

### WSL

If you are using a Windows machine, I suggest you use the Windows Subsystem for Linux (WSL). Instructions are here on how to install it: [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

### ZSH

Bash is the default Terminal that you see when you use WSL or Ubuntu. It is very basic and there are much better terminals out there that can do more powerful things.

Begin by installing zsh:

```bash
sudo apt install zsh -y
```

After install zsh, run the script to install oh-my-zsh: https://ohmyz.sh/
This will make the CLI interface look nicer. You can also add plugins to help with developing in the CLI.

### VSCode

Visual studio code can connect to your WSL. Install it, and the Terraform linting modules to make development easier.
