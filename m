From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15018] New: ext4 backtraces out of nowhere
Date: Sat, 9 Jan 2010 19:01:09 GMT
Message-ID: <bug-15018-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51674 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0AITBK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Jan 2010 14:01:10 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o09J19Kl005631
	for <linux-ext4@vger.kernel.org>; Sat, 9 Jan 2010 19:01:09 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=15018

           Summary: ext4 backtraces out of nowhere
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33-rc3
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sgunderson@bigfoot.com
        Regression: No


Hi,

While doing an rsync to an ext4 filesystem, suddenly the above showed up in my
dmesg:

Jan  9 15:55:20 pannekake kernel: [61568.551238] Pid: 28573, comm: rsync Not
tainted 2.6.33-rc3 #2
Jan  9 15:55:20 pannekake kernel: [61568.557085] Call Trace:
Jan  9 15:55:20 pannekake kernel: [61568.559623]  [<ffffffffa0253aa1>]
ext4_write_inode+0x4d/0xc7 [ext4]
Jan  9 15:55:20 pannekake kernel: [61568.566074]  [<ffffffff810dabe7>]
writeback_single_inode+0x125/0x2df
Jan  9 15:55:20 pannekake kernel: [61568.572563]  [<ffffffff810dae48>]
write_inode_now+0x78/0xba
Jan  9 15:55:20 pannekake kernel: [61568.578287]  [<ffffffffa0255b2d>]
ext4_da_get_block_prep+0x28b/0x36e [ext4]
Jan  9 15:55:20 pannekake kernel: [61568.585367]  [<ffffffff810e1b69>]
__block_prepare_write+0x1f3/0x3c0
Jan  9 15:55:20 pannekake kernel: [61568.591792]  [<ffffffffa02558a2>] ?
ext4_da_get_block_prep+0x0/0x36e [ext4]
Jan  9 15:55:20 pannekake kernel: [61568.598903]  [<ffffffff810e1eb1>]
block_write_begin+0x80/0xcf
Jan  9 15:55:20 pannekake kernel: [61568.604840]  [<ffffffffa02587be>]
ext4_da_write_begin+0x196/0x218 [ext4]
Jan  9 15:55:20 pannekake kernel: [61568.611683]  [<ffffffffa02558a2>] ?
ext4_da_get_block_prep+0x0/0x36e [ext4]
Jan  9 15:55:20 pannekake kernel: [61568.618803]  [<ffffffff810911c1>] ?
iov_iter_copy_from_user_atomic+0x84/0xf6
Jan  9 15:55:20 pannekake kernel: [61568.626052]  [<ffffffff8109133f>]
generic_file_buffered_write+0x10c/0x230
Jan  9 15:55:20 pannekake kernel: [61568.632961]  [<ffffffffa025375b>] ?
ext4_dirty_inode+0x40/0x45 [ext4]
Jan  9 15:55:20 pannekake kernel: [61568.639536]  [<ffffffff81092b9c>]
__generic_file_aio_write+0x347/0x37b
Jan  9 15:55:20 pannekake kernel: [61568.646245]  [<ffffffff81302709>] ?
__mutex_lock_slowpath+0x22d/0x23c
Jan  9 15:55:20 pannekake kernel: [61568.652819]  [<ffffffff81092c2b>]
generic_file_aio_write+0x5b/0xa2
Jan  9 15:55:20 pannekake kernel: [61568.659194]  [<ffffffffa024fa93>]
ext4_file_write+0x8e/0x97 [ext4]
Jan  9 15:55:20 pannekake kernel: [61568.665577]  [<ffffffff810bfbc8>]
do_sync_write+0xc0/0x106
Jan  9 15:55:20 pannekake kernel: [61568.671195]  [<ffffffff810cdb68>] ?
poll_select_copy_remaining+0xc5/0xe9
Jan  9 15:55:20 pannekake kernel: [61568.678015]  [<ffffffff81125b50>] ?
security_file_permission+0x11/0x13
Jan  9 15:55:20 pannekake kernel: [61568.684678]  [<ffffffff810c04df>]
vfs_write+0xae/0x14a
Jan  9 15:55:20 pannekake kernel: [61568.689954]  [<ffffffff810c063f>]
sys_write+0x47/0x6e
Jan  9 15:55:20 pannekake kernel: [61568.695111]  [<ffffffff81001feb>]
system_call_fastpath+0x16/0x1b

It showed up again ~20 minutes later, and since then I haven't seen it. I'm a
bit puzzled since I don't actually see any error messages (just the backtrace),
and I'm not able to find any ill effects except for the traceback, but I guess
it still shouldn't happen.

FWIW, the ext4 is on an LVM whose one of the component RAID-5s was resyncing at
the time. I don't know if that is relevant or not.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
