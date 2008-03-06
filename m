From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 1/3] ext4 online defrag (ver 0.7)
Date: Thu, 06 Mar 2008 09:01:05 +0900
Message-ID: <200803060001.AA00323@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: a-fujita@rs.jp.nec.com
To: tytso@mit.edu, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:55913 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYCFAEZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Mar 2008 19:04:25 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akira Fujita <a-fujita@rs.jp.nec.com>

Interchange the data blocks of the target and temporary files
in an atomic manner.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
--
 fs/ext4/defrag.c |   55 ++++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index d22bec9..d9e01ea 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -392,7 +392,7 @@ static int
 ext4_ext_defrag_reserve(struct inode *inode, ext4_fsblk_t goal, int len)
 {
 	struct super_block *sb = NULL;
-	handle_t *handle = NULL;
+	handle_t *handle;
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_block_alloc_info *block_i;
 	struct ext4_reserve_window_node *my_rsv = NULL;
@@ -1301,11 +1301,10 @@ ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
  * Replace extents for blocks from "from" to "from + count - 1".
  */
 static int
-ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
-			pgoff_t from_page,  pgoff_t dest_from_page,
-			pgoff_t count_page, int flag)
+ext4_ext_replace_branches(handle_t *handle, struct inode *org_inode,
+			struct inode *dest_inode, pgoff_t from_page,
+			pgoff_t dest_from_page, pgoff_t count_page, int flag)
 {
-	handle_t *handle = NULL;
 	struct ext4_ext_path *org_path = NULL;
 	struct ext4_ext_path *dest_path = NULL;
 	struct ext4_extent *oext, *dext, *swap_ext;
@@ -1314,7 +1313,6 @@ ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
 	int err = 0;
 	int depth;
 	int replaced_count = 0;
-	unsigned jnum;
 
 	from = (ext4_lblk_t)from_page <<
 			(PAGE_CACHE_SHIFT - dest_inode->i_blkbits);
@@ -1322,12 +1320,6 @@ ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
 			(PAGE_CACHE_SHIFT - dest_inode->i_blkbits);
 	dest_off = (ext4_lblk_t)dest_from_page <<
 			(PAGE_CACHE_SHIFT - dest_inode->i_blkbits);
-	jnum = ext4_ext_writepage_trans_blocks(org_inode, count) + 3;
-	handle = ext4_journal_start(org_inode, jnum);
-	if (IS_ERR(handle)) {
-		err = PTR_ERR(handle);
-		goto out;
-	}
 
 	/* Get the original extent for the block "from" */
 	org_path = ext4_ext_find_extent(org_inode, from, NULL);
@@ -1455,8 +1447,6 @@ ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
 	}
 
 out:
-	if (handle)
-		ext4_journal_stop(handle);
 	if (org_path) {
 		ext4_ext_drop_refs(org_path);
 		kfree(org_path);
@@ -1686,9 +1676,22 @@ ext4_ext_defrag_partial(struct inode *tmp_inode, struct file *filp,
 	struct inode *inode = filp->f_dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
+	handle_t *handle;
 	pgoff_t offset_in_page = PAGE_SIZE;
+	int jblocks;
 	int ret = 0;
 
+	/*
+	 * It needs twice the amount of ordinary journal buffers because
+	 * inode and tmp_inode may change each different metadata blocks.
+	 */
+	jblocks = ext4_writepage_trans_blocks(inode) * 2;
+	handle = ext4_journal_start(inode, jblocks);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		return ret;
+	}
+
 	up_write(&EXT4_I(inode)->i_data_sem);
 	page = read_cache_page(inode->i_mapping, org_offset,
 		(filler_t *)inode->i_mapping->a_ops->readpage, NULL);
@@ -1713,8 +1716,8 @@ ext4_ext_defrag_partial(struct inode *tmp_inode, struct file *filp,
 
 	/* release old bh and drop refs */
 	try_to_release_page(page, 0);
-	ret = ext4_ext_replace_branches(inode, tmp_inode, org_offset,
-			dest_offset, 1, flag);
+	ret = ext4_ext_replace_branches(handle, inode, tmp_inode,
+					org_offset, dest_offset, 1, flag);
 	if (ret < 0)
 		goto ERR;
 
@@ -1744,6 +1747,7 @@ ext4_ext_defrag_partial(struct inode *tmp_inode, struct file *filp,
 ERR:
 	unlock_page(page);
 	page_cache_release(page);
+	ext4_journal_stop(handle);
 
 	return (ret < 0 ? ret : 0);
 }
@@ -1766,7 +1770,9 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 	struct buffer_head *bh;
 	struct page *page;
 	const struct address_space_operations *a_ops = mapping->a_ops;
+	handle_t *handle;
 	pgoff_t offset_in_page = PAGE_SIZE;
+	int jblocks;
 	int ret = 0;
 	int blocksize = inode->i_sb->s_blocksize;
 	int blocks_per_page = 0;
@@ -1776,6 +1782,17 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 	unsigned int w_flags = 0;
 	void *fsdata;
 
+	/*
+	 * It needs twice the amount of ordinary journal buffers because
+	 * inode and tmp_inode may change each different metadata blocks.
+	 */
+	jblocks = ext4_writepage_trans_blocks(inode) * 2;
+	handle = ext4_journal_start(inode, jblocks);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		return ret;
+	}
+
 	if (segment_eq(get_fs(), KERNEL_DS))
 		w_flags |= AOP_FLAG_UNINTERRUPTIBLE;
 
@@ -1815,8 +1832,8 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 
 	/* release old bh and drop refs */
 	try_to_release_page(page, 0);
-	ret = ext4_ext_replace_branches(inode, tmp_inode, org_offset,
-			dest_offset, 1, flag);
+	ret = ext4_ext_replace_branches(handle, inode, tmp_inode,
+					org_offset, dest_offset, 1, flag);
 
 	if (ret < 0)
 		goto ERR;
@@ -1849,6 +1866,8 @@ ext4_ext_defrag_partial2(struct inode *tmp_inode, struct file *filp,
 	if (unlikely(ret < 0))
 		goto ERR;
 ERR:
+	ext4_journal_stop(handle);
+
 	return (ret < 0 ? ret : 0);
 }
