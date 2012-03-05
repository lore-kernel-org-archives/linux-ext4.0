From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42872] New: fstat()/ext3_iget() sometime takes over 2
 minutes...
Date: Mon, 5 Mar 2012 18:52:58 GMT
Message-ID: <bug-42872-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:58479 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab2CESw6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Mar 2012 13:52:58 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q25Iqwff004504
	for <linux-ext4@vger.kernel.org>; Mon, 5 Mar 2012 18:52:58 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42872

           Summary: fstat()/ext3_iget() sometime takes over 2 minutes...
           Product: File System
           Version: 2.5
    Kernel Version: 3.3.0-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: petr@vandrovec.name
        Regression: No


Hello,
  few weeks ago I've changed my watchdog script to also do some I/O, to verify
that not only processes can be scheduled, but also filesystem is working.  And
since then my system reboots once a day, when updatedb is running :-(

Today I was watching it, and first kernel said that find is stuck in
ext3_iget() for over 2 minutes, while processing mounted 2.8TB filesystem, then
box rebooted...  Is it expected that fstat() can take over 2 minutes, and so my
60 seconds limit for writing 26 bytes (current time) to a file on / filesystem
is hopelessly optimistic (/ filesystem and filesystem on which find generated
message below are two separate filesystems), or is there something wrong?

[86761.680059] INFO: task find:6852 blocked for more than 120 seconds.
[86761.687191] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[86761.696014] find            D ffff880225d10f80     0  6852   6851 0x00000000
[86761.703944]  ffff88021de9ba08 0000000000000082 0000000100839940
ffff88021de9bfd8
[86761.712356]  0000000000004000 ffff88021de9bfd8 ffff880121294290
ffff8801d99458c0
[86761.720696]  ffff88021cba1840 000000012020b0e8 ffff88021f896000
ffff88022020b0e8
[86761.728993] Call Trace:
[86761.733241]  [<ffffffff8136cb72>] ? put_device+0x12/0x20
[86761.739379]  [<ffffffff81386deb>] ? scsi_request_fn+0xbb/0x450
[86761.746054]  [<ffffffff8106dbc8>] ? ktime_get_ts+0xa8/0xe0
[86761.752357]  [<ffffffff81123aa0>] ? __wait_on_buffer+0x30/0x30
[86761.758971]  [<ffffffff814e2bfa>] schedule+0x3a/0x50
[86761.764700]  [<ffffffff814e2c9a>] io_schedule+0x8a/0xd0
[86761.770650]  [<ffffffff81123aa9>] sleep_on_buffer+0x9/0x10
[86761.776901]  [<ffffffff814e1017>] __wait_on_bit+0x57/0x80
[86761.782991]  [<ffffffff814e10b5>] out_of_line_wait_on_bit+0x75/0x90
[86761.789918]  [<ffffffff81123aa0>] ? __wait_on_buffer+0x30/0x30
[86761.796407]  [<ffffffff8104dfc0>] ? autoremove_wake_function+0x40/0x40
[86761.803589]  [<ffffffff81123a96>] __wait_on_buffer+0x26/0x30
[86761.809890]  [<ffffffff81167ff8>] __ext3_get_inode_loc.isra.43+0x2d8/0x310
[86761.817410]  [<ffffffff811684fb>] ext3_iget+0x7b/0x460
[86761.823185]  [<ffffffff810ed4b2>] ? kmem_cache_alloc+0xa2/0xb0
[86761.829602]  [<ffffffff8116ede0>] ext3_lookup+0xa0/0x120
[86761.835497]  [<ffffffff81103e49>] d_alloc_and_lookup+0x39/0x80
[86761.841875]  [<ffffffff81104bcd>] do_lookup+0x2bd/0x3c0
[86761.847612]  [<ffffffff811a37e0>] ? security_dentry_open+0x70/0x80
[86761.854309]  [<ffffffff81106654>] path_lookupat+0x114/0x760
[86761.860341]  [<ffffffff81103c5d>] ? path_put+0x1d/0x30
[86761.865930]  [<ffffffff81106ccc>] do_path_lookup+0x2c/0xc0
[86761.871892]  [<ffffffff81108a54>] user_path_at_empty+0x54/0xa0
[86761.878172]  [<ffffffff81108aed>] ? do_filp_open+0x3d/0xa0
[86761.884120]  [<ffffffff810fdd7f>] ? cp_new_stat+0xdf/0xf0
[86761.889979]  [<ffffffff81108aac>] user_path_at+0xc/0x10
[86761.895651]  [<ffffffff810fdf95>] vfs_fstatat+0x35/0x60
[86761.901318]  [<ffffffff8111681f>] ? mntput+0x1f/0x30
[86761.906719]  [<ffffffff810faf77>] ? fput+0x167/0x210
[86761.912124]  [<ffffffff810fe155>] sys_newfstatat+0x15/0x30
[86761.918044]  [<ffffffff810f7871>] ? filp_close+0x61/0x90
[86761.923815]  [<ffffffff810f794f>] ? sys_close+0xaf/0x110
[86761.929549]  [<ffffffff814e92e2>] system_call_fastpath+0x16/0x1b

There are no I/O errors reported anywhere, and during regular work filesystem
seems responsive, capable of 70MBps sustained transfer rate (it is eSATA
enclosure on sil3132, with two 1.5TB disks in RAID0).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
