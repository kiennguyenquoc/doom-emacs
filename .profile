export GOROOT=/usr/local/opt/go/libexec

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin:$GOBIN
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

[[ -s "/Users/macbook_autonomous/.gvm/scripts/gvm" ]] && source "/Users/macbook_autonomous/.gvm/scripts/gvm"

export GO111MODULE=on
