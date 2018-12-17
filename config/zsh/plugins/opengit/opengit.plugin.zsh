function _opengit() {
    git status>/dev/null 2>&1
    if [ $? != 0 ];then
        return
    fi
    count=${#words}
    case $count in
        2)
            _values print `git remote`
            ;;
        3)
            # -> 过滤: remotes/origin/HEAD -> origin/master
            _values print `git branch -a|grep -v '\->'|grep "remotes/${words[2]}/"|sed -n "s/remotes\/${words[2]}\///p"`
            ;;
    esac
}

compdef _opengit opengit
