
```bash
# 连接lldb库到当前使用的python解释器上

cd /Users/baotingfang/Library/Python/2.7/lib/python/site-packages
ln -s /Library/Developer/CommandLineTools/Library/PrivateFrameworks/LLDB.framework/Resources/Python/lldb lldb
ln -s /usr/local/opt/gdb/share/gdb/python/gdb gdb

# 选择使用/usr/local/bin/python2.7

```