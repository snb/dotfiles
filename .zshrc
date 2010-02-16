# Environmental variables:
source /etc/profile
BLOCKSIZE=K; export BLOCKSIZE
EDITOR=vim; export EDITOR
PAGER=less; export PAGER
#LS_COLORS='no=00:fi=00:di=01;35:ln=01;33:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.dmg=01;31:*.sit=01;31:*.jpg=01;36:*.jpeg=01;36:*.png=01;36:*.gif=01;36:*.bmp=01;36:*.ppm=01;36:*.tga=01;36:*.xbm=01;36:*.xpm=01;36:*.tif=01;36:*.tiff=01;36:*.mpg=00;37:*.mov=00;37:*.mp4=00;37:*.mp3=00;37:*.wav=00;37:*.aiff=00;37:*.avi=00;37:'; export LS_COLORS
LSCOLORS='gxfxcxdxbxegedabagacad'; export LSCOLORS
PGPPATH=$HOME/.gnupg; export PGPPATH
HISTFILE="$HOME/.zsh_history"; export HISTFILE
SAVEHIST=1000; export SAVEHIST

# Get the name of the branch we are on. Returns if we aren't in a git directory
# or git isn't installed.
git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "(${ref#refs/heads/}) "
}

# Set colours using nice names instead of nasty escape sequences
autoload -U colors
colors

# Set prompts
setopt prompt_subst
PROMPT='%{$fg[cyan]%}%n@%m> %{$reset_color%}'; export PROMPT
RPROMPT='%{$fg_bold[yellow]%}$(git_prompt_info)%{$fg[magenta]%}%~ %{$fg[red]%}%T%{$reset_color%}'; export RPROMPT

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

# OS specific stuff
if [ `uname` = 'Darwin' ] ; then
    # Let's use a Swedish locale, but English for language
    export LC_ALL="sv_SE.UTF-8"
    export LANGUAGE="en_GB"

    # I want to keep my added TeX stuff in ~/Library/texmf, not default ~/texmf
    TEXMFHOME=$HOME/Library/texmf
    export TEXMFHOME

    # Python stuff installed with easy_install puts scripts here (see
    # .pydisutils.cfg)
    PATH=$PATH:$HOME/Library/Python/2.6/bin
    export PATH

    alias ls='ls -asFhG'
    alias l='ls -alsFhG'

elif [ `uname` = 'Linux' ] ; then
    # Swedish locale for dates, numbers, etc. but leave others as default.
    # Remember to dpkg-reconfigure locales on Debian if Swedish locale isn't set
    # up already.
    export LC_COLLATE="sv_SE.UTF-8"
    export LC_MEASUREMENT="sv_SE.UTF-8"
    export LC_MONETARY="sv_SE.UTF-8"
    export LC_NUMERIC="sv_SE.UTF-8"
    export LC_TIME="sv_SE.UTF-8"

    alias ls='ls -asFh --color'
    alias l='ls -alsFh --color'
elif [ `uname` = 'FreeBSD' ] ; then
    alias ls='ls -asFhG'
    alias l='ls -alsFhG'
    listsysctls () { set -A reply $(sysctl -AN ${1%.*}) }
    compctl -K listsysctls sysctl
fi

# Spotify Kerberos and AFS login
alias klogin="kinit -V snb@SPOTIFY.NET; aklog spotify.net -k SPOTIFY.NET"

# More aliases
alias dvips='dvips -Ppdf -G0'
alias vi='vim'

# ssh tunnel to freefall for sending mail from snb@freebsd.org in mutt
alias fftun='ssh -N -L 2025:127.0.0.1:25 freefall.freebsd.org'

# Foot-shooting prevention
set -o noclobber
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'

# Emacs style line editing
bindkey -e

# Set title bar of window
precmd () {print -Pn "\e]0;%n@%m\a"}

# Cool tab completion stuff
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

compctl -g "*.tar *.tgz *.tz *.tar.Z *.tar.bz2 *.tZ *.tar.gz *.tbz2" \
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
