From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13909] md5sum on 3GB file is constantly hanging
Date: Sat, 8 Aug 2009 20:38:40 GMT
Message-ID: <200908082038.n78Kce0O030997@demeter.kernel.org>
References: <bug-13909-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:45106 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZHHUik (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Aug 2009 16:38:40 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n78KceEG030998
	for <linux-ext4@vger.kernel.org>; Sat, 8 Aug 2009 20:38:40 GMT
In-Reply-To: <bug-13909-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13909





--- Comment #9 from Rus <harbour@sfinx.od.ua>  2009-08-08 20:38:38 ---
No, all the system do not hang. All VFS operations except this particular 3GB
file are normal. dd/md5sum process is in R+ state, accessing this 3GB file with
any othr program (xxd) put it in D+ state. For ex. first I've run dd on this
file, next xxd - ps output :


...............
3882 tty12    R+    51:45 dd if=ZverDVD2009.iso of=/dev/null
3929 tty11    D+     0:00 xxd /Arhiv/Soft/winz/ZverDVD2009.iso
.................

blocked process (xxd) output :

...................................................
SysRq : Show Blocked State
  task                PC stack   pid father
xxd           D 0000007b     0  3929   3429
 f4d8cdf0 00000046 0000007b 0000007b 000000d8 000000e0 ffffff10 f1a631e0
 c0b60080 c0b60080 c0b5c78c f1a631e0 c0b60080 000d1dcf f4d8cdf0 00000001
 0000007b f1a63020 f1a19180 f1aec000 c27e8080 f1ae77f0 f4d8cdf0 c0142c69
Call Trace:
 [<c0142c69>] ? mutex_spin_on_owner+0xe9/0x110
 [<c0742482>] __mutex_lock_slowpath+0xe2/0x250
 [<c0741b7a>] mutex_lock+0x2a/0x50
 [<c0387fb5>] ima_path_check+0xb5/0x370
 [<c03793f4>] ? security_inode_permission+0x64/0x90
 [<c0256263>] may_open+0xe3/0x440
 [<c025a43b>] ? path_walk+0x9b/0xc0
 [<c025bfde>] do_filp_open+0x2be/0xe70
 [<c01f1224>] ? unlock_page+0x54/0x70
 [<c0216ff8>] ? __do_fault+0x408/0x710
 [<c026b5b9>] ? alloc_fd+0x49/0x1b0
 [<c0246575>] do_sys_open+0xd5/0x1a0
 [<c02466d9>] sys_open+0x39/0x60
 [<c0104ed8>] syscall_call+0x7/0xb

............

Running (but hanged dd) trace:

dd            R running      0  3882   3430
 00000003 a949c236 f56dbcb8 f1aec000 c03cd800 00000000 f1b15ea0 00000000
 c0104f1e 00000003 0000000c 00000000 a949c236 f56dbcb8 f1aecc18 f620ba04
 0000007b 0000007b 000000d8 000000e0 ffffff10 c9c20c55 f1aecc28 c026eba2
Call Trace:
 [<c03cd800>] ? trace_hardirqs_on_thunk+0xc/0x10
 [<c0104f1e>] ? restore_nocheck_notrace+0x0/0x10
 [<c026eba2>] ? mnt_drop_write+0x32/0x200
 [<c01f2b1a>] ? find_get_page+0x1aa/0x200
 [<c026719f>] ? touch_atime+0x6f/0x310
 [<c01f45dd>] ? generic_file_aio_read+0xb6d/0xb80
 [<c02471dc>] ? do_sync_read+0xdc/0x150
 [<c0158bf7>] ? irq_exit+0x57/0xd0
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
 [<c01f1224>] ? unlock_page+0x54/0x70
 [<c0216ff8>] ? __do_fault+0x408/0x710
 [<c026b5b9>] ? alloc_fd+0x49/0x1b0
 [<c0246575>] ? do_sys_open+0xd5/0x1a0
 [<c02466d9>] ? sys_open+0x39/0x60
 [<c0104ed8>] ? syscall_call+0x7/0xb
...............................................

So it doesn't matter what file I'm selecting, only needs it it be big enough.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
