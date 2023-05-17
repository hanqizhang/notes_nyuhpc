# this may help resolve issue with module command not found error
# when submitting gpu jobs from the no-gpu login node, though it is not suggested.
# you won't need this if submitting gpu job from the gpu login node (i.e., from pudong)
module ()
{ 
    if [ -z "${LMOD_SH_DBG_ON+x}" ]; then
        case "$-" in 
            *v*x*)
                __lmod_sh_dbg='vx'
            ;;
            *v*)
                __lmod_sh_dbg='v'
            ;;
            *x*)
                __lmod_sh_dbg='x'
            ;;
        esac;
    fi;
    if [ -n "${__lmod_sh_dbg:-}" ]; then
        set +$__lmod_sh_dbg;
        echo "Shell debugging temporarily silenced: export LMOD_SH_DBG_ON=1 for Lmod's output" 1>&2;
    fi;
    eval "$($LMOD_CMD $LMOD_SHELL_PRGM "$@")" && eval "$(${LMOD_SETTARG_CMD:-:} -s sh)";
    __lmod_my_status=$?;
    if [ -n "${__lmod_sh_dbg:-}" ]; then
        echo "Shell debugging restarted" 1>&2;
        set -$__lmod_sh_dbg;
    fi;
    unset __lmod_sh_dbg;
    return $__lmod_my_status
}
