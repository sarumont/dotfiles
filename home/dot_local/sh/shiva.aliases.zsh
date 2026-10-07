# beets runs on the music-tools VM
beet() { ssh -t music-tools beet "${(q)@}"; }
