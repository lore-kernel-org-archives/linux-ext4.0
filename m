From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Mon, 03 Jul 2017 06:15:51 +0000
Message-ID: <bug-196223-13602-U1fTJeqxBv@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:46846 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750784AbdGCGPx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Jul 2017 02:15:53 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BD6E92853A
        for <linux-ext4@vger.kernel.org>; Mon,  3 Jul 2017 06:15:52 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #4 from Marta Löfstedt (marta.lofstedt@intel.com) ---
(In reply to Theodore Tso from comment #3)
> Since this commit has been implicated in another problem (with quite
> different symptoms) it's a bit of a long shot, but since you have a quick
> and easy reproduction, can you try reverting 81378da64de6: "jbd2: mark the
> transaction context with the scope GFP_NOFS context" and see if that makes
> the hang go away?
> 
> Failing that, I might have to ask you to do a bisect on the ext4 patches
> added during the 4.12 merge window.

Doesn't help:
[  846.830596] INFO: task systemd:1 blocked for more than 120 seconds.
[  846.830705]       Tainted: G     U  W       4.12.0-rc7-next-20170630+ #3
[  846.830774] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  846.830854] systemd         D    0     1      0 0x00000000
[  846.830860] Call Trace:
[  846.830873]  __schedule+0x3c7/0x830
[  846.830880]  ? bit_wait+0x60/0x60
[  846.830884]  schedule+0x36/0x80
[  846.830889]  io_schedule+0x16/0x40
[  846.830893]  bit_wait_io+0x11/0x60
[  846.830898]  __wait_on_bit+0x58/0x90
[  846.830903]  ? submit_bio+0x73/0x150
[  846.830908]  out_of_line_wait_on_bit+0x8e/0xb0
[  846.830914]  ? bit_waitqueue+0x40/0x40
[  846.830920]  __wait_on_buffer+0x32/0x40
[  846.830926]  __ext4_get_inode_loc+0x1b3/0x400
[  846.830932]  ext4_iget+0x92/0xbc0
[  846.830938]  ext4_iget_normal+0x2f/0x40
[  846.830942]  ext4_lookup+0xea/0x270
[  846.830946]  lookup_slow+0xa5/0x160
[  846.830951]  walk_component+0x1bf/0x370
[  846.830954]  ? path_init+0x1e4/0x3a0
[  846.830958]  path_lookupat+0x73/0x220
[  846.830962]  filename_lookup+0xb8/0x1a0
[  846.830966]  ? __d_alloc+0x27/0x1d0
[  846.830972]  ? __check_object_size+0xb3/0x190
[  846.830977]  ? strncpy_from_user+0x4d/0x170
[  846.830981]  user_path_at_empty+0x36/0x40
[  846.830985]  ? user_path_at_empty+0x36/0x40
[  846.830990]  vfs_statx+0x83/0xf0
[  846.830995]  SYSC_newstat+0x3d/0x70
[  846.831001]  ? ep_read_events_proc+0xd0/0xd0
[  846.831006]  SyS_newstat+0xe/0x10
[  846.831010]  entry_SYSCALL_64_fastpath+0x1e/0xa9

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
