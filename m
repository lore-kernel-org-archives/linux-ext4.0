From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 01/12] e2fsck: add support for large xattrs in external inodes
Date: Mon, 26 Jun 2017 06:43:37 -0700
Message-ID: <20170626134348.1240-1-tahsin@google.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Kalpak Shah <kalpak.shah@sun.com>,
        Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34825 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752371AbdFZNn7 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:43:59 -0400
Received: by mail-pf0-f170.google.com with SMTP id c73so738573pfk.2
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:43:59 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <andreas.dilger@intel.com>

Add support for the INCOMPAT_EA_INODE feature, which stores large
extended attributes into an external inode instead of data blocks.
The inode is referenced by the e_value_inum field (formerly the
unused e_value_block field) from the extent header, and stores the
xattr data starting at byte offset 0 in the inode data block.

The xattr inode stores the referring inode number in its i_mtime,
and the parent i_generation in its own i_generation, so that there
is a solid linkage between the two that e2fsck can verify.  The
xattr inode is itself marked with EXT4_EA_INODE_FL as well.

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 e2fsck/e2fsck.h            |   1 +
 e2fsck/pass1.c             | 128 ++++++++++++++++++++++++++++++++++-----------
 e2fsck/pass4.c             |  18 +++++++
 e2fsck/problem.c           |  22 ++++++++
 e2fsck/problem.h           |  14 +++++
 lib/ext2fs/ext2_ext_attr.h |   2 +-
 lib/ext2fs/ext2_fs.h       |   3 +-
 lib/ext2fs/ext2fs.h        |   1 +
 lib/ext2fs/ext_attr.c      | 116 +++++++++++++++++++++++++---------------
 lib/ext2fs/swapfs.c        |   2 +-
 misc/mke2fs.c              |   1 +
 misc/tune2fs.c             |   2 +
 12 files changed, 235 insertions(+), 75 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index fd12024c2cd7..c19cdfdd733e 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -254,6 +254,7 @@ struct e2fsck_struct {
 	ext2fs_inode_bitmap inode_bb_map; /* Inodes which are in bad blocks */
 	ext2fs_inode_bitmap inode_imagic_map; /* AFS inodes */
 	ext2fs_inode_bitmap inode_reg_map; /* Inodes which are regular files*/
+	ext2fs_inode_bitmap inode_ea_map; /* EA inodes which are non-orphan */
 
 	ext2fs_block_bitmap block_found_map; /* Blocks which are in use */
 	ext2fs_block_bitmap block_dup_map; /* Blks referenced more than once */
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 422a3d699111..1c68af8990b4 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -26,6 +26,7 @@
  * 	- A bitmap of which blocks are in use.		(block_found_map)
  * 	- A bitmap of which blocks are in use by two inodes	(block_dup_map)
  * 	- The data blocks of the directory inodes.	(dir_map)
+ *	- A bitmap of EA inodes.			(inode_ea_map)
  *
  * Pass 1 is designed to stash away enough information so that the
  * other passes should not need to read in the inode information
@@ -333,6 +334,56 @@ static void check_size(e2fsck_t ctx, struct problem_context *pctx)
 	e2fsck_write_inode(ctx, pctx->ino, pctx->inode, "pass1");
 }
 
+static void mark_inode_ea_map(e2fsck_t ctx, struct problem_context *pctx,
+			      ext2_ino_t ino)
+{
+	if (!ctx->inode_ea_map) {
+		pctx->errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
+					 _("EA inode map"),
+					 &ctx->inode_ea_map);
+		if (pctx->errcode) {
+			fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR,
+				    pctx);
+			exit(1);
+		}
+	}
+
+	ext2fs_mark_inode_bitmap2(ctx->inode_ea_map, ino);
+}
+
+/*
+ * Check validity of EA inode. Return 0 if EA inode is valid, otherwise return
+ * the problem code.
+ */
+static problem_t check_large_ea_inode(e2fsck_t ctx,
+				      struct ext2_ext_attr_entry *entry,
+				      struct problem_context *pctx)
+{
+	struct ext2_inode inode;
+
+	/* Check if inode is within valid range */
+	if ((entry->e_value_inum < EXT2_FIRST_INODE(ctx->fs->super)) ||
+	    (entry->e_value_inum > ctx->fs->super->s_inodes_count))
+		return PR_1_ATTR_VALUE_EA_INODE;
+
+	e2fsck_read_inode(ctx, entry->e_value_inum, &inode, "pass1");
+	if (!(inode.i_flags & EXT4_EA_INODE_FL)) {
+		/* If EXT4_EA_INODE_FL flag is not present but back-pointer
+		 * matches then we should set this flag */
+		if (inode.i_mtime == pctx->ino &&
+		    inode.i_generation == pctx->inode->i_generation &&
+		    fix_problem(ctx, PR_1_ATTR_SET_EA_INODE_FL, pctx)) {
+			inode.i_flags |= EXT4_EA_INODE_FL;
+			ext2fs_write_inode(ctx->fs, entry->e_value_inum,&inode);
+		} else
+			return PR_1_ATTR_NO_EA_INODE_FL;
+	} else if (inode.i_mtime != pctx->ino ||
+		   inode.i_generation != pctx->inode->i_generation)
+		return PR_1_ATTR_INVAL_EA_INODE;
+
+	return 0;
+}
+
 static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
@@ -391,25 +442,28 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 		/* attribute len eats this space */
 		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
 
-		/* check value size */
-		if (entry->e_value_size > remain) {
-			pctx->num = entry->e_value_size;
-			problem = PR_1_ATTR_VALUE_SIZE;
-			goto fix;
-		}
+		if (entry->e_value_inum == 0) {
+			/* check value size */
+			if (entry->e_value_size > remain) {
+				pctx->num = entry->e_value_size;
+				problem = PR_1_ATTR_VALUE_SIZE;
+				goto fix;
+			}
 
-		/* e_value_block must be 0 in inode's ea */
-		if (entry->e_value_block != 0) {
-			pctx->num = entry->e_value_block;
-			problem = PR_1_ATTR_VALUE_BLOCK;
-			goto fix;
-		}
+			if (entry->e_value_size &&
+			    region_allocate(region,
+					    sizeof(__u32) + entry->e_value_offs,
+					    EXT2_EXT_ATTR_SIZE(
+						entry->e_value_size))) {
+				problem = PR_1_INODE_EA_ALLOC_COLLISION;
+				goto fix;
+			}
+		} else {
+			problem = check_large_ea_inode(ctx, entry, pctx);
+			if (problem != 0)
+				goto fix;
 
-		if (entry->e_value_size &&
-		    region_allocate(region, sizeof(__u32) + entry->e_value_offs,
-				    EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
-			problem = PR_1_INODE_EA_ALLOC_COLLISION;
-			goto fix;
+			mark_inode_ea_map(ctx, pctx, entry->e_value_inum);
 		}
 
 		hash = ext2fs_ext_attr_hash_entry(entry,
@@ -422,7 +476,10 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 			goto fix;
 		}
 
-		remain -= entry->e_value_size;
+		/* If EA value is stored in external inode then it does not
+		 * consume space here */
+		if (entry->e_value_inum == 0)
+			remain -= entry->e_value_size;
 
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
@@ -2368,19 +2425,28 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 				goto clear_extattr;
 			break;
 		}
-		if (entry->e_value_block != 0) {
-			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
-				goto clear_extattr;
-		}
-		if (entry->e_value_offs + entry->e_value_size > fs->blocksize) {
-			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
-				goto clear_extattr;
-			break;
-		}
-		if (entry->e_value_size &&
-		    region_allocate(region, entry->e_value_offs,
-				    EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
-			if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION, pctx))
+		if (entry->e_value_inum == 0) {
+			if (entry->e_value_offs + entry->e_value_size >
+			    fs->blocksize) {
+				if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
+					goto clear_extattr;
+				break;
+			}
+			if (entry->e_value_size &&
+			    region_allocate(region, entry->e_value_offs,
+					    EXT2_EXT_ATTR_SIZE(entry->e_value_size))) {
+				if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION,
+						pctx))
+					goto clear_extattr;
+			}
+		} else {
+			problem_t problem;
+
+			problem = check_large_ea_inode(ctx, entry, pctx);
+			if (problem == 0)
+				mark_inode_ea_map(ctx, pctx,
+						  entry->e_value_inum);
+			else if (fix_problem(ctx, problem, pctx))
 				goto clear_extattr;
 		}
 
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 8c101fd2805c..e44fc69c1613 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -11,6 +11,7 @@
  * Pass 4 frees the following data structures:
  * 	- A bitmap of which inodes are in bad blocks.	(inode_bb_map)
  * 	- A bitmap of which inodes are imagic inodes.	(inode_imagic_map)
+ *	- A bitmap of EA inodes.			(inode_ea_map)
  */
 
 #include "config.h"
@@ -38,6 +39,21 @@ static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i,
 			       "pass4: disconnect_inode");
 	if (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE)
 		extra_size = inode->i_extra_isize;
+
+	if (inode->i_flags & EXT4_EA_INODE_FL) {
+		if (ext2fs_test_inode_bitmap2(ctx->inode_ea_map, i)) {
+			ext2fs_icount_store(ctx->inode_count, i, 1);
+			return 0;
+		} else {
+			/* Zero the link count so that when inode is linked to
+			 * lost+found it has correct link count */
+			inode->i_links_count = 0;
+			e2fsck_write_inode(ctx, i, EXT2_INODE(inode),
+					   "disconnect_inode");
+			ext2fs_icount_store(ctx->inode_link_info, i, 0);
+		}
+	}
+
 	clear_problem_context(&pctx);
 	pctx.ino = i;
 	pctx.inode = EXT2_INODE(inode);
@@ -195,6 +211,8 @@ void e2fsck_pass4(e2fsck_t ctx)
 	}
 	ext2fs_free_icount(ctx->inode_link_info); ctx->inode_link_info = 0;
 	ext2fs_free_icount(ctx->inode_count); ctx->inode_count = 0;
+	ext2fs_free_inode_bitmap(ctx->inode_ea_map);
+	ctx->inode_ea_map = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_bb_map);
 	ctx->inode_bb_map = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_imagic_map);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 206a8a0b0639..dcdf9abe1abd 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1145,6 +1145,28 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Timestamp(s) on @i %i beyond 2310-04-04 are likely pre-1970.\n"),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
+	/* Inode has illegal extended attribute value inode */
+	{ PR_1_ATTR_VALUE_EA_INODE,
+	  N_("@i %i has @I @a value @i %N.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* Invalid backpointer from extended attribute inode to parent inode */
+	{ PR_1_ATTR_INVAL_EA_INODE,
+	  N_("@n backpointer from @a @i %N to parent @i %i.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* Inode has invalid extended attribute. EA inode missing
+	 * EA_INODE flag. */
+	{ PR_1_ATTR_NO_EA_INODE_FL,
+	  N_("@i %i has @n @a. EA @i %N missing EA_INODE flag.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* EA inode for parent inode missing EA_INODE flag. */
+	{ PR_1_ATTR_SET_EA_INODE_FL,
+	  N_("EA @i %N for parent @i %i missing EA_INODE flag.\n "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f8650b941b9a..dad608c94fd0 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -675,6 +675,20 @@ struct problem_context {
 /* Timestamp(s) on inode beyond 2310-04-04 are likely pre-1970. */
 #define PR_1_EA_TIME_OUT_OF_RANGE		0x010082
 
+/* Inode has illegal EA value inode */
+#define PR_1_ATTR_VALUE_EA_INODE		0x010083
+
+/* Invalid backpointer from EA inode to parent inode */
+#define PR_1_ATTR_INVAL_EA_INODE		0x010084
+
+/* Parent inode has invalid EA entry. EA inode does not have
+ * EXT4_EA_INODE_FL flag. Delete EA entry? */
+#define PR_1_ATTR_NO_EA_INODE_FL		0x010085
+
+/* EA inode for parent inode does not have EXT4_EA_INODE_FL flag */
+#define PR_1_ATTR_SET_EA_INODE_FL		0x010086
+
+
 /*
  * Pass 1b errors
  */
diff --git a/lib/ext2fs/ext2_ext_attr.h b/lib/ext2fs/ext2_ext_attr.h
index bbb0aaa97bca..f2042ed56cf9 100644
--- a/lib/ext2fs/ext2_ext_attr.h
+++ b/lib/ext2fs/ext2_ext_attr.h
@@ -29,7 +29,7 @@ struct ext2_ext_attr_entry {
 	__u8	e_name_len;	/* length of name */
 	__u8	e_name_index;	/* attribute name index */
 	__u16	e_value_offs;	/* offset in disk block of value */
-	__u32	e_value_block;	/* disk block attribute is stored on (n/i) */
+	__u32	e_value_inum;	/* inode in which the value is stored */
 	__u32	e_value_size;	/* size of attribute value */
 	__u32	e_hash;		/* hash value of name and value */
 #if 0
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 66b7058c3993..3b55000e3a90 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -922,7 +922,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		4, ENCRYPT)
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
 				       EXT4_FEATURE_INCOMPAT_MMP| \
-				       EXT4_FEATURE_INCOMPAT_LARGEDIR)
+				       EXT4_FEATURE_INCOMPAT_LARGEDIR| \
+				       EXT4_FEATURE_INCOMPAT_EA_INODE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c18ea5f827ad..f4131a640f9c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -598,6 +598,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_EA_INODE|\
 					 EXT4_LIB_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT|\
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 7a9a2d5a39bc..14d05c7e57fb 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -46,7 +46,7 @@ __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry, void *data)
 	}
 
 	/* The hash needs to be calculated on the data in little-endian. */
-	if (entry->e_value_block == 0 && entry->e_value_size != 0) {
+	if (entry->e_value_inum == 0 && entry->e_value_size != 0) {
 		__u32 *value = (__u32 *)data;
 		for (n = (entry->e_value_size + EXT2_EXT_ATTR_ROUND) >>
 			 EXT2_EXT_ATTR_PAD_BITS; n; n--) {
@@ -626,7 +626,7 @@ static errcode_t write_xattrs_to_buffer(struct ext2_xattr_handle *handle,
 		e->e_name_index = (ret ? idx : 0);
 		e->e_value_offs = end - value_size - (char *)entries_start +
 				value_offset_correction;
-		e->e_value_block = 0;
+		e->e_value_inum = 0;
 		e->e_value_size = x->value_len;
 
 		/* Store name and value */
@@ -824,38 +824,6 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 	remain = storage_size;
 	while (remain >= sizeof(struct ext2_ext_attr_entry) &&
 	       !EXT2_EXT_IS_LAST_ENTRY(entry)) {
-		__u32 hash;
-
-		/* header eats this space */
-		remain -= sizeof(struct ext2_ext_attr_entry);
-
-		/* attribute len eats this space */
-		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
-
-		/* check value size */
-		if (entry->e_value_size > remain)
-			return EXT2_ET_EA_BAD_VALUE_SIZE;
-
-		if (entry->e_value_offs + entry->e_value_size > values_size)
-			return EXT2_ET_EA_BAD_VALUE_OFFSET;
-
-		if (entry->e_value_size > 0 &&
-		    value_start + entry->e_value_offs <
-		    (char *)end + sizeof(__u32))
-			return EXT2_ET_EA_BAD_VALUE_OFFSET;
-
-		/* e_value_block must be 0 in inode's ea */
-		if (entry->e_value_block != 0)
-			return EXT2_ET_BAD_EA_BLOCK_NUM;
-
-		hash = ext2fs_ext_attr_hash_entry(entry, value_start +
-							 entry->e_value_offs);
-
-		/* e_hash may be 0 in older inode's ea */
-		if (entry->e_hash != 0 && entry->e_hash != hash)
-			return EXT2_ET_BAD_EA_HASH;
-
-		remain -= entry->e_value_size;
 
 		/* Allocate space for more attrs? */
 		if (x == handle->attrs + handle->length) {
@@ -865,7 +833,13 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 			x = handle->attrs + handle->length - 4;
 		}
 
-		/* Extract name/value */
+		/* header eats this space */
+		remain -= sizeof(struct ext2_ext_attr_entry);
+
+		/* attribute len eats this space */
+		remain -= EXT2_EXT_ATTR_SIZE(entry->e_name_len);
+
+		/* Extract name */
 		prefix = find_ea_prefix(entry->e_name_index);
 		prefix_len = (prefix ? strlen(prefix) : 0);
 		err = ext2fs_get_memzero(entry->e_name_len + prefix_len + 1,
@@ -879,12 +853,72 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 			       (char *)entry + sizeof(*entry),
 			       entry->e_name_len);
 
-		err = ext2fs_get_mem(entry->e_value_size, &x->value);
-		if (err)
-			return err;
+		/* Check & copy value */
+		if (!ext2fs_has_feature_ea_inode(handle->fs->super) &&
+		    entry->e_value_inum != 0)
+			return EXT2_ET_BAD_EA_BLOCK_NUM;
+
+		if (entry->e_value_inum == 0) {
+			if (entry->e_value_size > remain)
+				return EXT2_ET_EA_BAD_VALUE_SIZE;
+
+			if (entry->e_value_offs + entry->e_value_size > values_size)
+				return EXT2_ET_EA_BAD_VALUE_OFFSET;
+
+			if (entry->e_value_size > 0 &&
+			    value_start + entry->e_value_offs <
+			    (char *)end + sizeof(__u32))
+				return EXT2_ET_EA_BAD_VALUE_OFFSET;
+
+			remain -= entry->e_value_size;
+
+			err = ext2fs_get_mem(entry->e_value_size, &x->value);
+			if (err)
+				return err;
+			memcpy(x->value, value_start + entry->e_value_offs,
+			       entry->e_value_size);
+		} else {
+			ext2_file_t ea_file;
+
+			if (entry->e_value_offs != 0)
+				return EXT2_ET_EA_BAD_VALUE_OFFSET;
+
+			if (entry->e_value_size > (64 * 1024))
+				return EXT2_ET_EA_BAD_VALUE_SIZE;
+
+			err = ext2fs_get_mem(entry->e_value_size, &x->value);
+			if (err)
+				return err;
+
+			err = ext2fs_file_open(handle->fs, entry->e_value_inum,
+					       0, &ea_file);
+			if (err)
+				return err;
+
+			if (ext2fs_file_get_size(ea_file) !=
+			    entry->e_value_size)
+				err = EXT2_ET_EA_BAD_VALUE_SIZE;
+			else
+				err = ext2fs_file_read(ea_file, x->value,
+						       entry->e_value_size, 0);
+			ext2fs_file_close(ea_file);
+			if (err)
+				return err;
+		}
+
 		x->value_len = entry->e_value_size;
-		memcpy(x->value, value_start + entry->e_value_offs,
-		       entry->e_value_size);
+
+		/* e_hash may be 0 in older inode's ea */
+		if (entry->e_hash != 0) {
+			__u32 hash;
+			void *data = (entry->e_value_inum != 0) ?
+					0 : value_start + entry->e_value_offs;
+
+			hash = ext2fs_ext_attr_hash_entry(entry, data);
+			if (entry->e_hash != hash)
+				return EXT2_ET_BAD_EA_HASH;
+		}
+
 		x++;
 		(*nr_read)++;
 		entry = EXT2_EXT_ATTR_NEXT(entry);
@@ -1107,7 +1141,7 @@ errcode_t ext2fs_xattr_inode_max_size(ext2_filsys fs, ext2_ino_t ino,
 			inode->i_extra_isize + sizeof(__u32);
 		entry = (struct ext2_ext_attr_entry *) start;
 		while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
-			if (!entry->e_value_block && entry->e_value_size) {
+			if (!entry->e_value_inum && entry->e_value_size) {
 				unsigned int offs = entry->e_value_offs;
 				if (offs < minoff)
 					minoff = offs;
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 2d05ee7b995b..23a8570c2a3a 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -170,7 +170,7 @@ void ext2fs_swap_ext_attr_entry(struct ext2_ext_attr_entry *to_entry,
 				struct ext2_ext_attr_entry *from_entry)
 {
 	to_entry->e_value_offs  = ext2fs_swab16(from_entry->e_value_offs);
-	to_entry->e_value_block = ext2fs_swab32(from_entry->e_value_block);
+	to_entry->e_value_inum  = ext2fs_swab32(from_entry->e_value_inum);
 	to_entry->e_value_size  = ext2fs_swab32(from_entry->e_value_size);
 	to_entry->e_hash	= ext2fs_swab32(from_entry->e_hash);
 }
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 6cbba33b31d8..1ef46f44f35d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1082,6 +1082,7 @@ static __u32 ok_features[3] = {
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
+		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP |
 		EXT4_FEATURE_INCOMPAT_64BIT|
 		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index dc5872934427..90746707064b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -153,6 +153,7 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP |
 		EXT4_FEATURE_INCOMPAT_64BIT |
 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
@@ -179,6 +180,7 @@ static __u32 clear_ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP |
 		EXT4_FEATURE_INCOMPAT_64BIT |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED,
-- 
2.13.1.611.g7e3b11ae1-goog
