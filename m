From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v5 18/22] ext4: Make ext4_block_zero_page_range static
Date: Wed, 15 Jan 2014 20:24:36 -0500
Message-ID: <5b1f71d2a3659e8977990eba11f4aca50fbb5bf7.1389779962.git.matthew.r.wilcox@intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <cover.1389779961.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1389779961.git.matthew.r.wilcox@intel.com>
References: <cover.1389779961.git.matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

It's only called within inode.c, so make it static, remove its prototype
from ext4.h and move it above all of its callers so it doesn't need a
prototype within inode.c.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext4/ext4.h  |  2 --
 fs/ext4/inode.c | 42 +++++++++++++++++++++---------------------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e618503..a48d367 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2121,8 +2121,6 @@ extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
-extern int ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length);
 extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
 			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0757634..c767666 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3324,33 +3324,13 @@ void ext4_set_aops(struct inode *inode)
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
  * ext4_block_zero_page_range() zeros out a mapping of length 'length'
  * starting from file offset 'from'.  The range to be zero'd must
  * be contained with in one block.  If the specified range exceeds
  * the end of the block it will be shortened to end of the block
  * that cooresponds to 'from'
  */
-int ext4_block_zero_page_range(handle_t *handle,
+static int ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length)
 {
 	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
@@ -3440,6 +3420,26 @@ unlock:
 	return err;
 }
 
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
-- 
1.8.5.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
