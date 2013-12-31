From: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] ext4: make local functions static
Date: Mon, 30 Dec 2013 21:25:01 -0800
Message-ID: <20131230212501.409767a0@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:59004 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3LaFZL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Dec 2013 00:25:11 -0500
Received: by mail-pb0-f42.google.com with SMTP id uo5so12300318pbc.15
        for <linux-ext4@vger.kernel.org>; Mon, 30 Dec 2013 21:25:11 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have been running make namespacecheck to look for unneeded globals, and
found these in ext4.

In one case, the function order was swapped to avoid having to put
in a forward declaration.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 fs/ext4/balloc.c    |   21 +++++++++++----------
 fs/ext4/ext4.h      |   28 ----------------------------
 fs/ext4/ext4_jbd2.c |    7 ++++---
 fs/ext4/ext4_jbd2.h |    4 ----
 fs/ext4/file.c      |    2 +-
 fs/ext4/inline.c    |   10 +++++-----
 fs/ext4/inode.c     |   49 +++++++++++++++++++++++++------------------------
 fs/ext4/mmp.c       |    4 ++--
 8 files changed, 48 insertions(+), 77 deletions(-)

--- a/fs/ext4/balloc.c	2013-12-05 14:47:25.988496854 -0800
+++ b/fs/ext4/balloc.c	2013-12-30 21:13:05.724639559 -0800
@@ -83,9 +83,9 @@ static inline int ext4_block_in_group(st
 /* Return the number of clusters used for file system metadata; this
  * represents the overhead needed by the file system.
  */
-unsigned ext4_num_overhead_clusters(struct super_block *sb,
-				    ext4_group_t block_group,
-				    struct ext4_group_desc *gdp)
+static unsigned ext4_num_overhead_clusters(struct super_block *sb,
+					   ext4_group_t block_group,
+					   struct ext4_group_desc *gdp)
 {
 	unsigned num_clusters;
 	int block_cluster = -1, inode_cluster = -1, itbl_cluster = -1, i, c;
@@ -176,9 +176,10 @@ static unsigned int num_clusters_in_grou
 }
 
 /* Initializes an uninitialized block bitmap */
-void ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
-			    ext4_group_t block_group,
-			    struct ext4_group_desc *gdp)
+static void ext4_init_block_bitmap(struct super_block *sb,
+				   struct buffer_head *bh,
+				   ext4_group_t block_group,
+				   struct ext4_group_desc *gdp)
 {
 	unsigned int bit, bit_max;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -349,10 +350,10 @@ static ext4_fsblk_t ext4_valid_block_bit
 	return 0;
 }
 
-void ext4_validate_block_bitmap(struct super_block *sb,
-			       struct ext4_group_desc *desc,
-			       ext4_group_t block_group,
-			       struct buffer_head *bh)
+static void ext4_validate_block_bitmap(struct super_block *sb,
+				       struct ext4_group_desc *desc,
+				       ext4_group_t block_group,
+				       struct buffer_head *bh)
 {
 	ext4_fsblk_t	blk;
 	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
--- a/fs/ext4/ext4.h	2013-12-05 14:47:25.992496789 -0800
+++ b/fs/ext4/ext4.h	2013-12-30 21:21:54.925249190 -0800
@@ -1935,10 +1935,6 @@ extern void ext4_get_group_no_and_offset
 extern ext4_group_t ext4_get_group_number(struct super_block *sb,
 					  ext4_fsblk_t block);
 
-extern void ext4_validate_block_bitmap(struct super_block *sb,
-				       struct ext4_group_desc *desc,
-				       ext4_group_t block_group,
-				       struct buffer_head *bh);
 extern unsigned int ext4_block_group(struct super_block *sb,
 			ext4_fsblk_t blocknr);
 extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
@@ -1967,16 +1963,9 @@ extern int ext4_wait_block_bitmap(struct
 				  struct buffer_head *bh);
 extern struct buffer_head *ext4_read_block_bitmap(struct super_block *sb,
 						  ext4_group_t block_group);
-extern void ext4_init_block_bitmap(struct super_block *sb,
-				   struct buffer_head *bh,
-				   ext4_group_t group,
-				   struct ext4_group_desc *desc);
 extern unsigned ext4_free_clusters_after_init(struct super_block *sb,
 					      ext4_group_t block_group,
 					      struct ext4_group_desc *gdp);
-extern unsigned ext4_num_overhead_clusters(struct super_block *sb,
-					   ext4_group_t block_group,
-					   struct ext4_group_desc *gdp);
 ext4_fsblk_t ext4_inode_to_goal_block(struct inode *);
 
 /* dir.c */
@@ -2119,12 +2108,6 @@ extern int ext4_alloc_da_blocks(struct i
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
-extern int ext4_block_truncate_page(handle_t *handle,
-		struct address_space *mapping, loff_t from);
-extern int ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length);
-extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
-			     loff_t lstart, loff_t lend);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
@@ -2182,8 +2165,6 @@ extern int ext4_resize_fs(struct super_b
 
 /* super.c */
 extern int ext4_calculate_overhead(struct super_block *sb);
-extern int ext4_superblock_csum_verify(struct super_block *sb,
-				       struct ext4_super_block *es);
 extern void ext4_superblock_csum_set(struct super_block *sb);
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
@@ -2572,19 +2553,11 @@ extern const struct file_operations ext4
 extern const struct inode_operations ext4_file_inode_operations;
 extern const struct file_operations ext4_file_operations;
 extern loff_t ext4_llseek(struct file *file, loff_t offset, int origin);
-extern void ext4_unwritten_wait(struct inode *inode);
 
 /* inline.c */
 extern int ext4_has_inline_data(struct inode *inode);
-extern int ext4_get_inline_size(struct inode *inode);
 extern int ext4_get_max_inline_size(struct inode *inode);
 extern int ext4_find_inline_data_nolock(struct inode *inode);
-extern void ext4_write_inline_data(struct inode *inode,
-				   struct ext4_iloc *iloc,
-				   void *buffer, loff_t pos,
-				   unsigned int len);
-extern int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
-				    unsigned int len);
 extern int ext4_init_inline_data(handle_t *handle, struct inode *inode,
 				 unsigned int len);
 extern int ext4_destroy_inline_data(handle_t *handle, struct inode *inode);
@@ -2773,9 +2746,6 @@ extern int ext4_bio_write_page(struct ex
 
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
-extern void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp);
-extern int ext4_mmp_csum_verify(struct super_block *sb,
-				struct mmp_struct *mmp);
 
 /*
  * Note that these flags will never ever appear in a buffer_head's state flag.
--- a/fs/ext4/ext4_jbd2.c	2013-10-06 14:48:24.586453559 -0700
+++ b/fs/ext4/ext4_jbd2.c	2013-12-30 21:13:53.967966535 -0800
@@ -122,9 +122,10 @@ handle_t *__ext4_journal_start_reserved(
 	return handle;
 }
 
-void ext4_journal_abort_handle(const char *caller, unsigned int line,
-			       const char *err_fn, struct buffer_head *bh,
-			       handle_t *handle, int err)
+static void ext4_journal_abort_handle(const char *caller, unsigned int line,
+				      const char *err_fn,
+				      struct buffer_head *bh,
+				      handle_t *handle, int err)
 {
 	char nbuf[16];
 	const char *errstr = ext4_decode_error(NULL, err, nbuf);
--- a/fs/ext4/ext4_jbd2.h	2013-10-06 14:48:24.586453559 -0700
+++ b/fs/ext4/ext4_jbd2.h	2013-12-30 21:14:20.311598963 -0800
@@ -231,10 +231,6 @@ int ext4_mark_inode_dirty(handle_t *hand
 /*
  * Wrapper functions with which ext4 calls into JBD.
  */
-void ext4_journal_abort_handle(const char *caller, unsigned int line,
-			       const char *err_fn,
-		struct buffer_head *bh, handle_t *handle, int err);
-
 int __ext4_journal_get_write_access(const char *where, unsigned int line,
 				    handle_t *handle, struct buffer_head *bh);
 
--- a/fs/ext4/file.c	2013-10-06 14:48:24.586453559 -0700
+++ b/fs/ext4/file.c	2013-12-30 21:14:42.543288732 -0800
@@ -57,7 +57,7 @@ static int ext4_release_file(struct inod
 	return 0;
 }
 
-void ext4_unwritten_wait(struct inode *inode)
+static void ext4_unwritten_wait(struct inode *inode)
 {
 	wait_queue_head_t *wq = ext4_ioend_wq(inode);
 
--- a/fs/ext4/inline.c	2013-12-05 14:47:25.992496789 -0800
+++ b/fs/ext4/inline.c	2013-12-30 21:20:01.502834538 -0800
@@ -22,7 +22,7 @@
 #define EXT4_INLINE_DOTDOT_OFFSET	2
 #define EXT4_INLINE_DOTDOT_SIZE		4
 
-int ext4_get_inline_size(struct inode *inode)
+static int ext4_get_inline_size(struct inode *inode)
 {
 	if (EXT4_I(inode)->i_inline_off)
 		return EXT4_I(inode)->i_inline_size;
@@ -211,8 +211,8 @@ out:
  * value since it is already handled by ext4_xattr_ibody_inline_set.
  * That saves us one memcpy.
  */
-void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
-			    void *buffer, loff_t pos, unsigned int len)
+static void ext4_write_inline_data(struct inode *inode, struct ext4_iloc *iloc,
+				   void *buffer, loff_t pos, unsigned int len)
 {
 	struct ext4_xattr_entry *entry;
 	struct ext4_xattr_ibody_header *header;
@@ -373,8 +373,8 @@ out:
 	return error;
 }
 
-int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
-			     unsigned int len)
+static int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
+				    unsigned int len)
 {
 	int ret, size;
 	struct ext4_inode_info *ei = EXT4_I(inode);
--- a/fs/ext4/inode.c	2013-12-05 14:47:25.992496789 -0800
+++ b/fs/ext4/inode.c	2013-12-30 21:18:53.179789161 -0800
@@ -3324,34 +3324,15 @@ void ext4_set_aops(struct inode *inode)
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
-		struct address_space *mapping, loff_t from, loff_t length)
+static int ext4_block_zero_page_range(handle_t *handle,
+				      struct address_space *mapping,
+				      loff_t from, loff_t length)
 {
 	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
@@ -3440,8 +3421,28 @@ unlock:
 	return err;
 }
 
-int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
-			     loff_t lstart, loff_t length)
+/*
+ * ext4_block_truncate_page() zeroes out a mapping from file offset `from'
+ * up to the end of the block which corresponds to `from'.
+ * This required during truncate. We need to physically zero the tail end
+ * of that block so it doesn't yield old data if the file is later grown.
+ */
+static int ext4_block_truncate_page(handle_t *handle,
+				    struct address_space *mapping, loff_t from)
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
+static int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
+				    loff_t lstart, loff_t length)
 {
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
--- a/fs/ext4/mmp.c	2013-12-05 14:47:25.996496724 -0800
+++ b/fs/ext4/mmp.c	2013-12-30 21:20:14.978646219 -0800
@@ -18,7 +18,7 @@ static __le32 ext4_mmp_csum(struct super
 	return cpu_to_le32(csum);
 }
 
-int ext4_mmp_csum_verify(struct super_block *sb, struct mmp_struct *mmp)
+static int ext4_mmp_csum_verify(struct super_block *sb, struct mmp_struct *mmp)
 {
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
@@ -27,7 +27,7 @@ int ext4_mmp_csum_verify(struct super_bl
 	return mmp->mmp_checksum == ext4_mmp_csum(sb, mmp);
 }
 
-void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp)
+static void ext4_mmp_csum_set(struct super_block *sb, struct mmp_struct *mmp)
 {
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
--- a/fs/ext4/super.c	2013-12-05 14:47:25.996496724 -0800
+++ b/fs/ext4/super.c	2013-12-30 21:21:36.217510724 -0800
@@ -137,8 +137,8 @@ static __le32 ext4_superblock_csum(struc
 	return cpu_to_le32(csum);
 }
 
-int ext4_superblock_csum_verify(struct super_block *sb,
-				struct ext4_super_block *es)
+static int ext4_superblock_csum_verify(struct super_block *sb,
+				       struct ext4_super_block *es)
 {
 	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
