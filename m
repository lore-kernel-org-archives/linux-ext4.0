From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 3/8] ext4: Count metadata request of read operations in buffered io
Date: Thu, 10 Nov 2011 18:34:49 +0800
Message-ID: <1320921294-30321-4-git-send-email-wenqing.lz@taobao.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52220 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab1KJKdw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Nov 2011 05:33:52 -0500
In-Reply-To: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Add ext4_ios_read*() functions to count the metadata type of read in buffered
io. We cannot count it in breadahead() due to no buffer_head is passed or
returned in this function.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/balloc.c      |    1 +
 fs/ext4/extents.c     |    3 +++
 fs/ext4/ialloc.c      |    1 +
 fs/ext4/indirect.c    |    3 +++
 fs/ext4/inode.c       |    3 +++
 fs/ext4/mballoc.c     |    1 +
 fs/ext4/move_extent.c |    4 ++++
 fs/ext4/namei.c       |    5 ++++-
 fs/ext4/super.c       |    3 +++
 fs/ext4/xattr.c       |    6 ++++++
 10 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f6dba45..3503c33 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -394,6 +394,7 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
+	ext4_ios_read_one(bh, EXT4_IOS_BLOCK_BITMAP);
 	ext4_valid_block_bitmap(sb, desc, block_group, bh);
 	/*
 	 * file system mounted not to panic on error,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..289994f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -672,6 +672,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 				put_bh(bh);
 				goto err;
 			}
+			ext4_ios_read_one(bh, EXT4_IOS_EXTENT_BLOCK);
 			/* validate the extent entries */
 			need_to_validate = 1;
 		}
@@ -1326,6 +1327,7 @@ got_index:
 		bh = sb_bread(inode->i_sb, block);
 		if (bh == NULL)
 			return -EIO;
+		ext4_ios_read_one(bh, EXT4_IOS_EXTENT_BLOCK);
 		eh = ext_block_hdr(bh);
 		/* subtract from p_depth to get proper eh_depth */
 		if (ext4_ext_check(inode, eh, path->p_depth - depth)) {
@@ -2568,6 +2570,7 @@ again:
 				err = -EIO;
 				break;
 			}
+			ext4_ios_read_one(bh, EXT4_IOS_EXTENT_BLOCK);
 			if (WARN_ON(i + 1 > depth)) {
 				err = -EIO;
 				break;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 00beb4f..a86daff 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -161,6 +161,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 			    block_group, bitmap_blk);
 		return NULL;
 	}
+	ext4_ios_read_one(bh, EXT4_IOS_INODE_BITMAP);
 	return bh;
 }
 
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 3cfc73f..7ba97e3 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -162,6 +162,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 				put_bh(bh);
 				goto failure;
 			}
+			ext4_ios_read_one(bh, EXT4_IOS_INDIRECT_BLOCK);
 			/* validate block references */
 			if (ext4_check_indirect_blockref(inode, bh)) {
 				put_bh(bh);
@@ -1266,6 +1267,8 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 				continue;
 			}
 
+			ext4_ios_read_one(bh, EXT4_IOS_INDIRECT_BLOCK);
+
 			/* This zaps the entire block.  Bottom up. */
 			BUFFER_TRACE(bh, "free child branches");
 			ext4_free_branches(handle, inode, bh,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cc5a6da..d4f9da3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -701,6 +701,7 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 		return bh;
 	ll_rw_block(READ | REQ_META | REQ_PRIO, 1, &bh);
 	wait_on_buffer(bh);
+	ext4_ios_read_one(bh, EXT4_IOS_DIR_ENTRY);
 	if (buffer_uptodate(bh))
 		return bh;
 	put_bh(bh);
@@ -3426,6 +3427,7 @@ int ext4_block_zero_page_range(handle_t *handle,
 		err = -EIO;
 		ll_rw_block(READ, 1, &bh);
 		wait_on_buffer(bh);
+		ext4_ios_read_one(bh, EXT4_IOS_INODE_TABLE);
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
 			goto unlock;
@@ -3683,6 +3685,7 @@ make_io:
 			brelse(bh);
 			return -EIO;
 		}
+		ext4_ios_read_one(bh, EXT4_IOS_INODE_TABLE);
 	}
 has_buffer:
 	iloc->bh = bh;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..e5ca591 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -883,6 +883,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 		set_bitmap_uptodate(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
+		ext4_ios_read_one(bh[i], EXT4_IOS_BLOCK_BITMAP);
 		mb_debug(1, "read bitmap for group %u\n", first_group + i);
 	}
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c5826c6..200ae0f 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -102,6 +102,8 @@ mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
 				sb_bread(inode->i_sb, path[ppos].p_block);
 			if (!path[ppos+1].p_bh)
 				return -EIO;
+			ext4_ios_read_one(path[ppos+1].p_bh,
+					  EXT4_IOS_EXTENT_BLOCK);
 			path[ppos+1].p_hdr =
 				ext_block_hdr(path[ppos+1].p_bh);
 
@@ -117,6 +119,8 @@ mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
 					path[cur_ppos].p_block);
 				if (!path[cur_ppos+1].p_bh)
 					return -EIO;
+				ext4_ios_read_one(path[cur_ppos+1].p_bh,
+						  EXT4_IOS_EXTENT_BLOCK);
 				path[cur_ppos+1].p_hdr =
 					ext_block_hdr(path[cur_ppos+1].p_bh);
 			}
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index aa4c782..2bd167f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -921,9 +921,12 @@ restart:
 				num++;
 				bh = ext4_getblk(NULL, dir, b++, 0, &err);
 				bh_use[ra_max] = bh;
-				if (bh)
+				if (bh) {
 					ll_rw_block(READ | REQ_META | REQ_PRIO,
 						    1, &bh);
+					ext4_ios_read_one(bh,
+							  EXT4_IOS_DIR_ENTRY);
+				}
 			}
 		}
 		if ((bh = bh_use[ra_ptr++]) == NULL)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3bec50c..08aa193 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3171,6 +3171,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		ext4_msg(sb, KERN_ERR, "unable to read superblock");
 		goto out_fail;
 	}
+	ext4_ios_read_one(bh, EXT4_IOS_SUPER_BLOCK);
 	/*
 	 * Note: s_es must be initialized as soon as possible because
 	 *       some ext4 macro-instructions depend on its value
@@ -3345,6 +3346,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			       "Can't read superblock on 2nd try");
 			goto failed_mount;
 		}
+		ext4_ios_read_one(bh, EXT4_IOS_SUPER_BLOCK);
 		es = (struct ext4_super_block *)(((char *)bh->b_data) + offset);
 		sbi->s_es = es;
 		if (es->s_magic != cpu_to_le16(EXT4_SUPER_MAGIC)) {
@@ -3555,6 +3557,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			db_count = i;
 			goto failed_mount2;
 		}
+		ext4_ios_read_one(sbi->s_group_desc[i], EXT4_IOS_GROUP_DESC);
 	}
 	if (!ext4_check_descriptors(sb, &first_not_zeroed)) {
 		ext4_msg(sb, KERN_ERR, "group descriptors corrupted!");
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 93a00d8..9869805 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -224,6 +224,7 @@ ext4_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	bh = sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl);
 	if (!bh)
 		goto cleanup;
+	ext4_ios_read_one(bh, EXT4_IOS_EXTENDED_ATTR);
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
 	if (ext4_xattr_check_block(bh)) {
@@ -368,6 +369,7 @@ ext4_xattr_block_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	error = -EIO;
 	if (!bh)
 		goto cleanup;
+	ext4_ios_read_one(bh, EXT4_IOS_EXTENDED_ATTR);
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
 		atomic_read(&(bh->b_count)), le32_to_cpu(BHDR(bh)->h_refcount));
 	if (ext4_xattr_check_block(bh)) {
@@ -659,6 +661,7 @@ ext4_xattr_block_find(struct inode *inode, struct ext4_xattr_info *i,
 		error = -EIO;
 		if (!bs->bh)
 			goto cleanup;
+		ext4_ios_read_one(bs->bh, EXT4_IOS_EXTENDED_ATTR);
 		ea_bdebug(bs->bh, "b_count=%d, refcount=%d",
 			atomic_read(&(bs->bh->b_count)),
 			le32_to_cpu(BHDR(bs->bh)->h_refcount));
@@ -1192,6 +1195,7 @@ retry:
 		error = -EIO;
 		if (!bh)
 			goto cleanup;
+		ext4_ios_read_one(bh, EXT4_IOS_EXTENDED_ATTR);
 		if (ext4_xattr_check_block(bh)) {
 			EXT4_ERROR_INODE(inode, "bad block %llu",
 					 EXT4_I(inode)->i_file_acl);
@@ -1375,6 +1379,7 @@ ext4_xattr_delete_inode(handle_t *handle, struct inode *inode)
 				 EXT4_I(inode)->i_file_acl);
 		goto cleanup;
 	}
+	ext4_ios_read_one(bh, EXT4_IOS_EXTENDED_ATTR);
 	if (BHDR(bh)->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC) ||
 	    BHDR(bh)->h_blocks != cpu_to_le32(1)) {
 		EXT4_ERROR_INODE(inode, "bad block %llu",
@@ -1515,6 +1520,7 @@ again:
 			*pce = ce;
 			return bh;
 		}
+		ext4_ios_read_one(bh, EXT4_IOS_EXTENDED_ATTR);
 		brelse(bh);
 		ce = mb_cache_entry_find_next(ce, inode->i_sb->s_bdev, hash);
 	}
-- 
1.7.4.1

