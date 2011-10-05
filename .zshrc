## Functions ##
# Get the name of the branch we are on. Returns if we aren't in a git directory
# or git isn't installed. I stole this from someone, but don't remember where :(
git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "(${ref#refs/heads/}) "
}

# trash() and quick-look() taken from oh-my-zsh osx plugin by Sorin Ionescu
# <sorin.ionescu@gmail.com>
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/osx/osx.plugin.zsh
# Move items to trash
function trash() {
    local trash_dir="${HOME}/.Trash"
    local temp_ifs=$IFS
    IFS=$'\n'
    for item in "$@"; do
        if [[ -e "$item" ]]; then
            item_name="$(basename $item)"
            if [[ -e "${trash_dir}/${item_name}" ]]; then
                mv -f "$item" "${trash_dir}/${item_name} $(date "+%H-%M-%S")"
            else
                mv -f "$item" "${trash_dir}/"
            fi
        fi
    done
    IFS=$temp_ifs
}

function quick-look() {
    (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}


## Environmental variables ##
source /etc/profile
BLOCKSIZE=K; export BLOCKSIZE
EDITOR=vim; export EDITOR
PAGER=less; export PAGER
LSCOLORS='gxfxcxdxbxegedabagacad'; export LSCOLORS
PGPPATH=$HOME/.gnupg; export PGPPATH
HISTFILE="$HOME/.zsh_history"; export HISTFILE
SAVEHIST=100000; export SAVEHIST

# Amazon EC2
if [ -e $HOME/.ec2env ]; then
    source $HOME/.ec2env
fi

# Perforce environment stuff
if [ -e $HOME/.p4env ]; then
    source $HOME/.p4env
fi

# Go environmental variables
if [ -e $HOME/.goenv ]; then
    source $HOME/.goenv
fi

# If we have a $HOME/bin directory, add it to the path
if [ -d $HOME/bin ]; then
    export PATH=$PATH:$HOME/bin
fi


## Prompts ##
# Set colours using nice names instead of nasty escape sequences
autoload -U colors
colors
setopt prompt_subst
PROMPT='%{$fg[cyan]%}%n@%m> %{$reset_color%}'; export PROMPT
RPROMPT='%{$fg_bold[yellow]%}$(git_prompt_info)%{$fg[magenta]%}%~ %{$fg[red]%}%T%{$reset_color%}'; export RPROMPT


## Aliases ##
alias dvips='dvips -Ppdf -G0'
alias vi='vim'

# ssh tunnel to freefall for sending mail from snb@freebsd.org in mutt
alias fftun='ssh -N -L 2025:127.0.0.1:25 freefall.freebsd.org'

# Foot-shooting prevention
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'


## OS specific behaviour ##
if [ `uname` = 'Darwin' ] ; then
    # I want to keep my added TeX stuff in ~/Library/texmf, not default ~/texmf
    TEXMFHOME=$HOME/Library/texmf
    export TEXMFHOME

    # Python stuff installed with easy_install puts scripts here (see
    # .pydisutils.cfg)
    PATH=$PATH:$HOME/Library/Python/2.6/bin
    export PATH

    alias ls='ls -asFhG'
    alias l='ls -alsFhG'

    # Macports
    if [ -d /opt/local/bin ] ; then
        PATH=$PATH:/opt/local/bin
    fi

elif [ `uname` = 'Linux' ] ; then
    alias ls='ls -asFh --color'
    alias l='ls -alsFh --color'
elif [ `uname` = 'FreeBSD' ] ; then
    alias ls='ls -asFhG'
    alias l='ls -alsFhG'
    listsysctls () { set -A reply $(sysctl -AN ${1%.*}) }
    compctl -K listsysctls sysctl
fi


## Tab completion ##
# Most of these I got from someone else years ago, but I don't remember where
compctl -D -f + -H 0 '' -X '(No file found; using history)'
compctl -o setopt
compctl -v echo export
compctl -z -P '%' bg
compctl -j -P '%' fg jobs disown
compctl -j -P '%' + -s '`ps -x | tail +2 | cut -c1-5`' wait
compctl -A shift
compctl -c type whence where which whereis killall man apropos

# Kill takes signal names as the first argument after `-',
# but job names after % or PIDs as a last resort.
compctl -j -P '%' + -s '`ps -x | tail +2 | cut -c1-5`' + \
    -x 's[-] p[1]' -k "($signals[1,-3])" -- kill

# Only look at specific file types for certain commands
compctl -g "*.tif *.tiff *.GIF *.JPG *.gif *.jpg *.bmp *.xpm *.xbm\
    *.pcx *.pgm *.ppm *.pnm *.png *.eps *.pdf *.ps" + -g "*(-/) .*(-/)"\
    xv convert mogrify

compctl -g "*.pdf *.PDF" + -g "*(-/) .*(-/)" acroread xpdf gv ggv

compctl -g "*.ps *.PS *.pdf *.PDF *.eps" + -g "*(-/) .*(-/)"\
    ghostview gs gv ggv

compctl -g "*.c" + -g "*(-/) .*(-/)" gcc cc

compctl -g "*.gz" + -g "*(-/) .*(-/)" gunzip

compctl -g "*.bz2" + -g "*(-/) .*(-/)" bunzip2

compctl -g "*.zip *.jar *.war" + -g "*(-/) .*(-/)" unzip

compctl -g "*.Z" + -g "*(-/) .*(-/)" uncompress

compctl -g "*.tar *.tgz *.tz *.tar.Z *.tar.bz2 *.tZ *.tar.gz *.tbz2 *.tbz" \
    + -g "*(-/) .*(-/)" tar

compctl -g "*.tex" + -g "*(-/) .*(-/)"\
    tex latex pdftex pdflatex bibtex latex2html

compctl -g "*.dvi" + -g "*(-/) .*(-/)" xdvi dvips dvipdf

compctl -g "*.mp3 *.MP3" + -g "*(-/) .*(-/)" mpg123 xmms

# Look for html files, then directories, then history
compctl -g "*.html *.htm" + -g "*(-/) .*(-/)" + -H 0 ''\
    wget lynx links

# Search the history file for these
compctl -H 0 '' -k hosts telnet ftp ssh host

# Ensures that cd <tab> cycles through directories (including "hidden"
# .directories) only. Likewise rmdir.
compctl -g "*(-/) .*(-/)" cd rmdir


## Miscellaneous ##
# Emacs style line editing
bindkey -e

# > redirection won't truncate files
set -o noclobber

# Set title bar of window
precmd () {print -Pn "\e]0;%n@%m\a"}
