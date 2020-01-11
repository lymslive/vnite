# Vnite: another easily extend Unite by pury VimL

## Introduce to Worklow

Capture output of a vim command(internal or external), show in special
filterable buffer, and do something defined action when press `<CR>` or other
short cute.

Inspiration comes from 
[Unite](https://github.com/Shougo/unite.vim)/
[denite](https://github.com/Shougo/denite.nvim) and 
[Leaderf](https://github.com/Yggdroot/LeaderF)

Main point:

* Implemented by pure viml, no dependency other than vim, better newer than
  vim8.
* Easily extend to any internal/custom command, provided the command output to
  message by `echo`, or external command output to stdout, which also make
  sense to execute without vnite.
* Especially handy to view many intermal command that output more than one
  screen of message.
* Propose a new mode called `filter mode`, some like increament search on ex
  mode, but filter the buffer line, only show that matched. Event map also
  available in filter mode by command `Fnoremap`.

Drawback:

* Not so beautiful appearance as LeaderF

## Install

Just use you favorite plugin manage tool. And if you perfer to manually
install, also easy to `git clone` down to `~/.vim/pack/opt/lymslive`, then in
vim:

```
packaddd! vnite
```

Or you can only copy the subdir `autoload/vnite` to `~/.vim/autoload/vnite`
then in vim:

```
call vnite#plugin#load()
```

That is all, with full functionality except documentation.

## Usage

Try prefix any command with `CM `, or `CM -- ` if the command come with
complex arguments of its own.

```
:CM ls
:CM message
:CM CustomeCommand
:CM -- CustomeCommand -option1 -option2
```

A mapping of `<C-CR>` is difined when in cmdline to help quickly prefix `CM`
before real `<CR>` fired.

When shows the output message buffer, press `/` to enter `filter mode`. It
will only begin to filter if input at least 3 characters. Press `<Esc>` or
`<C-C>` to exit filter mode, back to normal mode in message buffer.

Move cursor as normal with `jk`, or in filter mode `<C-N>` `<C-P>`, press
`<CR>` on an interesting line, then will trigger an action if difined.

To list all the supported command that have defined action, use one of the
following:

```
:Vnite
:CM Vnite
```

If used with the `CM` prefix version, the commands are aslo list in message
buffer, may select and press `<CR>` to execute it, especailly fit if the
command required no argument.

## Extension

See example in `autoload/vnite/command/oldfiles`. The simplest case is just
define a function `vnite#command#CommandName#CR()`, it will called by vnite
when press `<CR>` on message buffer line, with a object argument where has a
key named `text` to store the current line text, say `a:message.text`. It is
term of user to parset the text, extract useful information.

But much more custom can be handled.

## Config

Copy the file `autoload/vnite/config.vim` to `~/.vim/autoload/vnite/config.vim`,
modify the value of global viriables and the bound map, the comment may
helpful.

## Todo

* asyncrun for external command `CM !external`
* predifined action for more usefull internal vim command
* bug fix
