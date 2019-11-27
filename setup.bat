powershell -command "iwr -useb get.scoop.sh | iex"
call scoop update
call scoop install coreutils git which sudo openssh neovim duplicacy watchexec
call scoop bucket add extras
call scoop install googlechrome firefox alacritty deluge discord slack sumatrapdf portable-virtualbox vlc plex-player windirstat steam

REM TODO: install dropbox, keybase, doxie, codec packs like k-lite, and other game platforms
