# My ToolBox on Mac/Linux

## 1. How to Init

MAC

```bash
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew install git curl wget golang zsh

# install oh-my-zsh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 

$ cd ~ && git clone https://github.com/baotingfang/swiss-army-knife.git toolbox
$ cd ~/toolbox && ./install-my-tools
```

Ubuntu

```bash
$ sudo apt update && apt install -y git curl wget golang zsh

# install oh-my-zsh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 

$ cd ~ && git clone https://github.com/baotingfang/swiss-army-knife.git toolbox 
$ cd ~/toolbox && ./install-my-tools
```

## 2. How to compile & init gpdb

gpdb5/6

```bash
$ cd ~/workspace
$ git clone git@github.com:greenplum-db/gpdb.git
$ cd ~/workspace/gpdb/

$ gpdb-full-compile
$ gpdb-reinit
```

gpdb4

```bash
$ cd ~/workspace
$ git clone git@github.com:greenplum-db/gpdb4.git
$ cd ~/workspace/gpdb4/

$ gpdb-full-compile 4
$ gpdb-reinit
```

## 3. How to switch gpdb5/6 environment

```bash
$ g6
$ gpstart -a
$ gpstop -a
$ psql
```

## 4. How to switch gpdb4 environment

```bash
$ g4
$ gpstart -a
$ gpstop -a
$ psql
```

## 5. How to debug gpdb

```bash
$ gdb-gpdb

Master 进程信息

6315 5432 /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1
    6493 running postgres:  5432, baotingfang baotingfang 127.0.0.1(49923) con6 idle

Segment 进程信息

6302 40000 /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0

请选择进程号:6493
(lldb) process attach --pid 6493
Process 6493 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = signal SIGSTOP
    frame #0: 0x00007fff79a143e6 libsystem_kernel.dylib`__recvfrom + 10
libsystem_kernel.dylib`__recvfrom:
->  0x7fff79a143e6 <+10>: jae    0x7fff79a143f0            ; <+20>
    0x7fff79a143e8 <+12>: movq   %rax, %rdi
    0x7fff79a143eb <+15>: jmp    0x7fff79a11381            ; cerror
    0x7fff79a143f0 <+20>: retq
Target 0: (postgres) stopped.

Executable module set to "/Users/baotingfang/opt/gpdb/bin/postgres".
Architecture set to: x86_64h-apple-macosx.
(lldb)
```

## 6. How to watch gpdb processes

```bash
$ pps
Master

6315 5432 /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1
    6493 running postgres:  5432, baotingfang baotingfang 127.0.0.1(49923) con6 idle

Segment

6302 40000 /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0
```

Show connections

```bash
$ gpdb-ps -c

Master 进程信息

26732 5432 /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1
网络连接信息:
    句柄号:5       AF_INET    TCP   本地地址: 0.0.0.0:5432        远程地址:                     状态:LISTEN


    26983 running postgres:  5432, baotingfang baotingfang 127.0.0.1(50167) con15 idle
        网络连接信息:
            句柄号:12      AF_INET    TCP   本地地址: 127.0.0.1:5432      远程地址: 127.0.0.1:50167     状态:ESTABLISHED



Segment 进程信息

26720 40000 /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0
网络连接信息:
    句柄号:5       AF_INET    TCP   本地地址: 0.0.0.0:40000       远程地址:                     状态:LISTEN
```

Show fds (Only support MacOS)

```bash
gpdb-ps -f
Master 进程信息

26732 5432 /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1
已打开的文件:


    26983 running postgres:  5432, baotingfang baotingfang 127.0.0.1(50167) con15 cmd6 idle
        已打开的文件:
            句柄号:13    REG     /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1/base/16384/12448
            句柄号:14    REG     /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1/base/16384/12439
            句柄号:16    REG     /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1/base/16384/12437_fsm
            句柄号:17    REG     /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1/base/16384/12448_fsm
            句柄号:18    REG     /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1/base/16384/12439_fsm
            句柄号:19    REG     /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1/pg_xlog/000000010000000000000001
            句柄号:20    REG     /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1/base/16384/10011
            句柄号:22    REG     /Users/baotingfang/opt/data/gpdb/gpmaster/gpsne-1/base/16384/12441



Segment 进程信息

26720 40000 /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0
已打开的文件:


    27172 running postgres: 40000, baotingfang baotingfang 127.0.0.1(50170) con15 seg0 idle
        已打开的文件:
            句柄号:6     REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/10015
            句柄号:8     REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/12448
            句柄号:9     REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/10011
            句柄号:13    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/12439
            句柄号:14    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/10029
            句柄号:15    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/10035
            句柄号:16    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/10041
            句柄号:20    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/pg_xlog/000000010000000000000001
            句柄号:21    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/12437
            句柄号:22    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/12437_fsm
            句柄号:23    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/12448_fsm
            句柄号:24    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/12439_fsm
            句柄号:26    REG     /Users/baotingfang/opt/data/gpdb/gpdata/gpsne0/base/16384/12441


    27173 running postgres: 40000, baotingfang baotingfang 127.0.0.1(50171) con15 seg0 idle
        已打开的文件:
```

## 7. How to show a plan tree

```bash
(lldb) pp -f plain obj
(lldb) pp -f json obj
(lldb) pp -f good_json obj
(lldb) pp -f png obj
```

## 8. Other gpdb tool

```bash
gpdb                      gpdb-full-compile         gpdb-mpp-compile
gpdb-clean                gpdb-gen-tpch-data        gpdb-orca-compile
gpdb-clean-demo-cluster   gpdb-gp-xerces-compile    gpdb-orca-taglist
gpdb-cmakelists           gpdb-gpos-compile         gpdb-ps
gpdb-complie              gpdb-init                 gpdb-qd-pid
gpdb-configure            gpdb-kernel-config-linux  gpdb-reinit
gpdb-dep-centos           gpdb-kernel-config-mac    gpdb-segment0-master-pid
gpdb-dep-mac              gpdb-krb-keytab-sync      gpdb-source
gpdb-dep-rhel             gpdb-krb-login            gpdb-source-demo-cluster
gpdb-dep-ubuntu           gpdb-krb-logout           gpdb-stub
gpdb-docs-share           gpdb-log                  gpdb-switch
gpdb-env-clear            gpdb-make-demo-cluster    gpdb-test
gpdb-env-set              gpdb-master-pid           gpdb4
```