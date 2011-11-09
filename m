From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 6/9 bigalloc] ext4: zero out extra pages when truncate file
Date: Wed,  9 Nov 2011 19:17:05 +0800
Message-ID: <1320837428-8516-7-git-send-email-hao.bigrat@gmail.com>
References: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34783 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab1KILRi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Nov 2011 06:17:38 -0500
Received: by mail-yw0-f46.google.com with SMTP id 7so1599712ywf.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Nov 2011 03:17:37 -0800 (PST)
In-Reply-To: <1320837428-8516-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When truncate file to be larger, we need to zero out the pages which beyond
the old i_size.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/ext4.h     |    4 +-
 fs/ext4/extents.c  |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/inode.c    |   13 ++++----
 fs/ext4/ioctl.c    |    2 +-
 fs/ext4/super.c    |    2 +-
 fs/ext4/truncate.h |    2 +-
 6 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 90ae8a2..7d226af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1886,7 +1886,7 @@ extern void ext4_dirty_inode(struct inode *, int);
 extern int ext4_change_inode_journal_flag(struct inode *, int);
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern int ext4_can_truncate(struct inode *inode);
-extern void ext4_truncate(struct inode *);
+extern void ext4_truncate(struct inode *, loff_t oldsize);
 extern int ext4_punch_hole(struct file *file, loff_t offset, loff_t length);
 extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
 extern void ext4_set_inode_flags(struct inode *);
@@ -2267,7 +2267,7 @@ extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
 				       int chunk);
 extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			       struct ext4_map_blocks *map, int flags);
-extern void ext4_ext_truncate(struct inode *);
+extern void ext4_ext_truncate(struct inode *, loff_t oldsize);
 extern int ext4_ext_punch_hole(struct file *file, loff_t offset,
 				loff_t length);
 extern void ext4_ext_init(struct super_block *);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ccf12a0..f84c122 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4131,10 +4131,76 @@ out2:
 	return err ? err : result;
 }
 
-void ext4_ext_truncate(struct inode *inode)
+int ext4_ext_truncate_zero_pages(handle_t *handle, struct inode *inode,
+		loff_t old_size)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_write_cluster_ctxt *ewcc = NULL;
+	struct page *page;
+	ext4_lblk_t last_block = ((old_size + sb->s_blocksize - 1)
+			>> EXT4_BLOCK_SIZE_BITS(sb)) - 1;
+	ext4_lblk_t left_offset = last_block & (sbi->s_cluster_ratio - 1);
+	ext4_lblk_t right_offset = sbi->s_cluster_ratio - left_offset - 1;
+	ext4_lblk_t begin, index;
+	unsigned long i;
+	int ret = 0;
+	unsigned from, to;
+
+	if (sbi->s_cluster_ratio <= 1)
+		goto out;
+
+	if (right_offset) {
+		struct ext4_map_blocks map;
+		map.m_lblk = last_block;
+		map.m_len = 1;
+		if (ext4_map_blocks(handle, inode, &map, 0) <= 0
+			|| map.m_flags & EXT4_MAP_UNWRITTEN)
+			goto out;
+
+		ewcc = ext4_alloc_write_cluster_ctxt();
+		if (!ewcc) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		begin = last_block + 1;
+		for (index = begin; index < last_block + right_offset + 1;
+				index++) {
+			ret = ext4_zero_cluster_page(inode, index, ewcc,
+				mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
+			if (ret)
+				goto out;
+		}
+
+		if (ext4_should_journal_data(inode)) {
+			for (i = 0; i < ewcc->w_num_pages; i++) {
+				page = ewcc->w_pages[i];
+				if (!page || !page_buffers(page))
+					continue;
+				from = page->index << PAGE_CACHE_SHIFT;
+				to = from + PAGE_CACHE_SIZE;
+				ret = walk_page_buffers(handle,
+					page_buffers(page), from, to, NULL,
+					do_journal_get_write_access);
+				if (ret)
+					goto out;
+			}
+		}
+	}
+
+out:
+	if (ewcc)
+		ext4_free_write_cluster_ctxt(ewcc);
+
+	return ret;
+}
+
+void ext4_ext_truncate(struct inode *inode, loff_t old_size)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_lblk_t last_block;
 	handle_t *handle;
 	int err = 0;
@@ -4156,6 +4222,9 @@ void ext4_ext_truncate(struct inode *inode)
 	if (inode->i_size & (sb->s_blocksize - 1))
 		ext4_block_truncate_page(handle, mapping, inode->i_size);
 
+	if (ext4_ext_truncate_zero_pages(handle, inode, old_size))
+		goto out_stop;
+
 	if (ext4_orphan_add(handle, inode))
 		goto out_stop;
 
@@ -4176,6 +4245,13 @@ void ext4_ext_truncate(struct inode *inode)
 
 	last_block = (inode->i_size + sb->s_blocksize - 1)
 			>> EXT4_BLOCK_SIZE_BITS(sb);
+
+	if (sbi->s_cluster_ratio > 1 &&
+			(last_block & (sbi->s_cluster_ratio - 1))) {
+		last_block = (last_block & ~(sbi->s_cluster_ratio - 1)) +
+			sbi->s_cluster_ratio;
+	}
+
 	err = ext4_ext_remove_space(inode, last_block);
 
 	/* In a multi-transaction truncate, we only make the final
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0ae546d..be922ae 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -213,7 +213,7 @@ void ext4_evict_inode(struct inode *inode)
 		goto stop_handle;
 	}
 	if (inode->i_blocks)
-		ext4_truncate(inode);
+		ext4_truncate(inode, 0);
 
 	/*
 	 * ext4_ext_truncate() doesn't reserve any slop when it
@@ -3438,7 +3438,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
  * that's fine - as long as they are linked from the inode, the post-crash
  * ext4_truncate() run will find them and release them.
  */
-void ext4_truncate(struct inode *inode)
+void ext4_truncate(struct inode *inode, loff_t old_size)
 {
 	trace_ext4_truncate_enter(inode);
 
@@ -3451,7 +3451,7 @@ void ext4_truncate(struct inode *inode)
 		ext4_set_inode_state(inode, EXT4_STATE_DA_ALLOC_CLOSE);
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		ext4_ext_truncate(inode);
+		ext4_ext_truncate(inode, old_size);
 	else
 		ext4_ind_truncate(inode);
 
@@ -4218,11 +4218,12 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		if (attr->ia_size != i_size_read(inode)) {
+		loff_t old_size = i_size_read(inode);
+		if (attr->ia_size != old_size) {
 			truncate_setsize(inode, attr->ia_size);
-			ext4_truncate(inode);
+			ext4_truncate(inode, old_size);
 		} else if (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))
-			ext4_truncate(inode);
+			ext4_truncate(inode, 0);
 	}
 
 	if (!rc) {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 4a5081a..6eb2f4f 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -100,7 +100,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				goto flags_out;
 			}
 		} else if (oldflags & EXT4_EOFBLOCKS_FL)
-			ext4_truncate(inode);
+			ext4_truncate(inode, 0);
 
 		handle = ext4_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2cf4ae0..beea7a1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2229,7 +2229,7 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 				__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
-			ext4_truncate(inode);
+			ext4_truncate(inode, 0);
 			nr_truncates++;
 		} else {
 			ext4_msg(sb, KERN_DEBUG,
diff --git a/fs/ext4/truncate.h b/fs/ext4/truncate.h
index 011ba66..2be0783 100644
--- a/fs/ext4/truncate.h
+++ b/fs/ext4/truncate.h
@@ -11,7 +11,7 @@
 static inline void ext4_truncate_failed_write(struct inode *inode)
 {
 	truncate_inode_pages(inode->i_mapping, inode->i_size);
-	ext4_truncate(inode);
+	ext4_truncate(inode, 0);
 }
 
 /*
-- 
1.7.3.2

