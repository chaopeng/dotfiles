set -xg PATH $HOME/bin $HOME/go/bin $HOME/.cargo/bin $PATH

if [ $IS_MAC = 1 ]
  set -xg PATH /opt/local/bin /opt/local/sbin $PATH
end