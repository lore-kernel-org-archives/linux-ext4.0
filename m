From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 Secure Delete 4/7v4] ext4: Secure Delete: Secure delete file data
Date: Fri,  7 Oct 2011 00:11:02 -0700
Message-ID: <1317971465-8517-5-git-send-email-achender@linux.vnet.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47808 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758800Ab1JGHHP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Oct 2011 03:07:15 -0400
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 7 Oct 2011 03:07:14 -0400
In-Reply-To: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch modifies punch hole and truncate to securely
delete the data blocks of a file.

During a truncate or punch hole, files that have the EXT4_SECRM_FL
attribute flag on will have their blocks secure deleted before
they are released.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 40d4e50... 984fac2... M	fs/ext4/extents.c
:100644 100644 0a526c4... bd1facd... M	fs/ext4/inode.c
 fs/ext4/extents.c |    7 +++++++
 fs/ext4/inode.c   |   12 ++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 40d4e50..984fac2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4201,6 +4201,13 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	/* finish any pending end_io work */
 	ext4_flush_completed_IO(inode);
 
+	if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL) {
+		err = ext4_secure_delete_lblks(inode, first_block,
+			last_block - first_block);
+		if (err)
+			return err;
+	}
+
 	credits = ext4_writepage_trans_blocks(inode);
 	handle = ext4_journal_start(inode, credits);
 	if (IS_ERR(handle))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0a526c4..bd1facd 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3420,6 +3420,8 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
  */
 void ext4_truncate(struct inode *inode)
 {
+	int err = 0;
+	ext4_lblk_t last_block;
 	trace_ext4_truncate_enter(inode);
 
 	if (!ext4_can_truncate(inode))
@@ -3430,6 +3432,16 @@ void ext4_truncate(struct inode *inode)
 	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
 		ext4_set_inode_state(inode, EXT4_STATE_DA_ALLOC_CLOSE);
 
+	last_block = (inode->i_size + EXT4_BLOCK_SIZE(inode->i_sb)-1)
+		>> EXT4_BLOCK_SIZE_BITS(inode->i_sb);
+
+	if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL) {
+		err = ext4_secure_delete_lblks(inode,
+			last_block, EXT_MAX_BLOCKS);
+		if (err)
+			return;
+	}
+
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		ext4_ext_truncate(inode);
 	else
-- 
1.7.1

