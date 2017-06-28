From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH v2 03/12] e2fsck: ea_inode hash validation
Date: Tue, 27 Jun 2017 18:41:55 -0700
Message-ID: <20170628014155.24475-1-tahsin@google.com>
References: <842B76D1-7759-4FA7-85A8-1E79B72C69EE@dilger.ca>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:35588 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752633AbdF1BmA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 21:42:00 -0400
Received: by mail-pg0-f53.google.com with SMTP id j186so23875735pge.2
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jun 2017 18:42:00 -0700 (PDT)
In-Reply-To: <842B76D1-7759-4FA7-85A8-1E79B72C69EE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In original implementation of ea_inode feature, each xattr inode had
a single parent. Child inode tracked the parent by storing its inode
number in i_mtime field. Also, child's i_generation matched parent's
i_generation.

With deduplication support, xattr inodes can now be shared so a single
backpointer is not sufficient to achieve strong binding. This is now
replaced by hash validation.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
v2:
 - restored original problem number definitions
 - pass parent inode to read_xattrs_from_buffer() instead of
   reading it again
 
 e2fsck/pass1.c        | 91 +++++++++++++++++++++++++++++++++------------------
 e2fsck/problem.c      |  5 ---
 e2fsck/problem.h      |  3 --
 lib/ext2fs/ext2fs.h   |  3 ++
 lib/ext2fs/ext_attr.c | 68 +++++++++++++++++++++++++++++++++++---
 5 files changed, 125 insertions(+), 45 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 1c68af8990b4..32152f3ec926 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -360,27 +360,54 @@ static problem_t check_large_ea_inode(e2fsck_t ctx,
 				      struct problem_context *pctx)
 {
 	struct ext2_inode inode;
+	__u32 hash;
+	errcode_t retval;
 
 	/* Check if inode is within valid range */
 	if ((entry->e_value_inum < EXT2_FIRST_INODE(ctx->fs->super)) ||
-	    (entry->e_value_inum > ctx->fs->super->s_inodes_count))
+	    (entry->e_value_inum > ctx->fs->super->s_inodes_count)) {
+		pctx->num = entry->e_value_inum;
 		return PR_1_ATTR_VALUE_EA_INODE;
+	}
 
 	e2fsck_read_inode(ctx, entry->e_value_inum, &inode, "pass1");
+
+	retval = ext2fs_ext_attr_hash_entry2(ctx->fs, entry, NULL, &hash);
+	if (retval) {
+		com_err("check_large_ea_inode", retval,
+			_("while hashing entry with e_value_inum = %u"),
+			entry->e_value_inum);
+		fatal_error(ctx, 0);
+	}
+
+	if (hash != entry->e_hash) {
+		/* This might be an old Lustre-style ea_inode reference. */
+		if (inode.i_mtime != pctx->ino ||
+		    inode.i_generation != pctx->inode->i_generation) {
+
+			/* If target inode is also missing EA_INODE flag,
+			 * this is likely to be a bad reference.
+			 */
+			if (!(inode.i_flags & EXT4_EA_INODE_FL)) {
+				pctx->num = entry->e_value_inum;
+				return PR_1_ATTR_VALUE_EA_INODE;
+			} else {
+				pctx->num = entry->e_hash;
+				return PR_1_ATTR_HASH;
+			}
+		}
+	}
+
 	if (!(inode.i_flags & EXT4_EA_INODE_FL)) {
-		/* If EXT4_EA_INODE_FL flag is not present but back-pointer
-		 * matches then we should set this flag */
-		if (inode.i_mtime == pctx->ino &&
-		    inode.i_generation == pctx->inode->i_generation &&
-		    fix_problem(ctx, PR_1_ATTR_SET_EA_INODE_FL, pctx)) {
+		pctx->num = entry->e_value_inum;
+		if (fix_problem(ctx, PR_1_ATTR_SET_EA_INODE_FL, pctx)) {
 			inode.i_flags |= EXT4_EA_INODE_FL;
-			ext2fs_write_inode(ctx->fs, entry->e_value_inum,&inode);
-		} else
+			ext2fs_write_inode(ctx->fs, entry->e_value_inum,
+					   &inode);
+		} else {
 			return PR_1_ATTR_NO_EA_INODE_FL;
-	} else if (inode.i_mtime != pctx->ino ||
-		   inode.i_generation != pctx->inode->i_generation)
-		return PR_1_ATTR_INVAL_EA_INODE;
-
+		}
+	}
 	return 0;
 }
 
@@ -458,6 +485,16 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 				problem = PR_1_INODE_EA_ALLOC_COLLISION;
 				goto fix;
 			}
+
+			hash = ext2fs_ext_attr_hash_entry(entry,
+							  start + entry->e_value_offs);
+
+			/* e_hash may be 0 in older inode's ea */
+			if (entry->e_hash != 0 && entry->e_hash != hash) {
+				pctx->num = entry->e_hash;
+				problem = PR_1_ATTR_HASH;
+				goto fix;
+			}
 		} else {
 			problem = check_large_ea_inode(ctx, entry, pctx);
 			if (problem != 0)
@@ -466,16 +503,6 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 			mark_inode_ea_map(ctx, pctx, entry->e_value_inum);
 		}
 
-		hash = ext2fs_ext_attr_hash_entry(entry,
-						  start + entry->e_value_offs);
-
-		/* e_hash may be 0 in older inode's ea */
-		if (entry->e_hash != 0 && entry->e_hash != hash) {
-			pctx->num = entry->e_hash;
-			problem = PR_1_ATTR_HASH;
-			goto fix;
-		}
-
 		/* If EA value is stored in external inode then it does not
 		 * consume space here */
 		if (entry->e_value_inum == 0)
@@ -2439,6 +2466,16 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 						pctx))
 					goto clear_extattr;
 			}
+
+			hash = ext2fs_ext_attr_hash_entry(entry, block_buf +
+							  entry->e_value_offs);
+
+			if (entry->e_hash != hash) {
+				pctx->num = entry->e_hash;
+				if (fix_problem(ctx, PR_1_ATTR_HASH, pctx))
+					goto clear_extattr;
+				entry->e_hash = hash;
+			}
 		} else {
 			problem_t problem;
 
@@ -2450,16 +2487,6 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 				goto clear_extattr;
 		}
 
-		hash = ext2fs_ext_attr_hash_entry(entry, block_buf +
-							 entry->e_value_offs);
-
-		if (entry->e_hash != hash) {
-			pctx->num = entry->e_hash;
-			if (fix_problem(ctx, PR_1_ATTR_HASH, pctx))
-				goto clear_extattr;
-			entry->e_hash = hash;
-		}
-
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
 	if (region_allocate(region, (char *)entry - (char *)header, 4)) {
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index dcdf9abe1abd..deffa4d66a89 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1150,11 +1150,6 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has @I @a value @i %N.\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* Invalid backpointer from extended attribute inode to parent inode */
-	{ PR_1_ATTR_INVAL_EA_INODE,
-	  N_("@n backpointer from @a @i %N to parent @i %i.\n"),
-	  PROMPT_CLEAR, PR_PREEN_OK },
-
 	/* Inode has invalid extended attribute. EA inode missing
 	 * EA_INODE flag. */
 	{ PR_1_ATTR_NO_EA_INODE_FL,
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index dad608c94fd0..60cc764fd2df 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -678,9 +678,6 @@ struct problem_context {
 /* Inode has illegal EA value inode */
 #define PR_1_ATTR_VALUE_EA_INODE		0x010083
 
-/* Invalid backpointer from EA inode to parent inode */
-#define PR_1_ATTR_INVAL_EA_INODE		0x010084
-
 /* Parent inode has invalid EA entry. EA inode does not have
  * EXT4_EA_INODE_FL flag. Delete EA entry? */
 #define PR_1_ATTR_NO_EA_INODE_FL		0x010085
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f4131a640f9c..f72cbe17a8cd 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1198,6 +1198,9 @@ extern errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir);
 /* ext_attr.c */
 extern __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry,
 					void *data);
+extern errcode_t ext2fs_ext_attr_hash_entry2(ext2_filsys fs,
+					     struct ext2_ext_attr_entry *entry,
+					     void *data, __u32 *hash);
 extern errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf);
 extern errcode_t ext2fs_read_ext_attr2(ext2_filsys fs, blk64_t block,
 				       void *buf);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 14d05c7e57fb..d2ce51bcdcd8 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -25,6 +25,18 @@
 
 #include "ext2fs.h"
 
+static errcode_t read_ea_inode_hash(ext2_filsys fs, ext2_ino_t ino, __u32 *hash)
+{
+	struct ext2_inode inode;
+	errcode_t retval;
+
+	retval = ext2fs_read_inode(fs, ino, &inode);
+	if (retval)
+		return retval;
+	*hash = inode.i_atime;
+	return 0;
+}
+
 #define NAME_HASH_SHIFT 5
 #define VALUE_HASH_SHIFT 16
 
@@ -59,6 +71,35 @@ __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry, void *data)
 	return hash;
 }
 
+/*
+ * ext2fs_ext_attr_hash_entry2()
+ *
+ * Compute the hash of an extended attribute.
+ * This version of the function supports hashing entries that reference
+ * external inodes (ea_inode feature).
+ */
+errcode_t ext2fs_ext_attr_hash_entry2(ext2_filsys fs,
+				      struct ext2_ext_attr_entry *entry,
+				      void *data, __u32 *hash)
+{
+	*hash = ext2fs_ext_attr_hash_entry(entry, data);
+
+	if (entry->e_value_inum) {
+		__u32 ea_inode_hash;
+		errcode_t retval;
+
+		retval = read_ea_inode_hash(fs, entry->e_value_inum,
+					    &ea_inode_hash);
+		if (retval)
+			return retval;
+
+		*hash = (*hash << VALUE_HASH_SHIFT) ^
+			(*hash >> (8*sizeof(*hash) - VALUE_HASH_SHIFT)) ^
+			ea_inode_hash;
+	}
+	return 0;
+}
+
 static errcode_t check_ext_attr_header(struct ext2_ext_attr_header *header)
 {
 	if ((header->h_magic != EXT2_EXT_ATTR_MAGIC_v1 &&
@@ -785,6 +826,7 @@ out:
 }
 
 static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
+					 struct ext2_inode_large *inode,
 					 struct ext2_ext_attr_entry *entries,
 					 unsigned int storage_size,
 					 char *value_start,
@@ -914,9 +956,25 @@ static errcode_t read_xattrs_from_buffer(struct ext2_xattr_handle *handle,
 			void *data = (entry->e_value_inum != 0) ?
 					0 : value_start + entry->e_value_offs;
 
-			hash = ext2fs_ext_attr_hash_entry(entry, data);
-			if (entry->e_hash != hash)
-				return EXT2_ET_BAD_EA_HASH;
+			err = ext2fs_ext_attr_hash_entry2(handle->fs, entry,
+							  data, &hash);
+			if (err)
+				return err;
+			if (entry->e_hash != hash) {
+				struct ext2_inode child;
+
+				/* Check whether this is an old Lustre-style
+				 * ea_inode reference.
+				 */
+				err = ext2fs_read_inode(handle->fs,
+							entry->e_value_inum,
+							&child);
+				if (err)
+					return err;
+				if (child.i_mtime != handle->ino ||
+				    child.i_generation != inode->i_generation)
+					return EXT2_ET_BAD_EA_HASH;
+			}
 		}
 
 		x++;
@@ -989,7 +1047,7 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 		start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 			inode->i_extra_isize + sizeof(__u32);
 
-		err = read_xattrs_from_buffer(handle,
+		err = read_xattrs_from_buffer(handle, inode,
 			(struct ext2_ext_attr_entry *) start, storage_size,
 					      start, &handle->count);
 		if (err)
@@ -1026,7 +1084,7 @@ read_ea_block:
 		storage_size = handle->fs->blocksize -
 			sizeof(struct ext2_ext_attr_header);
 		start = block_buf + sizeof(struct ext2_ext_attr_header);
-		err = read_xattrs_from_buffer(handle,
+		err = read_xattrs_from_buffer(handle, inode,
 			(struct ext2_ext_attr_entry *) start, storage_size,
 					      block_buf, &handle->count);
 		if (err)
-- 
2.13.2.725.g09c95d1e9-goog
