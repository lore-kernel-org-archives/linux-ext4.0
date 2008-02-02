From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Replace iget with iget_locked in defrag-free-space-fragementation
Date: Sat, 02 Feb 2008 11:40:23 -0500
Message-ID: <E1JLLPj-0006dq-9C@closure.thunk.org>
Cc: Mingming Cao <cmm@us.ibm.com>, Takashi Sato <t-sato@yk.jp.nec.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57617 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750842AbYBBQkm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 11:40:42 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


FYI, since iget() is going to be disappearing in 2.6.25, and akpm has
disabled ext4 in the -mm tree as a result, I'm folding the following
patch into the defrag-free-space-fragmentation.patch in the ext4 tree.

We also have an issue where the read-only bind patches from Dave Hansen
are making changes which conflict with the ext4 patch tree, which is
making akpm very grumpy.  I'll try to take a look at this later in the
weekend...

						- Ted

diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index d9a14e4..6370fb8 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -287,9 +287,13 @@ static int ext4_ext_extents_info(struct ext4_extents_info *ext_info,
 	int entries = 0;
 	int err = 0;
 
-	inode = iget(sb, ext_info->ino);
+	inode = iget_locked(sb, ext_info->ino);
 	if (!inode)
 		return -EACCES;
+	if (inode->i_state & I_NEW) {
+		sb->s_op->read_inode(inode);
+		unlock_new_inode(inode);
+	}
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 
@@ -588,9 +592,13 @@ static int ext4_ext_defrag_victim(struct file *target_filp,
 	ext.len = 0;
 
 	/* Get the inode of the victim file */
-	victim_inode = iget(sb, ex_info->ino);
+	victim_inode = iget_locked(sb, ex_info->ino);
 	if (!victim_inode)
 		return -EACCES;
+	if (victim_inode->i_state & I_NEW) {
+		sb->s_op->read_inode(victim_inode);
+		unlock_new_inode(victim_inode);
+	}
 
 	/* Setup file for the victim file */
 	victim_dent.d_inode = victim_inode;
