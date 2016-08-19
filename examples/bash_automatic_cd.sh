# Compatible with ranger 1.4.2 through 1.7.*
#
# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

function cd-from-ranger()
{
    ranger_pid=$(cat /tmp/ranger.pid)
    echo "get %d" > "/tmp/ranger-ipc.in.${ranger_pid}"
    cd -- "$(cat /tmp/ranger-ipc.out.${ranger_pid})"
}

function cd-to-ranger()
{
    echo "cd $PWD" > "/tmp/ranger-ipc.in.${ranger_pid}"
}

# This binds Ctrl-O to ranger-cd:
bind '"\C-o":"ranger-cd\C-m"'
