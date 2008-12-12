From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v3] ext3: provide function to release metadata pages under memory pressure
Date: Fri, 12 Dec 2008 12:52:54 -0500
Message-ID: <1229104375-11567-2-git-send-email-tytso@mit.edu>
References: <20081212062148.GJ10890@mit.edu>
 <1229104375-11567-1-git-send-email-tytso@mit.edu>
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36739 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757579AbYLLRxE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 12:53:04 -0500
In-Reply-To: <1229104375-11567-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

Pages in the page cache belonging to ext3 data files are released via
the ext3_releasepage() function specified in the ext3 inode's
address_space_ops.  However, metadata blocks (such as indirect blocks,
directory blocks, etc) are managed via the block device
address_space_ops, and they can not be released by
try_to_free_buffers() if they have a journal head attached to them.

To address this, we supply a release_metadata function which is called
by the block device's blkdev_releasepage() function, which calls
journal_try_to_free_buffers() function to free the metadata.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/ext3/inode.c         |   22 ++++++++++++++++++++++
 fs/ext3/super.c         |    2 ++
 include/linux/ext3_fs.h |    2 ++
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index f8424ad..b1fecda 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1680,6 +1680,28 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
 }
 
 /*
+ * Try to release metadata pages (indirect blocks, directories) which are
+ * mapped via the block device.  Since these pages could have journal heads
+ * which would prevent try_to_free_buffers() from freeing them, we must use
+ * jbd layer's try_to_free_buffers() function to release them.
+ */
+int ext3_release_metadata(void *client, struct page *page, gfp_t wait)
+{
+	struct super_block *sb = (struct super_block*)client;
+	journal_t *journal;
+
+	WARN_ON(PageChecked(page));
+	if (!page_has_buffers(page))
+		return 0;
+	BUG_ON(EXT3_SB(sb) == NULL);
+	journal = EXT3_SB(sb)->s_journal;
+	if (journal != NULL)
+		return journal_try_to_free_buffers(journal, page, wait);
+	else
+		return try_to_free_buffers(page);
+}
+
+/*
  * If the O_DIRECT write will extend the file then add this inode to the
  * orphan list.  So recovery will truncate it back to the original size
  * if the machine crashes during the write.
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 541d5e4..4428149 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2981,6 +2981,8 @@ static struct file_system_type ext3_fs_type = {
 	.name		= "ext3",
 	.get_sb		= ext3_get_sb,
 	.kill_sb	= kill_block_super,
+	.release_metadata 
+			= ext3_release_metadata,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 9004794..3e3052f 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -867,6 +867,8 @@ extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
 extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
+extern int ext3_release_metadata(void *client, struct page *page, 
+			gfp_t wait);
 
 /* ioctl.c */
 extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
-- 
1.6.0.4.8.g36f27.dirty

