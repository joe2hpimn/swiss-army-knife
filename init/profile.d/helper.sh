#!/usr/bin/env bash

lldb-helper(){
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

gdb-helper(){
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

gcc-helper(){
	echo "

	"

	echo ""
}

tmux-helper(){
	echo "
tmux 会话快捷操作

	CTRL+PREFIX_KEY ? 显示帮助文档
	CTRL+PREFIX_KEY : 进入tmux的命令模式,可以使用join-pane等各种命令
	CTRL+PREFIX_KEY d detach当前session, 后台运行
	CTRL+PREFIX_KEY D 在多个session之间,选择要detach的session, 使用ctrl+p,n上下切换, 回车确定
	CTRL+PREFIX_KEY s 多个session之间切换, 可以使用ctrl+p,n上下切换, 按回车确定
	CTRL+PREFIX_KEY [ 进入复制模式
	CTRL+PREFIX_KEY ] 粘贴文本
	CTRL+PREFIX_KEY ~ 列出提示信息缓存

window 窗口相关快捷操作

	CTRL+PREFIX_KEY c 创建新的window
	CTRL+PREFIX_KEY n 切换到下一个window
	CTRL+PREFIX_KEY p 切换到上一个window
	CTRL+PREFIX_KEY & 关闭当前window, 需要输入y/n确认
	CTRL+PREFIX_KEY w 显示window列表,会显示每个window的序号,用于切换
	CTRL+PREFIX_KEY 0~9  切换到指定window
	CTRL+PREFIX_KEY n 切换到下一个window
	CTRL+PREFIX_KEY p 切换到上一个window
	CTRL+PREFIX_KEY . 重命名当前window
	CTRL+PREFIX_KEY f 快速定位定位到window(需要输入window名称的关键字)

pane 窗格相关快捷操作

	CTRL+PREFIX_KEY - 上下分pane
	CTRL+PREFIX_KEY | 左右分pane
	CTRL+PREFIX_KEY x 关闭当前的pane,需要输入y/n确认
	CTRL+PREFIX_KEY z 最大化/最小化, 切换当前pane
	CTRL+PREFIX_KEY ! 将当前pane在新的window中打开
	CTRL+PREFIX_KEY ; 切换到上次使用的pane
	CTRL+PREFIX_KEY q 显示pane的编号,在编号消失之前,按对应的数字可以进行pane切换
	CTRL+PREFIX_KEY { 选择上一个pane
	CTRL+PREFIX_KEY { 选择下一个pane
	CTRL+PREFIX_KEY o 在当前window中顺时针选择panel
	CTRL+PREFIX_KEY 方向键 在当前window中,按方向选择panel
	CTRL+PREFIX_KEY 空格键 使用自带的pane布局进行切换
	CTRL+PREFIX_KEY ALT+方向键 以5个单元格为单位,调整当前pane的面板边缘(鼠标也可以控制)
	CTRL+PREFIX_KEY CTRL+方向键 以1个单元格为单位,调整当前pane的面板边缘(鼠标也可以控制)


滚屏操作

	如果启用了vi模式, 首先进入copy-mode: PREFIX + [

	之后就可以使用vim的操作进行滚屏操

    	H 当前屏幕顶端
    	M 当前屏幕中间
    	L 当前屏幕底部
    	CTRL + b 前一页
    	CTRL + f 后一页

折叠操作

	zo 打开当前折叠
	zO 打开所在范围内所有嵌套的折叠
	zc 关闭当前折叠
	zC 关闭所在范围内所有嵌套的折叠
	zR 打开所有折叠
	zM 关闭所有折叠
	zd 删除折叠
	zD 删除所有折叠

常用tmux命令

	tmux                        新建匿名session
	tmux new -s session_name    创建新的session
	tmux new -s session_name -d 后台创建新的session
	tmux ls                     显示当前的会话列表
	tmux list-sessions          显示当前的会话列表
	tmux attach -t session_name|session_number  恢复会话使用
	tmux detach                 断开当前会话, 在后台运行(需要在tmux环境中执行)
	tmux kill-session -t session_name 关闭会话
	tmux kill-server            关闭tmux服务器, 相当于关闭所有session
	tmux list-buffers           显示所有buffer
	tmux show-buffer -b buffer_name   限制指定的buffer内容
	tmux choose-bufffer         进入buffer选择页面,选择buffer,支持hjkl, 回车进行选择
	tmux set-buffer             设置buffer内容
	tmux load-buffer -b buffer_name file_path   从文件加载文本到buffer
	tmux save-buffer -a -b buffer_name file_path  保存buffer到本地文件
	tmux paste-buffer           粘贴buffer内容到会话
	tmux delete-buffer -b buffer_name   删除指定名称的buffer

其他

	join-pane

	  join-pane -s [session_name]:[window].[pane]

	  例如: join-pane -s 2:1.1
	  即合并第二个会话的第一个窗口的第一个面板到当前窗口
"
}