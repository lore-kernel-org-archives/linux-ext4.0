From: liang xie <xieliang007@gmail.com>
Subject: [PATCH] ext4: add missing BUFFER_TRACE before ext4_journal_get_write_access
Date: Wed, 16 Apr 2014 17:17:43 +0800
Message-ID: <CADu=CFqLi_L77conWoZDuiF91r+O=NNbotGG_W4JtmD9YD3NHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: tytso@mit.edu, adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:42688 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbaDPJRo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 05:17:44 -0400
Received: by mail-vc0-f179.google.com with SMTP id ij19so10203730vcb.24
        for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 02:17:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

make them more consistently

Signed-off-by: xieliang <xieliang@xiaomi.com>
---
 fs/ext4/extents.c     |  1 +
 fs/ext4/file.c        |  1 +
 fs/ext4/inline.c      |  5 +++++
 fs/ext4/inode.c       |  3 +++
 fs/ext4/mballoc.c     |  2 ++
 fs/ext4/move_extent.c |  1 +
 fs/ext4/namei.c       |  2 ++
 fs/ext4/resize.c      | 13 +++++++++++++
 fs/ext4/super.c       |  1 +
 fs/ext4/xattr.c       |  4 ++++
 10 files changed, 33 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 82df3ce..beb81f7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -143,6 +143,7 @@ static int ext4_ext_get_access(handle_t *handle,
struct inode *inode,
 {
     if (path->p_bh) {
         /* path points to block */
+        BUFFER_TRACE(path->p_bh, "get_write_access");
         return ext4_journal_get_write_access(handle, path->p_bh);
     }
     /* path points to leaf/index in inode body */
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index ca7502d..b885da2 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -244,6 +244,7 @@ static int ext4_file_open(struct inode * inode,
struct file * filp)
             handle = ext4_journal_start_sb(sb, EXT4_HT_MISC, 1);
             if (IS_ERR(handle))
                 return PTR_ERR(handle);
+            BUFFER_TRACE(sbi->s_sbh, "get_write_access");
             err = ext4_journal_get_write_access(handle, sbi->s_sbh);
             if (err) {
                 ext4_journal_stop(handle);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 82edf5b..f243c29 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -264,6 +264,7 @@ static int ext4_create_inline_data(handle_t *handle,
     if (error)
         return error;

+    BUFFER_TRACE(is.iloc.bh, "get_write_access");
     error = ext4_journal_get_write_access(handle, is.iloc.bh);
     if (error)
         goto out;
@@ -347,6 +348,7 @@ static int ext4_update_inline_data(handle_t
*handle, struct inode *inode,
     if (error == -ENODATA)
         goto out;

+    BUFFER_TRACE(is.iloc.bh, "get_write_access");
     error = ext4_journal_get_write_access(handle, is.iloc.bh);
     if (error)
         goto out;
@@ -424,6 +426,7 @@ static int ext4_destroy_inline_data_nolock(handle_t *handle,
     if (error)
         goto out;

+    BUFFER_TRACE(is.iloc.bh, "get_write_access");
     error = ext4_journal_get_write_access(handle, is.iloc.bh);
     if (error)
         goto out;
@@ -1007,6 +1010,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
     if (err)
         return err;

+    BUFFER_TRACE(iloc->bh, "get_write_access");
     err = ext4_journal_get_write_access(handle, iloc->bh);
     if (err)
         return err;
@@ -1669,6 +1673,7 @@ int ext4_delete_inline_entry(handle_t *handle,
                 EXT4_MIN_INLINE_DATA_SIZE;
     }

+    BUFFER_TRACE(bh, "get_write_access");
     err = ext4_journal_get_write_access(handle, bh);
     if (err)
         goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5b0d2c7..569bf77 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -918,6 +918,7 @@ int do_journal_get_write_access(handle_t *handle,
      */
     if (dirty)
         clear_buffer_dirty(bh);
+    BUFFER_TRACE(bh, "get write access");
     ret = ext4_journal_get_write_access(handle, bh);
     if (!ret && dirty)
         ret = ext4_handle_dirty_metadata(handle, NULL, bh);
@@ -1765,6 +1766,7 @@ static int __ext4_journalled_writepage(struct page *page,
     BUG_ON(!ext4_handle_valid(handle));

     if (inline_data) {
+        BUFFER_TRACE(inode_bh, "get write access");
         ret = ext4_journal_get_write_access(handle, inode_bh);

         err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
@@ -4364,6 +4366,7 @@ static int ext4_do_update_inode(handle_t *handle,
             /* If this is the first large file
              * created, add a flag to the superblock.
              */
+            BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get write access");
             err = ext4_journal_get_write_access(handle,
                     EXT4_SB(sb)->s_sbh);
             if (err)
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a888cac..044be6e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2868,6 +2868,7 @@ ext4_mb_mark_diskspace_used(struct
ext4_allocation_context *ac,
     if (!bitmap_bh)
         goto out_err;

+    BUFFER_TRACE(bitmap_bh, "getting write access");
     err = ext4_journal_get_write_access(handle, bitmap_bh);
     if (err)
         goto out_err;
@@ -2880,6 +2881,7 @@ ext4_mb_mark_diskspace_used(struct
ext4_allocation_context *ac,
     ext4_debug("using block group %u(%d)\n", ac->ac_b_ex.fe_group,
             ext4_free_group_clusters(sb, gdp));

+    BUFFER_TRACE(gdp_bh, "get_write_access");
     err = ext4_journal_get_write_access(handle, gdp_bh);
     if (err)
         goto out_err;
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 58ee7dc..d145c03 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -391,6 +391,7 @@ mext_insert_extents(handle_t *handle, struct inode
*orig_inode,

     if (depth) {
         /* Register to journal */
+        BUFFER_TRACE(orig_path->p_bh, "get_write_access");
         ret = ext4_journal_get_write_access(handle, orig_path->p_bh);
         if (ret)
             return ret;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1cb84f7..5d57938 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -67,6 +67,7 @@ static struct buffer_head *ext4_append(handle_t *handle,
         return ERR_PTR(err);
     inode->i_size += inode->i_sb->s_blocksize;
     EXT4_I(inode)->i_disksize = inode->i_size;
+    BUFFER_TRACE(bh, "get_write_access");
     err = ext4_journal_get_write_access(handle, bh);
     if (err) {
         brelse(bh);
@@ -1778,6 +1779,7 @@ static int make_indexed_dir(handle_t *handle,
struct dentry *dentry,

     blocksize =  dir->i_sb->s_blocksize;
     dxtrace(printk(KERN_DEBUG "Creating index: inode %lu\n", dir->i_ino));
+    BUFFER_TRACE(bh, "get_write_access");
     retval = ext4_journal_get_write_access(handle, bh);
     if (retval) {
         ext4_std_error(dir->i_sb, retval);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f3b84cd..bb9adab 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -348,6 +348,7 @@ static struct buffer_head *bclean(handle_t
*handle, struct super_block *sb,
     bh = sb_getblk(sb, blk);
     if (unlikely(!bh))
         return ERR_PTR(-ENOMEM);
+    BUFFER_TRACE(bh, "get_write_access");
     if ((err = ext4_journal_get_write_access(handle, bh))) {
         brelse(bh);
         bh = ERR_PTR(err);
@@ -426,6 +427,7 @@ static int set_flexbg_block_bitmap(struct
super_block *sb, handle_t *handle,
         if (unlikely(!bh))
             return -ENOMEM;

+        BUFFER_TRACE(bh, "get_write_access");
         err = ext4_journal_get_write_access(handle, bh);
         if (err)
             return err;
@@ -518,6 +520,7 @@ static int setup_new_flex_group_blocks(struct
super_block *sb,
                 goto out;
             }

+            BUFFER_TRACE(gdb, "get_write_access");
             err = ext4_journal_get_write_access(handle, gdb);
             if (err) {
                 brelse(gdb);
@@ -790,14 +793,17 @@ static int add_new_gdb(handle_t *handle, struct
inode *inode,
         goto exit_dind;
     }

+    BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
     err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
     if (unlikely(err))
         goto exit_dind;

+    BUFFER_TRACE(gdb_bh, "get_write_access");
     err = ext4_journal_get_write_access(handle, gdb_bh);
     if (unlikely(err))
         goto exit_dind;

+    BUFFER_TRACE(dind, "get_write_access");
     err = ext4_journal_get_write_access(handle, dind);
     if (unlikely(err))
         ext4_std_error(sb, err);
@@ -902,6 +908,7 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
     EXT4_SB(sb)->s_group_desc = n_group_desc;
     EXT4_SB(sb)->s_gdb_count++;
     ext4_kvfree(o_group_desc);
+    BUFFER_TRACE(gdb_bh, "get_write_access");
     err = ext4_journal_get_write_access(handle, gdb_bh);
     if (unlikely(err))
         brelse(gdb_bh);
@@ -977,6 +984,7 @@ static int reserve_backup_gdb(handle_t *handle,
struct inode *inode,
     }

     for (i = 0; i < reserved_gdb; i++) {
+        BUFFER_TRACE(primary[i], "get_write_access");
         if ((err = ext4_journal_get_write_access(handle, primary[i])))
             goto exit_bh;
     }
@@ -1084,6 +1092,7 @@ static void update_backups(struct super_block
*sb, int blk_off, char *data,
         ext4_debug("update metadata backup %llu(+%llu)\n",
                backup_block, backup_block -
                ext4_group_first_block_no(sb, group));
+        BUFFER_TRACE(bh, "get_write_access");
         if ((err = ext4_journal_get_write_access(handle, bh)))
             break;
         lock_buffer(bh);
@@ -1163,6 +1172,7 @@ static int ext4_add_new_descs(handle_t *handle,
struct super_block *sb,
          */
         if (gdb_off) {
             gdb_bh = sbi->s_group_desc[gdb_num];
+            BUFFER_TRACE(gdb_bh, "get_write_access");
             err = ext4_journal_get_write_access(handle, gdb_bh);

             if (!err && reserved_gdb && ext4_bg_num_gdb(sb, group))
@@ -1433,6 +1443,7 @@ static int ext4_flex_group_add(struct super_block *sb,
         goto exit;
     }

+    BUFFER_TRACE(sbi->s_sbh, "get_write_access");
     err = ext4_journal_get_write_access(handle, sbi->s_sbh);
     if (err)
         goto exit_journal;
@@ -1645,6 +1656,7 @@ static int ext4_group_extend_no_check(struct
super_block *sb,
         return err;
     }

+    BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
     err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
     if (err) {
         ext4_warning(sb, "error %d on journal write access", err);
@@ -1804,6 +1816,7 @@ static int ext4_convert_meta_bg(struct
super_block *sb, struct inode *inode)
     if (IS_ERR(handle))
         return PTR_ERR(handle);

+    BUFFER_TRACE(sbi->s_sbh, "get_write_access");
     err = ext4_journal_get_write_access(handle, sbi->s_sbh);
     if (err)
         goto errout;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f3c6670..fe4af6c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5367,6 +5367,7 @@ static ssize_t ext4_quota_write(struct
super_block *sb, int type,
     bh = ext4_bread(handle, inode, blk, 1, &err);
     if (!bh)
         goto out;
+    BUFFER_TRACE(bh, "get write access");
     err = ext4_journal_get_write_access(handle, bh);
     if (err) {
         brelse(bh);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1f5cf58..78fa472 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -513,6 +513,7 @@ static void ext4_xattr_update_super_block(handle_t *handle,
     if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR))
         return;

+    BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
     if (ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh) == 0) {
         EXT4_SET_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_EXT_ATTR);
         ext4_handle_dirty_super(handle, sb);
@@ -532,6 +533,7 @@ ext4_xattr_release_block(handle_t *handle, struct
inode *inode,
     struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);

     ce = mb_cache_entry_get(ext4_mb_cache, bh->b_bdev, bh->b_blocknr);
+    BUFFER_TRACE(bh, "get_write_access");
     error = ext4_journal_get_write_access(handle, bh);
     if (error)
         goto out;
@@ -759,6 +761,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
     if (s->base) {
         ce = mb_cache_entry_get(ext4_mb_cache, bs->bh->b_bdev,
                     bs->bh->b_blocknr);
+        BUFFER_TRACE(bs->bh, "get_write_access");
         error = ext4_journal_get_write_access(handle, bs->bh);
         if (error)
             goto cleanup;
@@ -844,6 +847,7 @@ inserted:
                         EXT4_C2B(EXT4_SB(sb), 1));
                 if (error)
                     goto cleanup;
+                BUFFER_TRACE(new_bh, "get_write_access");
                 error = ext4_journal_get_write_access(handle,
                                       new_bh);
                 if (error)
-- 
1.8.1.2
