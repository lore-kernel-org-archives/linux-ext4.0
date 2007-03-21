From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH 1/2] e2fsprogs: allow more than 32000 subdirectories
Date: Wed, 21 Mar 2007 19:42:33 +0530
Message-ID: <1174486353.11843.12.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, tytso <tytso@mit.edu>,
	sct <sct@redhat.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:56334 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbXCUOLD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Mar 2007 10:11:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This patch includes the changes required to e2fsck to understand the nlink count changes made in the kernel. In pass2, while counting the links for a directory, if the link count exceeds 65000, its permanently set to EXT2_NLINK_MAXED (EXT2_LINK_MAX + 100). In pass4, when the counted and actual nlink counts are compared, e2fsck does not flag an error if counted links = EXT2_NLINK_MAXED and existing link count is 1. 

It also handles the case when a directory had more than 65000 subdirs and they were later deleted. The nlink count of such a directory remains 1. In pass4 if counted links are 2 and if existing nlink count = 1, e2fsck corrects the nlink count without displaying any errors. 

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>


Index: e2fsprogs-1.40/e2fsck/pass4.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/pass4.c
+++ e2fsprogs-1.40/e2fsck/pass4.c
@@ -145,7 +145,9 @@ void e2fsck_pass4(e2fsck_t ctx)
 			ext2fs_icount_fetch(ctx->inode_count, i,
 					    &link_counted);
 		}
-		if (link_counted != link_count) {
+		if (link_counted != link_count &&
+		    !(ext2fs_test_inode_bitmap(ctx->inode_dir_map, i) &&
+		    link_count == 1 && link_counted == EXT2_NLINK_MAXED)) {
 			e2fsck_read_inode(ctx, i, &inode, "pass4");
 			pctx.ino = i;
 			pctx.inode = &inode;
@@ -155,12 +157,37 @@ void e2fsck_pass4(e2fsck_t ctx)
 					    PR_4_INCONSISTENT_COUNT, &pctx);
 			}
 			pctx.num = link_counted;
-			if (fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx)) {
+			/* i_link_count was previously exceeded, but no longer
+			 * is, fix this but don't consider it an error */
+			if ((LINUX_S_ISDIR(inode.i_mode) && link_counted > 1 &&
+			     (inode.i_flags & EXT2_INDEX_FL) &&
+			     link_count == 1 && !(ctx->options & E2F_OPT_NO)) ||
+			     (fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx))) {
 				inode.i_links_count = link_counted;
 				e2fsck_write_inode(ctx, i, &inode, "pass4");
 			}
 		}
+		if (link_counted == EXT2_NLINK_MAXED)
+			ctx->fs_many_subdirs++;
 	}
+	if (ctx->fs_many_subdirs) {
+		if (!(fs->super->s_feature_ro_compat &
+		      EXT4_FEATURE_RO_COMPAT_DIR_NLINK) &&
+		    fix_problem(ctx, PR_4_FEATURE_DIR_NLINK, &pctx)) {
+			fs->super->s_feature_ro_compat |=
+				EXT4_FEATURE_RO_COMPAT_DIR_NLINK;
+			ext2fs_mark_super_dirty(fs);
+		}
+	} else if (!ctx->fs_many_subdirs &&
+	    (fs->super->s_feature_ro_compat &
+	      EXT4_FEATURE_RO_COMPAT_DIR_NLINK)) {
+		if (fs->flags & EXT2_FLAG_RW) {
+			fs->super->s_feature_ro_compat &=
+				~EXT4_FEATURE_RO_COMPAT_DIR_NLINK;
+			ext2fs_mark_super_dirty(fs);
+		}
+	}
+
 	ext2fs_free_icount(ctx->inode_link_info); ctx->inode_link_info = 0;
 	ext2fs_free_icount(ctx->inode_count); ctx->inode_count = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_bb_map);
Index: e2fsprogs-1.40/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.40/lib/ext2fs/ext2_fs.h
@@ -635,6 +635,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
 
 /*
Index: e2fsprogs-1.40/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40/lib/ext2fs/ext2fs.h
@@ -403,6 +403,9 @@ typedef struct ext2_struct_inode_scan *e
 
 typedef struct ext2_icount *ext2_icount_t;
 
+/* To handle the case when a directory has nlink = 1, but is empty. */
+#define EXT2_NLINK_MAXED	EXT2_LINK_MAX + 100
+
 /*
  * Flags for ext2fs_bmap
  */
@@ -460,7 +463,8 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT3_FEATURE_INCOMPAT_RECOVER)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
-					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
@@ -791,8 +795,12 @@ extern errcode_t ext2fs_create_icount(ex
 				      ext2_icount_t *ret);
 extern errcode_t ext2fs_icount_fetch(ext2_icount_t icount, ext2_ino_t ino,
 				     __u16 *ret);
+extern errcode_t ext2fs_icount_inc32(ext2_icount_t icount, ext2_ino_t ino,
+				     __u32 *ret, int is_dir);
 extern errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 					 __u16 *ret);
+extern errcode_t ext2fs_icount_dec32(ext2_icount_t icount, ext2_ino_t ino,
+				     __u32 *ret, int is_dir);
 extern errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
 					 __u16 *ret);
 extern errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
Index: e2fsprogs-1.40/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/pass2.c
+++ e2fsprogs-1.40/e2fsck/pass2.c
@@ -710,7 +710,7 @@ static int check_dir_block(ext2_filsys f
 	int			dot_state;
 	blk_t			block_nr = db->blk;
 	ext2_ino_t 		ino = db->ino;
-	__u16			links;
+	__u32			links;
 	struct check_dir_struct	*cd;
 	char 			*buf;
 	e2fsck_t		ctx;
@@ -1014,9 +1014,10 @@ static int check_dir_block(ext2_filsys f
 			dups_found++;
 		} else
 			dict_alloc_insert(&de_dict, dirent, dirent);
-		
-		ext2fs_icount_increment(ctx->inode_count, dirent->inode,
-					&links);
+
+		ext2fs_icount_inc32(ctx->inode_count, dirent->inode, &links,
+				    ext2fs_test_inode_bitmap(ctx->inode_dir_map,
+							     dirent->inode));
 		if (links > 1)
 			ctx->fs_links_count++;
 		ctx->fs_total_count++;
Index: e2fsprogs-1.40/lib/ext2fs/icount.c
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/icount.c
+++ e2fsprogs-1.40/lib/ext2fs/icount.c
@@ -321,8 +321,8 @@ errcode_t ext2fs_icount_fetch(ext2_icoun
 	return 0;
 }
 
-errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
-				  __u16 *ret)
+errcode_t ext2fs_icount_inc32(ext2_icount_t icount, ext2_ino_t ino,
+			      __u32 *ret, int is_dir)
 {
 	struct ext2_icount_el	*el;
 
@@ -381,14 +381,29 @@ errcode_t ext2fs_icount_increment(ext2_i
 	}
 	if (icount->multiple)
 		ext2fs_mark_inode_bitmap(icount->multiple, ino);
+	if (el->count >= EXT2_LINK_MAX && is_dir)
+		el->count = EXT2_NLINK_MAXED;
 	if (ret)
 		*ret = el->count;
 	return 0;
 }
 
-errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
+errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 				  __u16 *ret)
 {
+	__u32 links;
+	errcode_t err;
+
+	err = ext2fs_icount_inc32(icount, ino, &links, 0);
+	if (ret)
+		*ret = links;
+
+	return err;
+}
+
+errcode_t ext2fs_icount_dec32(ext2_icount_t icount, ext2_ino_t ino,
+			      __u32 *ret, int is_dir)
+{
 	struct ext2_icount_el	*el;
 
 	if (!ino || (ino > icount->num_inodes))
@@ -429,6 +444,19 @@ errcode_t ext2fs_icount_decrement(ext2_i
 	return 0;
 }
 
+errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
+				  __u16 *ret)
+{
+	__u32 links;
+	errcode_t err;
+
+	err = ext2fs_icount_dec32(icount, ino, &links, 0);
+	if (ret)
+		*ret = links;
+
+	return err;
+}
+
 errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
 			      __u16 count)
 {
Index: e2fsprogs-1.40/e2fsck/e2fsck.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/e2fsck.c
+++ e2fsprogs-1.40/e2fsck/e2fsck.c
@@ -150,6 +150,7 @@ errcode_t e2fsck_reset_context(e2fsck_t 
 	ctx->fs_tind_count = 0;
 	ctx->fs_fragmented = 0;
 	ctx->large_files = 0;
+	ctx->fs_many_subdirs = 0;
 
 	/* Reset the superblock to the user's requested value */
 	ctx->superblock = ctx->use_superblock;
Index: e2fsprogs-1.40/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.40/e2fsck/e2fsck.h
@@ -327,6 +327,7 @@ struct e2fsck_struct {
 	__u32 large_files;
 	__u32 fs_ext_attr_inodes;
 	__u32 fs_ext_attr_blocks;
+	__u32 fs_many_subdirs;
 
 	time_t now;
 
Index: e2fsprogs-1.40/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/problem.c
+++ e2fsprogs-1.40/e2fsck/problem.c
@@ -1366,6 +1366,12 @@ static struct e2fsck_problem problem_tab
 	  "They @s the same!\n"),
 	  PROMPT_NONE, 0 },
 
+	/* DIR_NLINK flag not set but dirs with > 65000 subdirs found */
+	{ PR_4_FEATURE_DIR_NLINK,
+	  N_("@f contains directories with > 65000 subdirs, but lacks "
+	  "DIR_NLINK flag in @S.\n"),
+	  PROMPT_FIX, 0 },
+
 	/* Pass 5 errors */
 		  
 	/* Pass 5: Checking group summary information */
Index: e2fsprogs-1.40/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/problem.h
+++ e2fsprogs-1.40/e2fsck/problem.h
@@ -821,6 +821,10 @@ struct problem_context {
 /* Inconsistent inode count information cached */
 #define PR_4_INCONSISTENT_COUNT	0x040004
 
+/* Directory with > EXT2_LINK_MAX subdirs found but
+ * EXT4_FEATURE_RO_COMPAT_DIR_NLINK flag is reset */
+#define PR_4_FEATURE_DIR_NLINK	0x040005
+
 /*
  * Pass 5 errors
  */

Thanks,
Kalpak Shah.
