# dot box

# ¯\\_(ツ)_/¯ Warning / Liability
> Warning:
The creator of this repo is not responsible if your machine ends up in a state you are not happy with.
If you are concerned, look at the code to review everything this will do to your machine :)


repo goals:

- greatly improve and consolidate the following repos into a single pluggable toolbox
  * https://github.com/russelltsherman/.box
  * https://github.com/russelltsherman/.proj
  * https://github.com/russelltsherman/.pitap2
  * https://github.com/russelltsherman/.pibox
  * https://github.com/russelltsherman/.droid


- provide a scaffolding where commands can be added or removed by simply cloning/removing a git repo from ./plugins/
- provide advanced autocompletion including specific command arguments


## installing .box


clone the repo
```
$ git clone https://github.com/russelltsherman/.box $HOME/.box
```

execute the installer
```
$ $HOME/.box/install.sh
```


# Loathing, Mehs and Praise
1. Loathing should be directed into pull requests that make it better. woot.
2. Bugs with the setup should be put as GitHub issues.
3. Mehs should be > /dev/null
4. Praise should be directed to ![@BurnerDev](https://img.shields.io/twitter/follow/BurnerDev.svg?style=social&label=@BurnerDev)


## known issues
- if no valid subcommands exist in a directory autocomplete returns an error _values:compvalues:10: not enough arguments
