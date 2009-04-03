From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] ext3: Add replace-on-truncate hueristics for data=writeback mode
Date: Fri,  3 Apr 2009 03:01:06 -0400
Message-ID: <1238742067-30814-4-git-send-email-tytso@mit.edu>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
 <1238742067-30814-2-git-send-email-tytso@mit.edu>
 <1238742067-30814-3-git-send-email-tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: torvalds@linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36438 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZDCHBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2009 03:01:11 -0400
In-Reply-To: <1238742067-30814-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In data=writeback mode, start an asynchronous flush when closing a
file which had been previously truncated down to zero.  This lowers
the probability of data loss in the case of applications that attempt
to replace a file using truncate.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext3/file.c          |    4 ++++
 fs/ext3/inode.c         |    3 +++
 include/linux/ext3_fs.h |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 3be1e06..4a04cbb 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -33,6 +33,10 @@
  */
 static int ext3_release_file (struct inode * inode, struct file * filp)
 {
+	if (EXT3_I(inode)->i_state & EXT3_STATE_FLUSH_ON_CLOSE) {
+		filemap_flush(inode->i_mapping);
+		EXT3_I(inode)->i_state &= ~EXT3_STATE_FLUSH_ON_CLOSE;
+	}
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
 			(atomic_read(&inode->i_writecount) == 1))
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5fa453b..0f5bca0 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2346,6 +2346,9 @@ void ext3_truncate(struct inode *inode)
 	if (!ext3_can_truncate(inode))
 		return;
 
+	if (inode->i_size == 0 && ext3_should_writeback_data(inode))
+		ei->i_state |= EXT3_STATE_FLUSH_ON_CLOSE;
+
 	/*
 	 * We have to lock the EOF page here, because lock_page() nests
 	 * outside journal_start().
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index dd495b8..d2630c5 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -208,6 +208,7 @@ static inline __u32 ext3_mask_flags(umode_t mode, __u32 flags)
 #define EXT3_STATE_JDATA		0x00000001 /* journaled data exists */
 #define EXT3_STATE_NEW			0x00000002 /* inode is newly created */
 #define EXT3_STATE_XATTR		0x00000004 /* has in-inode xattrs */
+#define EXT3_STATE_FLUSH_ON_CLOSE	0x00000008
 
 /* Used to pass group descriptor data when online resize is done */
 struct ext3_new_group_input {
-- 
1.5.6.3

