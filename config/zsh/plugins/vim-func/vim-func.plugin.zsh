function _vim_func() {
    compadd -- `print -l ${(ok)functions}`
}

compdef _vim_func vim-func 
