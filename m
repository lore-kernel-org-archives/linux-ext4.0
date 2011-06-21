From: amir73il@users.sourceforge.net
Subject: [PATCH 1/4] ext4: split ext4_ind_truncate from ext4_truncate
Date: Tue, 21 Jun 2011 12:39:25 +0300
Message-ID: <1308649168-12543-2-git-send-email-amir73il@users.sourceforge.net>
References: <1308649168-12543-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62796 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab1FUJjv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 05:39:51 -0400
Received: by wyb38 with SMTP id 38so2252744wyb.19
        for <linux-ext4@vger.kernel.org>; Tue, 21 Jun 2011 02:39:50 -0700 (PDT)
In-Reply-To: <1308649168-12543-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

We are about to move all indirect inode functions to a new file.
Before we do that, let's split ext4_ind_truncate() out of ext4_truncate()
leaving only generic code in the latter, so we will be able to move
ext4_ind_truncate() to the new file.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 fs/ext4/ext4.h  |    2 ++
 fs/ext4/inode.c |   36 ++++++++++++++++++++----------------
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..8532dd4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1834,6 +1834,8 @@ extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
+extern void ext4_ind_truncate(struct inode *inode);
+
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
 extern long ext4_compat_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a5763e3..2bb7102 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4471,6 +4471,26 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
  */
 void ext4_truncate(struct inode *inode)
 {
+	trace_ext4_truncate_enter(inode);
+
+	if (!ext4_can_truncate(inode))
+		return;
+
+	ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
+
+	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
+		ext4_set_inode_state(inode, EXT4_STATE_DA_ALLOC_CLOSE);
+
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		ext4_ext_truncate(inode);
+	else
+		ext4_ind_truncate(inode);
+
+	trace_ext4_truncate_exit(inode);
+}
+
+void ext4_ind_truncate(struct inode *inode)
+{
 	handle_t *handle;
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	__le32 *i_data = ei->i_data;
@@ -4484,22 +4504,6 @@ void ext4_truncate(struct inode *inode)
 	ext4_lblk_t last_block, max_block;
 	unsigned blocksize = inode->i_sb->s_blocksize;
 
-	trace_ext4_truncate_enter(inode);
-
-	if (!ext4_can_truncate(inode))
-		return;
-
-	ext4_clear_inode_flag(inode, EXT4_INODE_EOFBLOCKS);
-
-	if (inode->i_size == 0 && !test_opt(inode->i_sb, NO_AUTO_DA_ALLOC))
-		ext4_set_inode_state(inode, EXT4_STATE_DA_ALLOC_CLOSE);
-
-	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		ext4_ext_truncate(inode);
-		trace_ext4_truncate_exit(inode);
-		return;
-	}
