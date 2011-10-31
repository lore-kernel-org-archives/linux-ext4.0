From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/5] ext4: io stat read related entrance
Date: Mon, 31 Oct 2011 17:43:02 +0800
Message-ID: <1320054184-14329-4-git-send-email-wenqing.lz@taobao.com>
References: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Cc: Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33740 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab1JaJl7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 05:41:59 -0400
In-Reply-To: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

Add read related statistic code at these read functions

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/balloc.c   |    5 ++++-
 fs/ext4/dir.c      |    6 ++++++
 fs/ext4/extents.c  |   13 ++++++++++---
 fs/ext4/ialloc.c   |    5 ++++-
 fs/ext4/indirect.c |   11 +++++++++--
 fs/ext4/inode.c    |   25 +++++++++++++++++++++----
 fs/ext4/mballoc.c  |    2 ++
 fs/ext4/namei.c    |   12 +++++++++---
 fs/ext4/super.c    |   12 +++++++++---
 fs/ext4/xattr.c    |   30 +++++++++++++++++++++++++-----
 10 files changed, 99 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f8224ad..b841c26 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -298,6 +298,8 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh = NULL;
 	ext4_fsblk_t bitmap_blk;
+	struct ios ios;
+	struct ext4_ios ext4_ios;
 
 	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
@@ -346,7 +348,8 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 	 */
 	trace_ext4_read_block_bitmap_load(sb, block_group);
 	set_bitmap_uptodate(bh);
-	if (bh_submit_read(bh) < 0) {
+	ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_BLOCK_BITMAP);
+	if (bh_submit_read_stat(bh, &ios) < 0) {
 		put_bh(bh);
 		ext4_error(sb, "Cannot read block bitmap - "
 			    "block_group = %u, block_bitmap = %llu",
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 164c560..35d9f17 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -153,6 +153,12 @@ static int ext4_readdir(struct file *filp,
 			pgoff_t index = map.m_pblk >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
+				/*
+				 * If in EXT4_INODE_INDEX mode, we reach here
+				 * because all dir entry are in one block, so
+				 * read ahead is nouse, we just statistic as
+				 * one block
+				 */
 				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
 					&filp->f_ra, filp,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..81f5b3f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -673,9 +673,12 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 		if (unlikely(!bh))
 			goto err;
 		if (!bh_uptodate_or_lock(bh)) {
+			struct ios ios;
+			struct ext4_ios ext4_ios;
 			trace_ext4_ext_load_extent(inode, block,
 						path[ppos].p_block);
-			if (bh_submit_read(bh) < 0) {
+			ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_EXTENT_BLOCK);
+			if (bh_submit_read_stat(bh, &ios) < 0) {
 				put_bh(bh);
 				goto err;
 			}
@@ -1275,6 +1278,8 @@ static int ext4_ext_search_right(struct inode *inode,
 	ext4_fsblk_t block;
 	int depth;	/* Note, NOT eh_depth; depth from top of tree */
 	int ee_len;
+	struct ios ios;
+	struct ext4_ios ext4_ios;
 
 	if (unlikely(path == NULL)) {
 		EXT4_ERROR_INODE(inode, "path == NULL *logical %d!", *logical);
@@ -1345,7 +1350,8 @@ got_index:
 	ix++;
 	block = ext4_idx_pblock(ix);
 	while (++depth < path->p_depth) {
-		bh = sb_bread(inode->i_sb, block);
+		ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_EXTENT_BLOCK);
+		bh = sb_bread_stat(inode->i_sb, block, &ios);
 		if (bh == NULL)
 			return -EIO;
 		eh = ext_block_hdr(bh);
@@ -1359,7 +1365,8 @@ got_index:
 		put_bh(bh);
 	}
 
-	bh = sb_bread(inode->i_sb, block);
+	ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_EXTENT_BLOCK);
+	bh = sb_bread_stat(inode->i_sb, block, &ios);
 	if (bh == NULL)
 		return -EIO;
 	eh = ext_block_hdr(bh);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 9c63f27..68b3295 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -104,6 +104,8 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh = NULL;
 	ext4_fsblk_t bitmap_blk;
+	struct ios ios;
+	struct ext4_ios ext4_ios;
 
 	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
@@ -154,7 +156,8 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	 */
 	trace_ext4_load_inode_bitmap(sb, block_group);
 	set_bitmap_uptodate(bh);
-	if (bh_submit_read(bh) < 0) {
+	ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_INODE_BITMAP);
+	if (bh_submit_read_stat(bh, &ios) < 0) {
 		put_bh(bh);
 		ext4_error(sb, "Cannot read inode bitmap - "
 			    "block_group = %u, inode_bitmap = %llu",
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 0962642..0f61f2f 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -158,7 +158,10 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 			goto failure;
 
 		if (!bh_uptodate_or_lock(bh)) {
-			if (bh_submit_read(bh) < 0) {
+			struct ios ios;
+			struct ext4_ios ext4_ios;
+			ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_INDIRECT_BLOCK);
+			if (bh_submit_read_stat(bh, &ios) < 0) {
 				put_bh(bh);
 				goto failure;
 			}
@@ -1233,6 +1236,9 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 		int addr_per_block = EXT4_ADDR_PER_BLOCK(inode->i_sb);
 		p = last;
 		while (--p >= first) {
+			struct ios ios;
+			struct ext4_ios ext4_ios;
+
 			nr = le32_to_cpu(*p);
 			if (!nr)
 				continue;		/* A hole */
@@ -1247,7 +1253,8 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 			}
 
 			/* Go read the buffer for the next level down */
-			bh = sb_bread(inode->i_sb, nr);
+			ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_INDIRECT_BLOCK);
+			bh = sb_bread_stat(inode->i_sb, nr, &ios);
 
 			/*
 			 * A read failure? Report error and clear slot
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 986e238..3179252 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -641,13 +641,16 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 			       ext4_lblk_t block, int create, int *err)
 {
 	struct buffer_head *bh;
+	struct ios ios;
+	struct ext4_ios ext4_ios;
 
 	bh = ext4_getblk(handle, inode, block, create, err);
 	if (!bh)
 		return bh;
 	if (buffer_uptodate(bh))
 		return bh;
-	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
+	ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_DIR_ENTRY);
+	ll_rw_block_stat(READ | REQ_META | REQ_PRIO, 1, &bh, &ios);
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
@@ -2529,6 +2532,8 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 static int ext4_readpage(struct file *file, struct page *page)
 {
 	trace_ext4_readpage(page);
+	__ext4_io_stat(__func__, __LINE__, READ, EXT4_IOS_REGULAR_DATA,
+		       ext4_blocks_per_page(page->mapping->host));
 	return mpage_readpage(page, ext4_get_block);
 }
 
@@ -2536,6 +2541,8 @@ static int
 ext4_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
+	__ext4_io_stat(__func__, __LINE__, READ, EXT4_IOS_REGULAR_DATA,
+		       nr_pages * ext4_blocks_per_page(mapping->host));
 	return mpage_readpages(mapping, pages, nr_pages, ext4_get_block);
 }
 
@@ -3048,8 +3055,11 @@ int ext4_block_zero_page_range(handle_t *handle,
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh)) {
+		struct ios ios;
+		struct ext4_ios ext4_ios;
 		err = -EIO;
-		ll_rw_block(READ, 1, &bh);
+		ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_REGULAR_DATA);
+		ll_rw_block_stat(READ, 1, &bh, &ios);
 		wait_on_buffer(bh);
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
@@ -3286,8 +3296,13 @@ make_io:
 			table += num / inodes_per_block;
 			if (end > table)
 				end = table;
-			while (b <= end)
-				sb_breadahead(sb, b++);
+			while (b <= end) {
+				struct ios ios;
+				struct ext4_ios ext4_ios;
+				ext4_init_ios(&ios, &ext4_ios,
+					      EXT4_IOS_INODE_TABLE);
+				sb_breadahead_stat(sb, b++, &ios);
+			}
 		}
 
 		/*
@@ -3306,6 +3321,8 @@ make_io:
 			brelse(bh);
 			return -EIO;
 		}
+		__ext4_io_stat(__func__, __LINE__, READ,
+			       EXT4_IOS_INODE_TABLE, 1);
 	}
 has_buffer:
 	iloc->bh = bh;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 17a5a57..d961d17 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -882,6 +882,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		set_bitmap_uptodate(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
+		__ext4_io_stat(__func__, __LINE__, READ,
+			       EXT4_IOS_BLOCK_BITMAP, 1);
 		mb_debug(1, "read bitmap for group %u\n", first_group + i);
 	}
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1c924fa..ba3f5b8 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -921,9 +921,15 @@ restart:
 				num++;
 				bh = ext4_getblk(NULL, dir, b++, 0, &err);
 				bh_use[ra_max] = bh;
-				if (bh)
-					ll_rw_block(READ | REQ_META | REQ_PRIO,
-						    1, &bh);
+				if (bh) {
+					struct ios ios;
+					struct ext4_ios ext4_ios;
+					ext4_init_ios(&ios, &ext4_ios,
+						      EXT4_IOS_DIR_ENTRY);
+					ll_rw_block_stat(READ | REQ_META | \
+							 REQ_PRIO, 1,
+							 &bh, &ios);
+				}
 			}
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 684f98a..49a5952 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3095,6 +3095,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
+	struct ios ios;
+	struct ext4_ios ext4_ios;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -3138,7 +3140,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		logical_sb_block = sb_block;
 	}
 
-	if (!(bh = sb_bread(sb, logical_sb_block))) {
+	ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_SUPER_BLOCK);
+	bh = sb_bread_stat(sb, logical_sb_block, &ios);
+	if (!bh) {
 		ext4_msg(sb, KERN_ERR, "unable to read superblock");
 		goto out_fail;
 	}
@@ -3285,7 +3289,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		brelse(bh);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
-		bh = sb_bread(sb, logical_sb_block);
+		ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_SUPER_BLOCK);
+		bh = sb_bread_stat(sb, logical_sb_block, &ios);
 		if (!bh) {
 			ext4_msg(sb, KERN_ERR,
 			       "Can't read superblock on 2nd try");
@@ -3455,7 +3460,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	for (i = 0; i < db_count; i++) {
 		block = descriptor_loc(sb, logical_sb_block, i);
-		sbi->s_group_desc[i] = sb_bread(sb, block);
+		ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_GROUP_DESC);
+		sbi->s_group_desc[i] = sb_bread_stat(sb, block, &ios);
 		if (!sbi->s_group_desc[i]) {
 			ext4_msg(sb, KERN_ERR,
 			       "can't read group descriptor %d", i);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c757adc..cb7a9bb 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -213,6 +213,8 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	struct ext4_xattr_entry *entry;
 	size_t size;
 	int error;
+	struct ios ios;
+	struct ext4_ios ext4_ios;
 
 	ea_idebug(inode, "name=%d.%s, buffer=%p, buffer_size=%ld",
 		  name_index, name, buffer, (long)buffer_size);
@@ -221,7 +223,8 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	if (!EXT4_I(inode)->i_file_acl)
 		goto cleanup;
 	ea_idebug(inode, "reading block %u", EXT4_I(inode)->i_file_acl);
-	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
+	ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_EXTENDED_ATTR);
+	bh = sb_bread_stat(inode->i_sb, EXT4_I(inode)->i_file_acl, &ios);
 	if (!bh)
 		goto cleanup;
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
@@ -356,6 +359,8 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	struct inode *inode = dentry->d_inode;
 	struct buffer_head *bh = NULL;
 	int error;
+	struct ios ios;
+	struct ext4_ios ext4_ios;
 
 	ea_idebug(inode, "buffer=%p, buffer_size=%ld",
 		  buffer, (long)buffer_size);
@@ -364,7 +369,8 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	if (!EXT4_I(inode)->i_file_acl)
 		goto cleanup;
 	ea_idebug(inode, "reading block %u", EXT4_I(inode)->i_file_acl);
-	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
+	ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_EXTENDED_ATTR);
+	bh = sb_bread_stat(inode->i_sb, EXT4_I(inode)->i_file_acl, &ios);
 	error = -EIO;
 	if (!bh)
 		goto cleanup;
@@ -655,7 +661,10 @@ ext4_xattr_block_find(struct inode *inode, struct ext4_xattr_info *i,
 
 	if (EXT4_I(inode)->i_file_acl) {
 		/* The inode already has an extended attribute block. */
-		bs->bh = sb_bread(sb, EXT4_I(inode)->i_file_acl);
+		struct ios ios;
+		struct ext4_ios ext4_ios;
+		ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_EXTENDED_ATTR);
+		bs->bh = sb_bread_stat(sb, EXT4_I(inode)->i_file_acl, &ios);
 		error = -EIO;
 		if (!bs->bh)
 			goto cleanup;
@@ -1186,7 +1195,11 @@ retry:
 	 * EA block can hold new_extra_isize bytes.
 	 */
 	if (EXT4_I(inode)->i_file_acl) {
-		bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
+		struct ios ios;
+		struct ext4_ios ext4_ios;
+		ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_EXTENDED_ATTR);
+		bh = sb_bread_stat(inode->i_sb, EXT4_I(inode)->i_file_acl,
+				   &ios);
 		error = -EIO;
 		if (!bh)
 			goto cleanup;
@@ -1364,10 +1377,14 @@ void
 ext4_xattr_delete_inode(handle_t *handle, struct inode *inode)
 {
 	struct buffer_head *bh = NULL;
+	struct ios ios;
+	struct ext4_ios ext4_ios;
 
 	if (!EXT4_I(inode)->i_file_acl)
 		goto cleanup;
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
+	ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_EXTENDED_ATTR);
+	bh = sb_bread_stat(inode->i_sb, EXT4_I(inode)->i_file_acl, &ios);
 	if (!bh) {
 		EXT4_ERROR_INODE(inode, "block %llu read error",
 				 EXT4_I(inode)->i_file_acl);
@@ -1493,13 +1510,16 @@ again:
 				       hash);
 	while (ce) {
 		struct buffer_head *bh;
+		struct ios ios;
+		struct ext4_ios ext4_ios;
 
 		if (IS_ERR(ce)) {
 			if (PTR_ERR(ce) == -EAGAIN)
 				goto again;
 			break;
 		}
-		bh = sb_bread(inode->i_sb, ce->e_block);
+		ext4_init_ios(&ios, &ext4_ios, EXT4_IOS_EXTENDED_ATTR);
+		bh = sb_bread_stat(inode->i_sb, ce->e_block, &ios);
 		if (!bh) {
 			EXT4_ERROR_INODE(inode, "block %lu read error",
 					 (unsigned long) ce->e_block);
-- 
1.7.4.1

