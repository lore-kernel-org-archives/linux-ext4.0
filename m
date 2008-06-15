From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix file system hang due to corrupt jinode values.
Date: Sun, 15 Jun 2008 20:22:58 +0530
Message-ID: <1213541578-1351-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:59137 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbYFOOxW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jun 2008 10:53:22 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5FErrLq011394
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 00:53:53 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5FErKY4298334
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 00:53:20 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5FErJal029402
	for <linux-ext4@vger.kernel.org>; Mon, 16 Jun 2008 00:53:19 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While commiting the transaction we set the i_flags
of jbd2_inode to JI_COMMIT_RUNNING. This is needed to ensure
that when we are commiting the transaction we don't release
the inode via iput. In ext4_clear_inode we wait for the
flag to be cleared before we release the inode.

In ext4_new_inode we call iput for different failure cases
before initializing the jbd2_inode. This cause the failure
case to hang in iput as show below. Fix the same by initializing
jbd2_inode early.

 [<c022d20e>] ? prepare_to_wait+0x49/0x4e
 [<c02cf430>] jbd2_journal_release_jbd_inode+0x86/0xcc
 [<c022d0e4>] ? wake_bit_function+0x0/0x43
 [<c02b329b>] ext4_clear_inode+0x45/0x4a
 [<c02748f7>] clear_inode+0x5f/0xae
 [<c0274e8f>] generic_drop_inode+0x119/0x13a
 [<c0274071>] iput+0x4b/0x4e
 [<c02ab200>] ext4_new_inode+0xb29/0xb7a
 [<c0272761>] ? dput+0x19/0xdc
 [<c02cca5f>] ? jbd2_journal_start+0x8c/0xb9
 [<c02b1cb4>] ext4_create+0x81/0xe7
 [<c02b1c33>] ? ext4_create+0x0/0xe7
 [<c026aa3c>] vfs_create+0x6c/0xdb
 [<c026cfd6>] do_filp_open+0x1a6/0x6b5
 [<c026284e>] do_sys_open+0x40/0xb6
 [<c0262906>] sys_open+0x1e/0x26
 [<c0202be6>] syscall_call+0x7/0xb

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ialloc.c |    1 -
 fs/ext4/super.c  |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 7823405..dc8bfc4 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -820,7 +820,6 @@ struct inode *ext4_new_inode(handle_t *handle, struct inode * dir, int mode)
 	ei->i_state = EXT4_STATE_NEW;
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
-	jbd2_journal_init_jbd_inode(&ei->jinode, inode);
 
 	ret = inode;
 	if(DQUOT_ALLOC_INODE(inode)) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e207555..fde1ae9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -578,6 +578,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
+	jbd2_journal_init_jbd_inode(&ei->jinode, &ei->vfs_inode);
 	return &ei->vfs_inode;
 }
 
-- 
1.5.6.rc2.15.g457bb.dirty

