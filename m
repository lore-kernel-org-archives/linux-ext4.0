From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Mon, 10 Aug 2009 20:11:16 GMT
Message-ID: <200908102011.n7AKBGaA032761@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40833 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZHJULP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2009 16:11:15 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7AKBGPN032762
	for <linux-ext4@vger.kernel.org>; Mon, 10 Aug 2009 20:11:16 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #21 from Rus <harbour@sfinx.od.ua>  2009-08-10 20:11:15 ---
1. Strace hangs in open(big_file).

.......................................................................
open("/usr/lib/locale/ru_UA/LC_MESSAGES/SYS_LC_MESSAGES", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=57, ...}) = 0
mmap2(NULL, 57, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb80cc000
close(3)                                = 0
open("/usr/lib/locale/ru_UA/LC_MONETARY", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=291, ...}) = 0
mmap2(NULL, 291, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb80cb000
close(3)                                = 0
open("/usr/lib/locale/ru_UA/LC_COLLATE", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=21143, ...}) = 0
mmap2(NULL, 21143, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb80c5000
close(3)                                = 0
open("/usr/lib/locale/ru_UA/LC_TIME", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2359, ...}) = 0
mmap2(NULL, 2359, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb80c4000
close(3)                                = 0
open("/usr/lib/locale/ru_UA/LC_NUMERIC", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=55, ...}) = 0
mmap2(NULL, 55, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb80c3000
close(3)                                = 0
open("/usr/lib/locale/ru_UA/LC_CTYPE", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=222300, ...}) = 0
mmap2(NULL, 222300, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7ee8000
close(3)                                = 0
open("/Arhiv/Soft/winz/ZverDVD2009.iso", O_RDONLY|O_LARGEFILE
...............................................................

2. /proc/sched_debug - do not have such file.

3. As I see only one field is incrementing in /proc/$STUCK_PID/stat :

cat /proc/3561/stat
3561 (dd) R 1 3560 3448 1036 3448 4194304 229 0 0 0 0 43525 0 0 20 0 1 0 14243
2289664 166 4294967295 134512640 134564808 0 0 0 0 0 0 0 4294967295 0 0 17 0 0
0 3494 0 0

cat /proc/3561/stat
3561 (dd) R 1 3560 3448 1036 3448 4194304 229 0 0 0 0 45054 0 0 20 0 1 0 14243
2289664 166 4294967295 134512640 134564808 0 0 0 0 0 0 0 4294967295 0 0 17 0 0
0 3494 0 0

4. taskset -c 0/1 is not influencing on hang.

5. sysrq-w already posted. sysrq-l :

...............................................................
SysRq : Show backtrace of all active CPUs
CPU0:
 f2d0dba0 ac4662f2 00000046 00000001 f2d0dbe8 f2d0dbc8 c01093ff 00000000
 c08762a0 ac4662f2 f2d0dbe0 c049c46c c08a6750 00000000 ac4662f2 c27e4b6c
 f2d0dc00 c018e7ab f2d0dbe8 f2d0dbe8 ac4662f2 edd7f800 00000000 00000001
Call Trace:
 [<c01093ff>] ? show_stack+0x2f/0x50
 [<c049c46c>] ? showacpu+0x7c/0x90
 [<c018e7ab>] ? generic_smp_call_function_single_interrupt+0x7b/0xc0
 [<c011d770>] ? smp_call_function_single_interrupt+0x30/0x60
 [<c01055aa>] ? call_function_single_interrupt+0x36/0x3c
 [<c01f3b62>] ? generic_file_aio_read+0xf2/0xb80
 [<c01789a7>] ? enqueue_hrtimer+0xa7/0xe0
 [<c02471dc>] ? do_sync_read+0xdc/0x150
 [<c03cd800>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0173f50>] ? autoremove_wake_function+0x0/0x70
 [<c024737f>] ? rw_verify_area+0x12f/0x1e0
 [<c02477fa>] ? vfs_read+0x16a/0x250
 [<c0247100>] ? do_sync_read+0x0/0x150
 [<c0251286>] ? kernel_read+0x46/0x70
 [<c0388b74>] ? ima_calc_hash+0x1f4/0x260
 [<c0388c67>] ? ima_collect_measurement+0x87/0xc0
 [<c03881a6>] ? ima_path_check+0x2a6/0x370
 [<c0256263>] ? may_open+0xe3/0x440
 [<c025a43b>] ? path_walk+0x9b/0xc0
 [<c025bfde>] ? do_filp_open+0x2be/0xe70
 [<c026b5b9>] ? alloc_fd+0x49/0x1b0
 [<c0246575>] ? do_sys_open+0xd5/0x1a0
 [<c02466d9>] ? sys_open+0x39/0x60
 [<c0104ed8>] ? syscall_call+0x7/0xb
........................................................

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
