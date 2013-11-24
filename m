From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 65701] New: oops: fs/ext4/ext4_jbd2.c
Date: Sun, 24 Nov 2013 23:44:01 +0000
Message-ID: <bug-65701-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab3KXXoF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Nov 2013 18:44:05 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DCC5D20218
	for <linux-ext4@vger.kernel.org>; Sun, 24 Nov 2013 23:44:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4DFFC201F4
	for <linux-ext4@vger.kernel.org>; Sun, 24 Nov 2013 23:44:02 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=65701

            Bug ID: 65701
           Summary: oops: fs/ext4/ext4_jbd2.c
           Product: File System
           Version: 2.5
    Kernel Version: Linux 3.11.9-gentoo #1 SMP Sun Nov 24 16:53:58 CET
                    2013 x86_64 Intel(R) Xeon(R) CPU X5650 @ 2.67GHz
                    GenuineIntel GNU/Linux
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: loco@andrews.lv
        Regression: No

The following oops happened shortly after kernel upgrade:

[18592.166266] ------------[ cut here ]------------
[18592.166279] WARNING: CPU: 3 PID: 4273 at fs/ext4/ext4_jbd2.c:48
ext4_journal_check_start+0x24/0x67()
[18592.166282] Modules linked in: xt_multiport vmwgfx cfbfillrect cfbimgblt
cfbcopyarea fb fbdev ttm drm i2c_core agpgart shpchp evdev libcrc32c aes_x86_64
sha256_generic iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi tg3 ptp
pps_core e1000 fuse nfs lockd sunrpc reiserfs linear raid10 raid456
async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1
raid0 dm_snapshot dm_crypt megaraid_sas megaraid_mbox megaraid_mm megaraid hpsa
cciss
[18592.166378] CPU: 3 PID: 4273 Comm: master Not tainted 3.11.9-gentoo-mrbyte
#1
[18592.166382] Hardware name: VMware, Inc. VMware Virtual Platform/440BX
Desktop Reference Platform, BIOS 6.00 06/22/2012
[18592.166385]  0000000000000000 ffffffff813718c8 0000000000000000
ffffffff81031607
[18592.166390]  ffffffff8114b7ac ffff880428c4d000 0000000000000002
0000000000000000
[18592.166394]  0000000000000001 ffffffff8114b7ac ffff880428c4d000
ffffffff8114b82f
[18592.166399] Call Trace:
[18592.166407]  [<ffffffff813718c8>] ? dump_stack+0x41/0x51
[18592.166415]  [<ffffffff81031607>] ? warn_slowpath_common+0x6f/0x84
[18592.166420]  [<ffffffff8114b7ac>] ? ext4_journal_check_start+0x24/0x67
[18592.166426]  [<ffffffff8114b7ac>] ? ext4_journal_check_start+0x24/0x67
[18592.166431]  [<ffffffff8114b82f>] ? __ext4_journal_start_sb+0x1b/0x65
[18592.166439]  [<ffffffff81136bbf>] ? ext4_dirty_inode+0x20/0x4f
[18592.166446]  [<ffffffff810e36ec>] ? __mark_inode_dirty+0x27/0x189
[18592.166452]  [<ffffffff810da24a>] ? update_time+0xa1/0xa8
[18592.166458]  [<ffffffff810340ca>] ? current_fs_time+0x20/0x23
[18592.166463]  [<ffffffff810daa2a>] ? file_update_time+0x92/0xb1
[18592.166469]  [<ffffffff810ce9a8>] ? pipe_write+0x40e/0x450
[18592.166475]  [<ffffffff810c7ea4>] ? do_sync_write+0x52/0x79
[18592.166481]  [<ffffffff810c8462>] ? vfs_write+0xa7/0x10b
[18592.166486]  [<ffffffff810c8aa0>] ? SyS_write+0x41/0x75
[18592.166492]  [<ffffffff8137723d>] ? tracesys+0xd4/0xd9
[18592.166495] ---[ end trace f01209520ef673d6 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
