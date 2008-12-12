From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v3] ext4: provide function to release metadata pages under memory pressure
Date: Fri, 12 Dec 2008 12:52:55 -0500
Message-ID: <1229104375-11567-3-git-send-email-tytso@mit.edu>
References: <20081212062148.GJ10890@mit.edu>
 <1229104375-11567-1-git-send-email-tytso@mit.edu>
 <1229104375-11567-2-git-send-email-tytso@mit.edu>
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36737 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757459AbYLLRxE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2008 12:53:04 -0500
In-Reply-To: <1229104375-11567-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

Pages in the page cache belonging to ext4 data files are released via
the ext4_releasepage() function specified in the ext4 inode's
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
 fs/ext4/ext4.h  |    2 ++
 fs/ext4/inode.c |   22 ++++++++++++++++++++++
 fs/ext4/super.c |    4 ++++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 695b45c..91e06e4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1099,6 +1099,8 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
+extern int ext4_release_metadata(void *client, struct page *page,
+		gfp_t wait);
 
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f6d9447..e77a059 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3045,6 +3045,28 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
 }
 
 /*
+ * Try to release metadata pages (indirect blocks, directories) which are
+ * mapped via the block device.  Since these pages could have journal heads
+ * which would prevent try_to_free_buffers() from freeing them, we must use
+ * jbd2 layer's try_to_free_buffers() function to release them.
+ */
+int ext4_release_metadata(void *client, struct page *page, gfp_t wait)
+{
+	struct super_block *sb = (struct super_block*)client;
+	journal_t *journal;
+
+	WARN_ON(PageChecked(page));
+	if (!page_has_buffers(page))
+		return 0;
+	BUG_ON(EXT4_SB(sb) == NULL);
+	journal = EXT4_SB(sb)->s_journal;
+	if (journal != NULL)
+		return jbd2_journal_try_to_free_buffers(journal, page, wait);
+	else
+		return try_to_free_buffers(page);
+}
+
+/*
  * If the O_DIRECT write will extend the file then add this inode to the
  * orphan list.  So recovery will truncate it back to the original size
  * if the machine crashes during the write.
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bd41fad..f447c46 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3689,6 +3689,8 @@ static struct file_system_type ext4_fs_type = {
 	.name		= "ext4",
 	.get_sb		= ext4_get_sb,
 	.kill_sb	= kill_block_super,
+	.release_metadata
+			= ext4_release_metadata,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
@@ -3708,6 +3710,8 @@ static struct file_system_type ext4dev_fs_type = {
 	.name		= "ext4dev",
 	.get_sb		= ext4dev_get_sb,
 	.kill_sb	= kill_block_super,
+	.release_metadata
+			= ext4_release_metadata,
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS("ext4dev");
-- 
1.6.0.4.8.g36f27.dirty

