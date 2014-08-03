From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: fuzz testing an ext4fs file system under a 32 bit Linux user mode
 linux guest let task jbd2/ubda hang
Date: Sun, 03 Aug 2014 15:52:18 +0200
Message-ID: <53DE3E92.3060304@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: UML devel <user-mode-linux-devel@lists.sourceforge.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51529 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbaHCNwb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Aug 2014 09:52:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

fuzzying a 32 bit stable Gentoo x86 linux with trinity (and without excluding the munmap syscall but it might be independed from this) gives within a 32 bit user mode linux guest :


Aug  3 15:31:19 trinity su[1475]: Successful su for root by root
Aug  3 15:31:19 trinity su[1475]: + ??? root:root
Aug  3 15:31:19 trinity su[1475]: pam_unix(su:session): session opened for user root by (uid=0)
Aug  3 15:31:19 trinity su[1475]: pam_unix(su:session): session closed for user root
Aug  3 15:31:23 trinity kernel: VFS: Warning: trinity-c1 using old stat() call. Recompile your binary.
Aug  3 15:31:23 trinity kernel: VFS: Warning: trinity-c1 using old stat() call. Recompile your binary.
Aug  3 15:31:23 trinity kernel: VFS: Warning: trinity-c1 using old stat() call. Recompile your binary.
Aug  3 15:31:23 trinity kernel: trinity-c1 (1687) uses deprecated remap_file_pages() syscall. See Documentation/vm/remap_file_pages.txt.
Aug  3 15:31:23 trinity kernel: VFS: Warning: trinity-c0 using old stat() call. Recompile your binary.
Aug  3 15:31:23 trinity kernel: warning: process `trinity-c0' used the deprecated sysctl system call with 
Aug  3 15:31:23 trinity kernel: VFS: Warning: trinity-c1 using old stat() call. Recompile your binary.
Aug  3 15:37:50 trinity kernel: INFO: task jbd2/ubda-8:397 blocked for more than 120 seconds.
Aug  3 15:37:50 trinity kernel: Not tainted 3.16.0-rc7-00111-g3f9c08f #92
Aug  3 15:37:50 trinity kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  3 15:37:50 trinity kernel: jbd2/ubda-8     D 400011d2     0   397      2 0x00000000
Aug  3 15:37:50 trinity kernel: Stack:
Aug  3 15:37:50 trinity kernel: 086c8b7c 00000001 00000000 8486fd88 08060864 851e9f3c 086c8b7c 851e9a00
Aug  3 15:37:50 trinity kernel: 851e9a00 8486fdb0 084e7d14 851e9a00 086c8640 00000001 00000010 00001000
Aug  3 15:37:50 trinity kernel: 8486fe28 8486fe20 ffffffff 8486fdc4 084e7e05 080729be 00000000 8486fde0
Aug  3 15:37:50 trinity kernel: Call Trace:
Aug  3 15:37:50 trinity kernel: [<08060864>] __switch_to+0x44/0x70
Aug  3 15:37:50 trinity kernel: [<084e7d14>] __schedule+0x2c4/0x360
Aug  3 15:37:50 trinity kernel: [<084e7e05>] schedule+0x55/0x60
Aug  3 15:37:50 trinity kernel: [<080729be>] ? set_signals+0x1e/0x40
Aug  3 15:37:50 trinity kernel: [<084e8106>] io_schedule+0x46/0x60
Aug  3 15:37:50 trinity kernel: [<0812f628>] sleep_on_buffer+0x8/0x10
Aug  3 15:37:50 trinity kernel: [<084e81cc>] __wait_on_bit+0x3c/0x70
Aug  3 15:37:50 trinity kernel: [<084e82f9>] out_of_line_wait_on_bit+0x69/0x80
Aug  3 15:37:50 trinity kernel: [<0812f620>] ? sleep_on_buffer+0x0/0x10
Aug  3 15:37:50 trinity kernel: [<080a4b60>] ? wake_bit_function+0x0/0x50
Aug  3 15:37:50 trinity kernel: [<08130290>] __wait_on_buffer+0x30/0x40
Aug  3 15:37:50 trinity kernel: [<0812f620>] ? sleep_on_buffer+0x0/0x10
Aug  3 15:37:50 trinity kernel: [<081c841a>] jbd2_journal_commit_transaction+0xe1a/0x1390
Aug  3 15:37:50 trinity kernel: [<080729be>] ? set_signals+0x1e/0x40
Aug  3 15:37:50 trinity kernel: [<081cbc8f>] kjournald2+0xaf/0x1f0
Aug  3 15:37:50 trinity kernel: [<081cbc8f>] ? kjournald2+0xaf/0x1f0
Aug  3 15:37:50 trinity kernel: [<080729be>] ? set_signals+0x1e/0x40
Aug  3 15:37:50 trinity kernel: [<080a4b10>] ? autoremove_wake_function+0x0/0x50
Aug  3 15:37:50 trinity kernel: [<081cbbe0>] ? kjournald2+0x0/0x1f0
Aug  3 15:37:50 trinity kernel: [<08096806>] kthread+0xd6/0xe0
Aug  3 15:37:50 trinity kernel: [<0809dd7d>] ? finish_task_switch.isra.56+0x1d/0x70
Aug  3 15:37:50 trinity kernel: [<0806064b>] new_thread_handler+0x6b/0x90
Aug  3 15:37:50 trinity kernel: 
Aug  3 15:39:50 trinity kernel: INFO: task jbd2/ubda-8:397 blocked for more than 120 seconds.



The trinity fuzzer now seems to be in an endless loop, the corresponding process at the host side gives always :


Thread 1 (process 21625):
#0  0xb7726aec in __kernel_vsyscall ()
#1  0x08496f6f in __nanosleep_nocancel () at ../sysdeps/unix/syscall-template.S:81
#2  0x08073124 in idle_sleep (nsecs=606859328233668608) at arch/um/os-Linux/time.c:183
#3  0x08060b3f in arch_cpu_idle () at arch/um/kernel/process.c:208
#4  0x080a5405 in cpuidle_idle_call () at kernel/sched/idle.c:120
#5  cpu_idle_loop () at kernel/sched/idle.c:224
#6  cpu_startup_entry (state=CPUHP_ONLINE) at kernel/sched/idle.c:272
#7  0x084e1692 in rest_init () at init/main.c:419
#8  0x0804892e in start_kernel () at init/main.c:679
#9  0x08049fc9 in start_kernel_proc (unused=0x0) at arch/um/kernel/skas/process.c:46
#10 0x0806064b in new_thread_handler () at arch/um/kernel/process.c:129
#11 0x00000000 in ?? ()


It might be that [1] has few more info/data, or ?
The diff to [1] is just that I'm still able to login into the UML guest.



[1] http://sourceforge.net/p/user-mode-linux/mailman/message/32673925/

-- 
Toralf

