
# The Zsh Startup Files

Like most shells, zsh processes a number of system and user startup files. It is very important to understand the order in which each file is read, and what conditions cause various files to be ignored. Otherwise, you may be entering commands and configurations into your startup files that aren't getting seen or executed by zsh.

## The Startup Process

When zsh starts up, the following files are read (in order):

- First, read /etc/zshenv, followed by ~/.zshenv.
  - If the RCS option is unset in this system file, all other startup files are skipped. (Can you say 'B O F H' ?)
- IF is a login shell, read /etc/zprofile , followed by ~/.zprofile.
- IF is interactive, read /etc/zshrc , followed by ~/.zshrc.
- IF is a login shell, read /etc/zlogin , followed by ~/.zlogin.

Zsh looks for user startup files in the user's home directory by default.
To look in another directory, set the parameter ZDOTDIR to where you'd like zsh to look.

## Logging Out
When a user logs out,
- First /etc/zlogout is read, followed by ZDOTDIR/.zlogout.
