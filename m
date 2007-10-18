From: akpm@linux-foundation.org
Subject: - ext3-remove-ifdef-config_ext3_index.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:39 -0700
Message-ID: <200710180701.l9I71dYg031194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: sandeen@redhat.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: remove #ifdef CONFIG_EXT3_INDEX
has been removed from the -mm tree.  Its filename was
     ext3-remove-ifdef-config_ext3_index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: remove #ifdef CONFIG_EXT3_INDEX
From: Eric Sandeen <sandeen@redhat.com>

CONFIG_EXT3_INDEX is not an exposed config option in the kernel, and it is
unconditionally defined in ext3_fs.h.  tune2fs is already able to turn off
dir indexing, so at this point it's just cluttering up the code.  Remove
it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c           |    7 -------
 fs/ext3/namei.c         |   19 -------------------
 include/linux/ext3_fs.h |   14 ++------------
 3 files changed, 2 insertions(+), 38 deletions(-)

diff -puN fs/ext3/dir.c~ext3-remove-ifdef-config_ext3_index fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-remove-ifdef-config_ext3_index
+++ a/fs/ext3/dir.c
@@ -47,9 +47,7 @@ const struct file_operations ext3_dir_op
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
 	.fsync		= ext3_sync_file,	/* BKL held */
-#ifdef CONFIG_EXT3_INDEX
 	.release	= ext3_release_dir,
-#endif
 };
 
 
@@ -107,7 +105,6 @@ static int ext3_readdir(struct file * fi
 
 	sb = inode->i_sb;
 
-#ifdef CONFIG_EXT3_INDEX
 	if (EXT3_HAS_COMPAT_FEATURE(inode->i_sb,
 				    EXT3_FEATURE_COMPAT_DIR_INDEX) &&
 	    ((EXT3_I(inode)->i_flags & EXT3_INDEX_FL) ||
@@ -123,7 +120,6 @@ static int ext3_readdir(struct file * fi
 		 */
 		EXT3_I(filp->f_path.dentry->d_inode)->i_flags &= ~EXT3_INDEX_FL;
 	}
-#endif
 	stored = 0;
 	offset = filp->f_pos & (sb->s_blocksize - 1);
 
@@ -232,7 +228,6 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_EXT3_INDEX
 /*
  * These functions convert from the major/minor hash to an f_pos
  * value.
@@ -518,5 +513,3 @@ static int ext3_release_dir (struct inod
 
 	return 0;
 }
-
-#endif
diff -puN fs/ext3/namei.c~ext3-remove-ifdef-config_ext3_index fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-remove-ifdef-config_ext3_index
+++ a/fs/ext3/namei.c
@@ -144,7 +144,6 @@ struct dx_map_entry
 	u16 size;
 };
 
-#ifdef CONFIG_EXT3_INDEX
 static inline unsigned dx_get_block (struct dx_entry *entry);
 static void dx_set_block (struct dx_entry *entry, unsigned value);
 static inline unsigned dx_get_hash (struct dx_entry *entry);
@@ -768,8 +767,6 @@ static void dx_insert_block(struct dx_fr
 	dx_set_block(new, block);
 	dx_set_count(entries, count + 1);
 }
-#endif
-
 
 static void ext3_update_dx_flag(struct inode *inode)
 {
@@ -871,7 +868,6 @@ static struct buffer_head * ext3_find_en
 	name = dentry->d_name.name;
 	if (namelen > EXT3_NAME_LEN)
 		return NULL;
-#ifdef CONFIG_EXT3_INDEX
 	if (is_dx(dir)) {
 		bh = ext3_dx_find_entry(dentry, res_dir, &err);
 		/*
@@ -883,7 +879,6 @@ static struct buffer_head * ext3_find_en
 			return bh;
 		dxtrace(printk("ext3_find_entry: dx failed, falling back\n"));
 	}
-#endif
 	nblocks = dir->i_size >> EXT3_BLOCK_SIZE_BITS(sb);
 	start = EXT3_I(dir)->i_dir_start_lookup;
 	if (start >= nblocks)
@@ -959,7 +954,6 @@ cleanup_and_exit:
 	return ret;
 }
 
-#ifdef CONFIG_EXT3_INDEX
 static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 		       struct ext3_dir_entry_2 **res_dir, int *err)
 {
@@ -1027,7 +1021,6 @@ errout:
 	dx_release (frames);
 	return NULL;
 }
-#endif
 
 static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, struct nameidata *nd)
 {
@@ -1123,7 +1116,6 @@ static inline void ext3_set_de_type(stru
 		de->file_type = ext3_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
 }
 
-#ifdef CONFIG_EXT3_INDEX
 /*
  * Move count entries from end of map between two memory locations.
  * Returns pointer to last entry moved.
@@ -1268,7 +1260,6 @@ errout:
 	*error = err;
 	return NULL;
 }
-#endif
 
 
 /*
@@ -1366,7 +1357,6 @@ static int add_dirent_to_buf(handle_t *h
 	return 0;
 }
 
-#ifdef CONFIG_EXT3_INDEX
 /*
  * This converts a one block unindexed directory to a 3 block indexed
  * directory, and adds the dentry to the indexed directory.
@@ -1445,7 +1435,6 @@ static int make_indexed_dir(handle_t *ha
 
 	return add_dirent_to_buf(handle, dentry, inode, de, bh);
 }
-#endif
 
 /*
  *	ext3_add_entry()
@@ -1466,9 +1455,7 @@ static int ext3_add_entry (handle_t *han
 	struct ext3_dir_entry_2 *de;
 	struct super_block * sb;
 	int	retval;
-#ifdef CONFIG_EXT3_INDEX
 	int	dx_fallback=0;
-#endif
 	unsigned blocksize;
 	u32 block, blocks;
 
@@ -1476,7 +1463,6 @@ static int ext3_add_entry (handle_t *han
 	blocksize = sb->s_blocksize;
 	if (!dentry->d_name.len)
 		return -EINVAL;
-#ifdef CONFIG_EXT3_INDEX
 	if (is_dx(dir)) {
 		retval = ext3_dx_add_entry(handle, dentry, inode);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
@@ -1485,7 +1471,6 @@ static int ext3_add_entry (handle_t *han
 		dx_fallback++;
 		ext3_mark_inode_dirty(handle, dir);
 	}
-#endif
 	blocks = dir->i_size >> sb->s_blocksize_bits;
 	for (block = 0, offset = 0; block < blocks; block++) {
 		bh = ext3_bread(handle, dir, block, 0, &retval);
@@ -1495,11 +1480,9 @@ static int ext3_add_entry (handle_t *han
 		if (retval != -ENOSPC)
 			return retval;
 
-#ifdef CONFIG_EXT3_INDEX
 		if (blocks == 1 && !dx_fallback &&
 		    EXT3_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_DIR_INDEX))
 			return make_indexed_dir(handle, dentry, inode, bh);
-#endif
 		brelse(bh);
 	}
 	bh = ext3_append(handle, dir, &block, &retval);
@@ -1511,7 +1494,6 @@ static int ext3_add_entry (handle_t *han
 	return add_dirent_to_buf(handle, dentry, inode, de, bh);
 }
 
-#ifdef CONFIG_EXT3_INDEX
 /*
  * Returns 0 for success, or a negative error value
  */
@@ -1646,7 +1628,6 @@ cleanup:
 	dx_release(frames);
 	return err;
 }
-#endif
 
 /*
  * ext3_delete_entry deletes a directory entry by merging it with the
diff -puN include/linux/ext3_fs.h~ext3-remove-ifdef-config_ext3_index include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-remove-ifdef-config_ext3_index
+++ a/include/linux/ext3_fs.h
@@ -35,10 +35,6 @@
 /*max window size: 1024(direct blocks) + 3([t,d]indirect blocks) */
 #define EXT3_MAX_RESERVE_BLOCKS         1027
 #define EXT3_RESERVE_WINDOW_NOT_ALLOCATED 0
-/*
- * Always enable hashed directories
- */
-#define CONFIG_EXT3_INDEX
 
 /*
  * Debug code
@@ -665,17 +661,11 @@ struct ext3_dir_entry_2 {
  * (c) Daniel Phillips, 2001
  */
 
-#ifdef CONFIG_EXT3_INDEX
-  #define is_dx(dir) (EXT3_HAS_COMPAT_FEATURE(dir->i_sb, \
-					      EXT3_FEATURE_COMPAT_DIR_INDEX) && \
+#define is_dx(dir) (EXT3_HAS_COMPAT_FEATURE(dir->i_sb, \
+				      EXT3_FEATURE_COMPAT_DIR_INDEX) && \
 		      (EXT3_I(dir)->i_flags & EXT3_INDEX_FL))
 #define EXT3_DIR_LINK_MAX(dir) (!is_dx(dir) && (dir)->i_nlink >= EXT3_LINK_MAX)
 #define EXT3_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2 || (dir)->i_nlink == 1)
-#else
-  #define is_dx(dir) 0
-#define EXT3_DIR_LINK_MAX(dir) ((dir)->i_nlink >= EXT3_LINK_MAX)
-#define EXT3_DIR_LINK_EMPTY(dir) ((dir)->i_nlink == 2)
-#endif
 
 /* Legal values for the dx_root hash_version field: */
 
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ext4-remove-ifdef-config_ext4_index.patch
ext3-fix-setup_new_group_blocks-locking.patch
