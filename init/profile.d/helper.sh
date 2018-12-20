#!/usr/bin/env bash

lldb-shortcut(){
	echo "
附加进程:

	lldb -p <PID>
	attch -p <PID>
	process attach --pid <PID>

设置环境变量:

	settings set target.env-vars DEBUG=1
	process launch -v DEBUG=1	启动进程时设置环境变量

运行:

	r, run, process launch

单步执行 (step-into)

	s, step, thread step-in	源码级别
	si, thread step-inst	指令级别

单步执行 (step-over)

	n, next, thread step-over	源码级别
	ni, thread step-inst-over	指令级别

跳出 (step-out)

	finish, thread step-out

继续执行

	c

设置断点

	b 函数名
	breakpoint set --name 函数名

	b test.c:12
	breakpoint set --file test.c --line 12

	breakpoint set --regex 正则表达式

查看所有断点

	br l
	breakpoint list

删除断点

	breakpoint delete 序号

设置watchpoint

	watchpoint set variable 变量名

	watchpoint set expression -- 指针地址			在指定内存地址上设置watchpoint

	watchpoint modify -c '(global == 5)'		条件watchpoint

查看所有watchpoint

	watch l
	watchpoint list

删除watchpoint

	watchpoint delete <序号>

查看变量

	frame variable						查看当前frame中所有变量
	frame variable --no-args			查看当前frame中的本地变量

	p 变量名, frame variable 变量名		查看本地变量
	frame variable --format x 变量名		以16进制查看本地变量

	target variable						查看当前源文件中定义的全局或static变量
	target variable 变量名				查看全局变量

	display argc						显示每次stop时的命令行参数个数
	display argv						显示每次stop时的命令行参数

设置变量

	set 变量名=变量值

评估表达式

	expr 表达式
	print 表达式

	po 变量名		更加友好的显示

调用函数

	p 函数名()

打印栈帧

	bt, thread backtrace	打印当前线程的栈帧
	bt all					打印所有线程的栈帧

	bt 5
	thread backtrace -c 5	打印当前线程的前5个栈帧

选择栈帧

	f 12
	frame select 12				选择序号为12的栈帧

	up
	frame select --relative=1	选择当前栈帧的上一个栈帧

	up 2
	frame select --relative=2	选择当前栈帧的前2个栈帧

	down
	frame select --relative=-1	选择当前栈帧的下一个栈帧


	down 3
	frame select --relative=-3	选择当前栈帧的之后的第3个栈帧

	frame info
	"


	echo "detail: http://wiki.home:8888/0018.C/97.%E5%B7%A5%E5%85%B7%E5%A5%97%E4%BB%B6/04.lldb/02.gdb%E5%92%8Clldb%E5%91%BD%E4%BB%A4%E6%AF%94%E8%BE%83"
}

gdb-shortcut(){
	echo "
附加进程:

	gdb -p <PID>
	attach <PID>

设置环境变量:

	set env DEBUG 1

运行:

	r, run

单步执行 (step-into)

	s, step		源码级别
	si			指令级别

单步执行 (step-over)

	n, next		源码级别
	ni			指令级别

跳出 (step-out)

	finish

继续执行

	c

设置断点

	break 函数名
	break test.c:12
	rbreak 正则表达式

查看所有断点

	info break

删除断点

	delete <序号>

设置watchpoint

	watch 变量名

	watch -location (char*)obj		在指定内存地址上设置watchpoint

查看所有watchpoint

	info break

删除watchpoint

	delete <序号>

查看变量

	info args		查看当前frame中所有变量
	info locals		查看当前frame中本地变量

	p 变量名			查看本地变量
	p/x 变量名		以16进制查看变量名
	p 全局变量名		查看全局变量

	display argc	显示每次stop时的命令行参数个数
	display argv	显示每次stop时的命令行参数

设置变量

	call 变量名=变量值

评估表达式

	print 表达式
	call 表达式		不会看到void的返回值

	po 变量名		更加友好的显示

调用函数

	p 函数名()

打印栈帧

	bt						打印当前线程的栈帧
	thread apply all bt		打印所有线程的栈帧

	bt 5					打印当前线程的前5个栈帧

选择栈帧

	frame 12	选择序号为12的栈帧
	up			选择当前栈帧的上一个栈帧
	up 2		选择当前栈帧的前2个栈帧

	down		选择当前栈帧的下一个栈帧
	down 3		选择当前栈帧的之后的第3个栈帧
	"

	echo "detail: http://wiki.home:8888/0018.C/97.%E5%B7%A5%E5%85%B7%E5%A5%97%E4%BB%B6/04.lldb/02.gdb%E5%92%8Clldb%E5%91%BD%E4%BB%A4%E6%AF%94%E8%BE%83"
}

gcc-shortcut(){
	echo "

	"

	echo ""
}