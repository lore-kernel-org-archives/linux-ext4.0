From: "Theodore Ts'o" <tytso@mit.edu>
Subject: 2.6.35-rc6 REGRESSION: Dirtiable inode bdi default != sb bdi ext2/ext3/ext4
Date: Fri, 01 Oct 2010 17:35:54 -0400
Message-ID: <E1P1nGk-00023P-3d@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38553 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab0JAVgA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Oct 2010 17:36:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I'm not sure this is related to:

http://bugzilla.kernel.org/show_bug.cgi?id=19062

(2.6.35-rc6 REGRESSION: Dirtiable inode bdi default != sb bdi btrfs)

or not, but this is a problem that did not exist in 2.6.36-rc3 and
showed up when I tried going to 2.6.36-rc6.

The symptoms are that if I mount a filesystem, whether it be ext2, ext3,
or ext4, modify it slightly (say, create a file or a directory), then
umount the filesystem, and run "e2fsck -f" on that filesystem, I get the
warning:

[  866.543173] WARNING: at /usr/projects/linux/ext4/fs/fs-writeback.c:87 ino_bdi+0x4e/0x5c()
[  866.546156] Hardware name: 
[  866.547415] Dirtiable inode bdi block != sb bdi block
[  866.556113] Modules linked in:
[  866.557522] Pid: 1993, comm: e2fsck Tainted: G        W   2.6.36-rc6-0004aa513 #722
[  866.560365] Call Trace:
[  866.561475]  [<c015a2e2>] warn_slowpath_common+0x6a/0x7f
[  866.563312]  [<c020a762>] ? inode_to_bdi+0x4e/0x5c
[  866.565047]  [<c015a36a>] warn_slowpath_fmt+0x2b/0x2f
[  866.566852]  [<c020a762>] inode_to_bdi+0x4e/0x5c
[  866.568457]  [<c020b6c3>] __mark_inode_dirty+0xaf/0x162
[  866.570242]  [<c0202305>] file_update_time+0xcc/0xe9
[  866.571924]  [<c01c68dd>] __generic_file_aio_write+0x136/0x28f
[  866.573770]  [<c02145a4>] blkdev_aio_write+0x33/0x72
[  866.575480]  [<c01f20da>] do_sync_write+0x8f/0xca
[  866.577145]  [<c0646db8>] ? mutex_unlock+0xd/0xf
[  866.578760]  [<c030cc70>] ? security_file_permission+0x27/0x2b
[  866.583696]  [<c01f227c>] ? rw_verify_area+0x9d/0xc0
[  866.585906]  [<c01f204b>] ? do_sync_write+0x0/0xca
[  866.587735]  [<c01f2629>] vfs_write+0x85/0xe3
[  866.589575]  [<c01f2725>] sys_write+0x40/0x62
[  866.591435]  [<c064889d>] syscall_call+0x7/0xb
[  866.593240]  [<c0640000>] ? init_amd+0x158/0x532
[  866.594129] ---[ end trace 4cd5bce2135538d2 ]---

This is rather blatent and obvious, so I'm wondering how this got
missed?

							- Ted
