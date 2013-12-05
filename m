From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 4/4] ext4: Add xip hole punching
Date: Thu,  5 Dec 2013 13:02:48 -0700
Message-ID: <1386273769-12828-5-git-send-email-ross.zwisler@linux.intel.com>
References: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	carsteno@de.ibm.com, matthew.r.wilcox@intel.com,
	andreas.dilger@intel.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Matthew Wilcox <matthew.r.wilcox@intel.com>

We mustn't call ext4_block_zero_page_range() as that will attempt to
bring a page into the page cache in order to zero it.

To fix this, I made ext4_block_zero_page_range() a wrapper
around __ext4_block_zero_page_range(), that will call
the new xip_zero_page_range() for XIP files.  I also made
ext4_block_zero_page_range() static as it is not called outside inode.c.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
[ported to 3.13-rc2]
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext4/ext4.h  |    2 --
 fs/ext4/inode.c |   64 ++++++++++++++++++++++++++++---------------------------
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9b509a0..d083ad9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2122,8 +2122,6 @@ extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
-extern int ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length);
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 18d027f..7b50832 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3349,33 +3349,13 @@ void ext4_set_aops(struct inode *inode)
 }
 
 /*
- * ext4_block_truncate_page() zeroes out a mapping from file offset `from'
- * up to the end of the block which corresponds to `from'.
- * This required during truncate. We need to physically zero the tail end
- * of that block so it doesn't yield old data if the file is later grown.
- */
-int ext4_block_truncate_page(handle_t *handle,
-		struct address_space *mapping, loff_t from)
-{
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned length;
-	unsigned blocksize;
-	struct inode *inode = mapping->host;
-
-	blocksize = inode->i_sb->s_blocksize;
-	length = blocksize - (offset & (blocksize - 1));
-
-	return ext4_block_zero_page_range(handle, mapping, from, length);
-}
-
-/*
- * ext4_block_zero_page_range() zeros out a mapping of length 'length'
+ * __ext4_block_zero_page_range() zeros out a mapping of length 'length'
  * starting from file offset 'from'.  The range to be zero'd must
  * be contained with in one block.  If the specified range exceeds
  * the end of the block it will be shortened to end of the block
  * that cooresponds to 'from'
  */
-int ext4_block_zero_page_range(handle_t *handle,
+static int __ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length)
 {
 	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
@@ -3465,6 +3445,34 @@ unlock:
 	return err;
 }
 
+static int ext4_block_zero_page_range(handle_t *handle,
+		struct address_space *mapping, loff_t from, loff_t length)
+{
+	if (mapping_is_xip(mapping))
+		return xip_zero_page_range(mapping, from, length);
+	return __ext4_block_zero_page_range(handle, mapping, from, length);
+}
+
+/*
+ * ext4_block_truncate_page() zeroes out a mapping from file offset `from'
+ * up to the end of the block which corresponds to `from'.
+ * This required during truncate. We need to physically zero the tail end
+ * of that block so it doesn't yield old data if the file is later grown.
+ */
+int ext4_block_truncate_page(handle_t *handle,
+		struct address_space *mapping, loff_t from)
+{
+	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	unsigned length;
+	unsigned blocksize;
+	struct inode *inode = mapping->host;
+
+	blocksize = inode->i_sb->s_blocksize;
+	length = blocksize - (offset & (blocksize - 1));
+
+	return ext4_block_zero_page_range(handle, mapping, from, length);
+}
+
 int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t length)
 {
@@ -3763,14 +3771,8 @@ void ext4_truncate(struct inode *inode)
 		return;
 	}
 
-	if (inode->i_size & (inode->i_sb->s_blocksize - 1)) {
-		if (mapping_is_xip(inode->i_mapping)) {
-			if (xip_truncate_page(inode->i_mapping, inode->i_size))
-				goto out_stop;
-		} else
-			ext4_block_truncate_page(handle, mapping,
-						 inode->i_size);
-	}
+	if (inode->i_size & (inode->i_sb->s_blocksize - 1))
+		ext4_block_truncate_page(handle, mapping, inode->i_size);
 
 	/*
 	 * We add the inode to the orphan list, so that if this
@@ -4687,7 +4689,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		 * Truncate pagecache after we've waited for commit
 		 * in data=journal mode to make pages freeable.
 		 */
-			truncate_pagecache(inode, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 	}
 	/*
 	 * We want to call ext4_truncate() even if attr->ia_size ==
-- 
1.7.10.4

