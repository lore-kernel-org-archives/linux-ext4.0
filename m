From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix lock order during truncate.
Date: Thu, 10 Jul 2008 14:26:04 +0530
Message-ID: <1215680164-15846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:42723 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYGJI4R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 04:56:17 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6A8tJfY020331
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 18:55:19 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6A8tjsu1810486
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 18:55:45 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6A8uCx3005050
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 18:56:13 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This can be merged to
ext4-fix-lock-inversion-in-ext4_ext_truncate.patch


=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc8 #32
-------------------------------------------------------
umount/4921 is trying to acquire lock:
 (&ei->i_data_sem){----}, at: [<c01dd2c1>] ext4_get_blocks_wrap+0x29/0x120

but task is already holding lock:
 (&type->s_lock_key#7){--..}, at: [<c0169211>] lock_super+0x1b/0x1d

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&type->s_lock_key#7){--..}:
       [<c013c820>] __lock_acquire+0x97f/0xb32
       [<c013ca3f>] lock_acquire+0x6c/0x89
       [<c0442dc4>] mutex_lock_nested+0xc9/0x248
       [<c0169211>] lock_super+0x1b/0x1d
       [<c01e2f71>] ext4_orphan_del+0x21/0x162
       [<c01ecaec>] ext4_ext_truncate+0x114/0x167
       [<c01dde2d>] ext4_truncate+0x84/0x40d
       [<c01582cb>] vmtruncate+0x103/0x129
       [<c01799ac>] inode_setattr+0x67/0x139
       [<c01df73c>] ext4_setattr+0x27b/0x2fa
       [<c0179bab>] notify_change+0x12d/0x2a6
       [<c016719b>] do_truncate+0x62/0x7b
       [<c01672d9>] do_sys_ftruncate+0x125/0x142
       [<c0167312>] sys_ftruncate64+0x1c/0x24
       [<c0103949>] sysenter_past_esp+0x6a/0xb1
       [<ffffffff>] 0xffffffff

-> #0 (&ei->i_data_sem){----}:
       [<c013c747>] __lock_acquire+0x8a6/0xb32
       [<c013ca3f>] lock_acquire+0x6c/0x89
       [<c044330a>] down_read+0x2b/0x65
       [<c01dd2c1>] ext4_get_blocks_wrap+0x29/0x120
       [<c01dd634>] ext4_get_block+0xa2/0xd7
       [<c01843f2>] generic_block_bmap+0x43/0x50
       [<c01de6de>] ext4_bmap+0x8d/0x96
       [<c01783d5>] bmap+0x26/0x2b
       [<c02070ee>] jbd2_journal_bmap+0x20/0x75
       [<c02072ae>] jbd2_journal_next_log_block+0x61/0x67
       [<c0207b44>] jbd2_journal_get_descriptor_buffer+0x13/0x90
       [<c0202f73>] journal_submit_commit_record+0x2f/0x19a
       [<c0203bb7>] jbd2_journal_commit_transaction+0xabf/0x1038
       [<c02069f9>] jbd2_journal_destroy+0xc8/0x1c9
       [<c01e5835>] ext4_put_super+0x35/0x1ab
       [<c0169a1a>] generic_shutdown_super+0x52/0xd3
       [<c0169aaa>] kill_block_super+0xf/0x20
       [<c0169b63>] deactivate_super+0x57/0x6a
       [<c017b6f3>] mntput_no_expire+0xba/0xdd
       [<c017bb95>] sys_umount+0x259/0x29b
       [<c0103949>] sysenter_past_esp+0x6a/0xb1
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by umount/4921:
 #0:  (&type->s_umount_key#17){----}, at: [<c0169b5e>] deactivate_super+0x52/0x6a
 #1:  (&type->s_lock_key#7){--..}, at: [<c0169211>] lock_super+0x1b/0x1d

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 48b8764..7bbc095 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2971,6 +2971,7 @@ void ext4_ext_truncate(struct inode *inode)
 		handle->h_sync = 1;
 
 out_stop:
+	up_write(&EXT4_I(inode)->i_data_sem);
 	/*
 	 * If this was a simple ftruncate() and the file will remain alive,
 	 * then we need to clear up the orphan record which we created above.
@@ -2981,7 +2982,6 @@ void ext4_ext_truncate(struct inode *inode)
 	if (inode->i_nlink)
 		ext4_orphan_del(handle, inode);
 
-	up_write(&EXT4_I(inode)->i_data_sem);
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
-- 
1.5.6.2.255.gbed62.dirty

