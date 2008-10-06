From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH][9/15] e2fsprogs-ibadness-counter.patch
Date: Mon, 06 Oct 2008 16:01:19 +0530
Message-ID: <1223289079.4007.89.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_RHBmS6bnD5ui4ufOf3znSQ)"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:38310 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbYJFKce (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 06:32:34 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m96AWWaH004424
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 10:32:32 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8B00M01BS36U00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 06 Oct 2008 18:32:32 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_RHBmS6bnD5ui4ufOf3znSQ)
Content-type: text/plain
Content-transfer-encoding: 7BIT

The present e2fsck code checks the inode, per field basis. It doesn't
take into consideration to total sanity of the inode. This may cause
e2fsck turning a garbage inode into an apparently sane inode ("It is a
vessel of fertilizer, and none may abide its strength.").

The following patch adds a heuristics to detect the degree of badness of
an inode. icount mechanism is used to keep track of the badness of every
inode. The badness is increased as various fields in inode are found to
be corrupt. Badness above a certain threshold value results in deletion
of the inode. The default threshold value is 7, it can be specified to
e2fsck using "-E inode_badness_threshold=<value>"

This can avoid lengthy pass1b shared block processing, where a corrupt
chunk of the inode table has resulted in a bunch of garbage inodes
suddenly having shared blocks with a lot of good inodes (or each other).

Signed-off-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: Girish Shilamkar <girish.shilamkar@sun.com>


--Boundary_(ID_RHBmS6bnD5ui4ufOf3znSQ)
Content-type: text/x-patch; charset=UTF-8; name=e2fsprogs-ibadness-counter.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-ibadness-counter.patch

The present e2fsck code checks the inode, per field basis. It doesn't
take into consideration to total sanity of the inode. This may cause
e2fsck turning a garbage inode into an apparently sane inode ("It is a
vessel of fertilizer, and none may abide its strength.").

The following patch adds a heuristics to detect the degree of badness of
an inode. icount mechanism is used to keep track of the badness of every
inode. The badness is increased as various fields in inode are found to
be corrupt. Badness above a certain threshold value results in deletion
of the inode. The default threshold value is 7, it can be specified to
e2fsck using "-E inode_badness_threshold=<value>"

This can avoid lengthy pass1b shared block processing, where a corrupt
chunk of the inode table has resulted in a bunch of garbage inodes
suddenly having shared blocks with a lot of good inodes (or each other).

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Girish Shilamkar <girish@clusterfs.com>

Index: e2fsprogs-1.41.1/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.41.1/e2fsck/e2fsck.h
@@ -11,6 +11,7 @@
 
 #include <stdio.h>
 #include <string.h>
+#include <stddef.h>
 #ifdef HAVE_UNISTD_H
 #include <unistd.h>
 #endif
@@ -198,6 +199,18 @@ typedef enum {
 	E2F_CLONE_ZERO
 } clone_opt_t;
 
+#define EXT4_FITS_IN_INODE(ext4_inode, einode, field)	\
+	((offsetof(typeof(*ext4_inode), field) +	\
+	  sizeof(ext4_inode->field))			\
+	<= (EXT2_GOOD_OLD_INODE_SIZE +			\
+	    (einode)->i_extra_isize))			\
+
+#define BADNESS_NORMAL 		1
+#define BADNESS_HIGH		2
+#define BADNESS_THRESHOLD	8
+#define BADNESS_BAD_MODE	100
+#define BADNESS_LARGE_FILE 	2199023255552ULL
+
 /*
  * Define the extended attribute refcount structure
  */
@@ -234,7 +247,6 @@ struct e2fsck_struct {
 			unsigned long max);
 
 	ext2fs_inode_bitmap inode_used_map; /* Inodes which are in use */
-	ext2fs_inode_bitmap inode_bad_map; /* Inodes which are bad somehow */
 	ext2fs_inode_bitmap inode_dir_map; /* Inodes which are directories */
 	ext2fs_inode_bitmap inode_bb_map; /* Inodes which are in bad blocks */
 	ext2fs_inode_bitmap inode_imagic_map; /* AFS inodes */
@@ -249,6 +261,8 @@ struct e2fsck_struct {
 	 */
 	ext2_icount_t	inode_count;
 	ext2_icount_t inode_link_info;
+	ext2_icount_t inode_badness;
+	int inode_badness_threshold;
 
 	ext2_refcount_t	refcount;
 	ext2_refcount_t refcount_extra;
@@ -349,6 +363,7 @@ struct e2fsck_struct {
 	/* misc fields */
 	time_t now;
 	time_t time_fudge;	/* For working around buggy init scripts */
+	time_t now_tolerance_val;
 	int ext_attr_ver;
 	shared_opt_t shared;
 	clone_opt_t clone;
@@ -465,6 +480,8 @@ extern int e2fsck_pass1_check_symlink(ex
 extern void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 			       struct ext2_inode *inode, int restart_flag,
 			       const char *source);
+extern void e2fsck_mark_inode_bad(e2fsck_t ctx, ino_t ino, int count);
+extern int is_inode_bad(e2fsck_t ctx, ino_t ino);
 
 /* pass2.c */
 extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
Index: e2fsprogs-1.41.1/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/pass1.c
+++ e2fsprogs-1.41.1/e2fsck/pass1.c
@@ -20,7 +20,8 @@
  * 	- A bitmap of which inodes are in use.		(inode_used_map)
  * 	- A bitmap of which inodes are directories.	(inode_dir_map)
  * 	- A bitmap of which inodes are regular files.	(inode_reg_map)
- * 	- A bitmap of which inodes have bad fields.	(inode_bad_map)
+ * 	- An icount mechanism is used to keep track of
+ *	  inodes with bad fields and its badness	(ctx->inode_badness)
  * 	- A bitmap of which inodes are in bad blocks.	(inode_bb_map)
  * 	- A bitmap of which inodes are imagic inodes.	(inode_imagic_map)
  *	- A bitmap of which inodes need to be expanded  (expand_eisize_map)
@@ -67,7 +68,6 @@ static void check_blocks(e2fsck_t ctx, s
 static void mark_table_blocks(e2fsck_t ctx);
 static void alloc_bb_map(e2fsck_t ctx);
 static void alloc_imagic_map(e2fsck_t ctx);
-static void mark_inode_bad(e2fsck_t ctx, ino_t ino);
 static void handle_fs_bad_blocks(e2fsck_t ctx);
 static void process_inodes(e2fsck_t ctx, char *block_buf);
 static EXT2_QSORT_TYPE process_inode_cmp(const void *a, const void *b);
@@ -241,6 +241,7 @@ static void check_immutable(e2fsck_t ctx
 	if (!(pctx->inode->i_flags & BAD_SPECIAL_FLAGS))
 		return;
 
+	e2fsck_mark_inode_bad(ctx, pctx->ino, BADNESS_NORMAL);
 	if (!fix_problem(ctx, PR_1_SET_IMMUTABLE, pctx))
 		return;
 
@@ -259,6 +260,7 @@ static void check_size(e2fsck_t ctx, str
 	if ((inode->i_size == 0) && (inode->i_size_high == 0))
 		return;
 
+	e2fsck_mark_inode_bad(ctx, pctx->ino, BADNESS_NORMAL);
 	if (!fix_problem(ctx, PR_1_SET_NONZSIZE, pctx))
 		return;
 
@@ -373,6 +375,7 @@ static void check_inode_extra_space(e2fs
 	 */
 	if (inode->i_extra_isize &&
 	    (inode->i_extra_isize < min || inode->i_extra_isize > max)) {
+		e2fsck_mark_inode_bad(ctx, pctx->ino, BADNESS_NORMAL);
 		if (!fix_problem(ctx, PR_1_EXTRA_ISIZE, pctx))
 			return;
 		inode->i_extra_isize = ctx->want_extra_isize;
@@ -466,6 +469,7 @@ static void check_is_really_dir(e2fsck_t
 	    (rec_len % 4))
 		return;
 
+	e2fsck_mark_inode_bad(ctx, pctx->ino, BADNESS_NORMAL);
 	if (fix_problem(ctx, PR_1_TREAT_AS_DIRECTORY, pctx)) {
 		inode->i_mode = (inode->i_mode & 07777) | LINUX_S_IFDIR;
 		e2fsck_write_inode_full(ctx, pctx->ino, inode,
@@ -662,6 +666,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t	ino;
 	struct ext2_inode *inode;
+	struct ext2_inode_large *inode_large;
 	ext2_inode_scan	scan;
 	char		*block_buf;
 #ifdef RESOURCE_TRACK
@@ -907,14 +912,17 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ehp = inode->i_block;
 #endif
 			if ((ext2fs_extent_header_verify(ehp,
-					 sizeof(inode->i_block)) == 0) &&
-			    (fix_problem(ctx, PR_1_UNSET_EXTENT_FL, &pctx))) {
-				inode->i_flags |= EXT4_EXTENTS_FL;
+					 sizeof(inode->i_block)) == 0)) {
+				if (fix_problem(ctx, PR_1_UNSET_EXTENT_FL, &pctx)) {
+					e2fsck_mark_inode_bad(ctx, ino,
+							      BADNESS_NORMAL);
+					inode->i_flags |= EXT4_EXTENTS_FL;
 #ifdef WORDS_BIGENDIAN
-				memcpy(inode->i_block, tmp_block,
-				       sizeof(inode->i_block));
+					memcpy(inode->i_block, tmp_block,
+					       sizeof(inode->i_block));
 #endif
-				e2fsck_write_inode(ctx, ino, inode, "pass1");
+					e2fsck_write_inode(ctx, ino, inode, "pass1");
+				}
 			}
 		}
 
@@ -978,6 +986,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 					e2fsck_write_inode(ctx, ino, inode,
 							   "pass1");
 				}
+				e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 			}
 		} else if (ino == EXT2_JOURNAL_INO) {
 			ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
@@ -1084,6 +1093,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				inode->i_dtime = 0;
 				e2fsck_write_inode(ctx, ino, inode, "pass1");
 			}
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		}
 
 		ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
@@ -1096,14 +1106,15 @@ void e2fsck_pass1(e2fsck_t ctx)
 			frag = fsize = 0;
 		}
 
+		/* Fixed in pass2, e2fsck_process_bad_inode(). */
 		if (inode->i_faddr || frag || fsize ||
 		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
-			mark_inode_bad(ctx, ino);
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
 		    !(fs->super->s_feature_ro_compat &
 		      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
 		    (inode->osd2.linux2.l_i_blocks_hi != 0))
-			mark_inode_bad(ctx, ino);
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		if (inode->i_flags & EXT2_IMAGIC_FL) {
 			if (imagic_fs) {
 				if (!ctx->inode_imagic_map)
@@ -1116,6 +1127,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 					e2fsck_write_inode(ctx, ino,
 							   inode, "pass1");
 				}
+				e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 			}
 		}
 
@@ -1171,8 +1183,42 @@ void e2fsck_pass1(e2fsck_t ctx)
 			check_immutable(ctx, &pctx);
 			check_size(ctx, &pctx);
 			ctx->fs_sockets_count++;
-		} else
-			mark_inode_bad(ctx, ino);
+		} else {
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
+		}
+
+		if (inode->i_atime > ctx->now + ctx->now_tolerance_val ||
+		    inode->i_mtime > ctx->now + ctx->now_tolerance_val)
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
+
+		if (inode->i_ctime < sb->s_mkfs_time ||
+		    inode->i_ctime > ctx->now + ctx->now_tolerance_val)
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_HIGH);
+
+		if (EXT4_FITS_IN_INODE(inode_large,
+		    (struct ext2_inode_large *)inode, i_crtime)) {
+			if (((struct ext2_inode_large *)inode)->i_crtime <
+			      sb->s_mkfs_time ||
+			    ((struct ext2_inode_large *)inode)->i_crtime >
+			      ctx->now + ctx->now_tolerance_val) {
+				e2fsck_mark_inode_bad(ctx, ino, BADNESS_HIGH);
+			}
+		}
+
+		/* Is it a regular file */
+		if ((LINUX_S_ISREG(inode->i_mode)) &&
+		   /* File size > 2TB */
+		    ((((long long)inode->i_size_high << 32) +
+		      inode->i_size) > BADNESS_LARGE_FILE) &&
+		    /* fs does not have huge file feature */
+		    ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
+		     !(fs->super->s_feature_ro_compat &
+			     EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+		     /* inode does not have enough blocks for size */
+		     (inode->osd2.linux2.l_i_blocks_hi != 0))) {
+			       e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
+		}
+
 		if (!(inode->i_flags & EXT4_EXTENTS_FL)) {
 			if (inode->i_block[EXT2_IND_BLOCK])
 				ctx->fs_ind_count++;
@@ -1389,29 +1435,27 @@ static EXT2_QSORT_TYPE process_inode_cmp
 }
 
 /*
- * Mark an inode as being bad in some what
+ * Mark an inode as being bad and increment its badness counter.
  */
-static void mark_inode_bad(e2fsck_t ctx, ino_t ino)
+void e2fsck_mark_inode_bad(e2fsck_t ctx, ino_t ino, int count)
 {
-	struct		problem_context pctx;
+	struct  problem_context pctx;
+	__u16 result;
 
-	if (!ctx->inode_bad_map) {
+	if (!ctx->inode_badness) {
 		clear_problem_context(&pctx);
-
-		pctx.errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
-			    _("bad inode map"), &ctx->inode_bad_map);
+		pctx.errcode = ext2fs_create_icount2(ctx->fs, 0, 0, NULL,
+						     &ctx->inode_badness);
 		if (pctx.errcode) {
-			pctx.num = 3;
-			fix_problem(ctx, PR_1_ALLOCATE_IBITMAP_ERROR, &pctx);
-			/* Should never get here */
+			fix_problem(ctx, PR_1_ALLOCATE_ICOUNT, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
 			return;
 		}
 	}
-	ext2fs_mark_inode_bitmap(ctx->inode_bad_map, ino);
+	ext2fs_icount_fetch(ctx->inode_badness, ino, &result);
+	ext2fs_icount_store(ctx->inode_badness, ino, count + result);
 }
 
-
 /*
  * This procedure will allocate the inode "bb" (badblock) map table
  */
@@ -1566,7 +1610,8 @@ static int check_ext_attr(e2fsck_t ctx, 
 	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) ||
 	    (blk < fs->super->s_first_data_block) ||
 	    (blk >= fs->super->s_blocks_count)) {
-		mark_inode_bad(ctx, ino);
+		/* Fixed in pass2, e2fsck_process_bad_inode(). */
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		return 0;
 	}
 
@@ -1732,9 +1777,11 @@ static int handle_htree(e2fsck_t ctx, st
 
 	if ((!LINUX_S_ISDIR(inode->i_mode) &&
 	     fix_problem(ctx, PR_1_HTREE_NODIR, pctx)) ||
-	    (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) &&
-	     fix_problem(ctx, PR_1_HTREE_SET, pctx)))
-		return 1;
+	    (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX))) {
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
+		if (fix_problem(ctx, PR_1_HTREE_SET, pctx))
+			return 1;
+	}
 
 	pctx->errcode = ext2fs_bmap(fs, ino, inode, 0, 0, 0, &blk);
 
@@ -1742,6 +1789,7 @@ static int handle_htree(e2fsck_t ctx, st
 	    (blk == 0) ||
 	    (blk < fs->super->s_first_data_block) ||
 	    (blk >= fs->super->s_blocks_count)) {
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		if (fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
 			return 1;
 		else
@@ -1749,8 +1797,11 @@ static int handle_htree(e2fsck_t ctx, st
 	}
 
 	retval = io_channel_read_blk(fs->io, blk, 1, block_buf);
-	if (retval && fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
-		return 1;
+	if (retval) {
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
+		if (fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
+			return 1;
+	}
 
 	/* XXX should check that beginning matches a directory */
 	root = (struct ext2_dx_root_info *) (block_buf + 24);
@@ -1791,8 +1842,8 @@ void e2fsck_clear_inode(e2fsck_t ctx, ex
 	ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
 	if (ctx->inode_reg_map)
 		ext2fs_unmark_inode_bitmap(ctx->inode_reg_map, ino);
-	if (ctx->inode_bad_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
+	if (ctx->inode_badness)
+		ext2fs_icount_store(ctx->inode_badness, ino, 0);
 
 	/*
 	 * If the inode was partially accounted for before processing
@@ -1863,6 +1914,11 @@ static void scan_extent_node(e2fsck_t ct
 			problem = PR_1_EXTENT_ENDS_BEYOND;
 
 		if (problem) {
+			/* To ensure that extent is in inode */
+			if (info.curr_level == 0)
+				e2fsck_mark_inode_bad(ctx, pctx->ino,
+						      BADNESS_HIGH);
+
 			pctx->blk = extent.e_pblk;
 			pctx->blk2 = extent.e_lblk;
 			pctx->num = extent.e_len;
@@ -2031,6 +2087,7 @@ static void check_blocks(e2fsck_t ctx, s
 				inode->i_flags &= ~EXT2_COMPRBLK_FL;
 				dirty_inode++;
 			}
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		}
 	}
 
@@ -2105,6 +2162,11 @@ static void check_blocks(e2fsck_t ctx, s
 			ctx->fs_directory_count--;
 			return;
 		}
+		/*
+		 * The mode might be in-correct. Increasing the badness by
+		 * small amount won't hurt much.
+		 */
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 	}
 
 	if (!(fs->super->s_feature_ro_compat &
@@ -2157,6 +2219,7 @@ static void check_blocks(e2fsck_t ctx, s
 				inode->i_size_high = pctx->num >> 32;
 			dirty_inode++;
 		}
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		pctx->num = 0;
 	}
 	if (LINUX_S_ISREG(inode->i_mode) &&
@@ -2173,6 +2236,7 @@ static void check_blocks(e2fsck_t ctx, s
 			inode->osd2.linux2.l_i_blocks_hi = 0;
 			dirty_inode++;
 		}
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		pctx->num = 0;
 	}
 out:
@@ -2332,8 +2396,10 @@ static int process_block(ext2_filsys fs,
 		problem = PR_1_TOOBIG_SYMLINK;
 
 	if (blk < fs->super->s_first_data_block ||
-	    blk >= fs->super->s_blocks_count)
+	    blk >= fs->super->s_blocks_count) {
 		problem = PR_1_ILLEGAL_BLOCK_NUM;
+		e2fsck_mark_inode_bad(ctx, pctx->ino, BADNESS_NORMAL);
+	}
 
 	if (problem) {
 		p->num_illegal_blocks++;
Index: e2fsprogs-1.41.1/e2fsck/pass4.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/pass4.c
+++ e2fsprogs-1.41.1/e2fsck/pass4.c
@@ -181,6 +181,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 	}
 	ext2fs_free_icount(ctx->inode_link_info); ctx->inode_link_info = 0;
 	ext2fs_free_icount(ctx->inode_count); ctx->inode_count = 0;
+	ext2fs_free_icount(ctx->inode_badness); ctx->inode_badness = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_bb_map);
 	ctx->inode_bb_map = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_imagic_map);
Index: e2fsprogs-1.41.1/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/pass2.c
+++ e2fsprogs-1.41.1/e2fsck/pass2.c
@@ -33,11 +33,10 @@
  * Pass 2 relies on the following information from previous passes:
  * 	- The directory information collected in pass 1.
  * 	- The inode_used_map bitmap
- * 	- The inode_bad_map bitmap
+ * 	- The inode_badness bitmap
  * 	- The inode_dir_map bitmap
  *
  * Pass 2 frees the following data structures
- * 	- The inode_bad_map bitmap
  * 	- The inode_reg_map bitmap
  */
 
@@ -258,10 +257,6 @@ void e2fsck_pass2(e2fsck_t ctx)
 	ext2fs_free_mem(&buf);
 	ext2fs_free_dblist(fs->dblist);
 
-	if (ctx->inode_bad_map) {
-		ext2fs_free_inode_bitmap(ctx->inode_bad_map);
-		ctx->inode_bad_map = 0;
-	}
 	if (ctx->inode_reg_map) {
 		ext2fs_free_inode_bitmap(ctx->inode_reg_map);
 		ctx->inode_reg_map = 0;
@@ -494,6 +489,7 @@ static _INLINE_ int check_filetype(e2fsc
 {
 	int	filetype = dirent->name_len >> 8;
 	int	should_be = EXT2_FT_UNKNOWN;
+	__u16	result;
 	struct ext2_inode	inode;
 
 	if (!(ctx->fs->super->s_feature_incompat &
@@ -505,16 +501,18 @@ static _INLINE_ int check_filetype(e2fsc
 		return 1;
 	}
 
+	if (ctx->inode_badness)
+		ext2fs_icount_fetch(ctx->inode_badness, dirent->inode,
+				      &result);
+
 	if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, dirent->inode)) {
 		should_be = EXT2_FT_DIR;
 	} else if (ext2fs_test_inode_bitmap(ctx->inode_reg_map,
 					    dirent->inode)) {
 		should_be = EXT2_FT_REG_FILE;
-	} else if (ctx->inode_bad_map &&
-		   ext2fs_test_inode_bitmap(ctx->inode_bad_map,
-					    dirent->inode))
+	} else if (ctx->inode_badness && result >= BADNESS_BAD_MODE) {
 		should_be = 0;
-	else {
+	} else {
 		e2fsck_read_inode(ctx, dirent->inode, &inode,
 				  "check_filetype");
 		should_be = ext2_file_type(inode.i_mode);
@@ -965,12 +963,10 @@ out_htree:
 		 * (We wait until now so that we can display the
 		 * pathname to the user.)
 		 */
-		if (ctx->inode_bad_map &&
-		    ext2fs_test_inode_bitmap(ctx->inode_bad_map,
-					     dirent->inode)) {
-			if (e2fsck_process_bad_inode(ctx, ino,
-						     dirent->inode,
-						     buf + fs->blocksize)) {
+		if ((ctx->inode_badness) &&
+		    ext2fs_icount_is_set(ctx->inode_badness, dirent->inode)) {
+			if (e2fsck_process_bad_inode(ctx, ino, dirent->inode,
+						buf + fs->blocksize)) {
 				dirent->inode = 0;
 				dir_modified++;
 				goto next;
@@ -1189,9 +1185,17 @@ static void deallocate_inode(e2fsck_t ct
 	struct ext2_inode	inode;
 	struct problem_context	pctx;
 	__u32			count;
+	int extent_fs = 0;
 
 	e2fsck_read_inode(ctx, ino, &inode, "deallocate_inode");
+	/* ext2fs_block_iterate2() depends on the extents flags */
+	if (inode.i_flags & EXT4_EXTENTS_FL)
+		extent_fs = 1;
 	e2fsck_clear_inode(ctx, ino, &inode, 0, "deallocate_inode");
+	if (extent_fs) {
+		inode.i_flags |= EXT4_EXTENTS_FL;
+	        e2fsck_write_inode(ctx, ino, &inode, "deallocate_inode");
+	}
 	clear_problem_context(&pctx);
 	pctx.ino = ino;
 
@@ -1218,6 +1222,8 @@ static void deallocate_inode(e2fsck_t ct
 		if (count == 0) {
 			ext2fs_unmark_block_bitmap(ctx->block_found_map,
 						   inode.i_file_acl);
+		if (ctx->inode_badness)
+			ext2fs_icount_store(ctx->inode_badness, ino, 0);
 			ext2fs_block_alloc_stats(fs, inode.i_file_acl, -1);
 		}
 		inode.i_file_acl = 0;
@@ -1263,8 +1269,11 @@ extern int e2fsck_process_bad_inode(e2fs
 	int			not_fixed = 0;
 	unsigned char		*frag, *fsize;
 	struct problem_context	pctx;
-	int	problem = 0;
+	int			problem = 0;
+	__u16			badness;
 
+	if (ctx->inode_badness)
+		ext2fs_icount_fetch(ctx->inode_badness, ino, &badness);
 	e2fsck_read_inode(ctx, ino, &inode, "process_bad_inode");
 
 	clear_problem_context(&pctx);
@@ -1279,6 +1288,7 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
 	}
 
 	if (!LINUX_S_ISDIR(inode.i_mode) && !LINUX_S_ISREG(inode.i_mode) &&
@@ -1312,6 +1322,11 @@ extern int e2fsck_process_bad_inode(e2fs
 		} else
 			not_fixed++;
 		problem = 0;
+		/*
+		 * A high value is associated with bad mode in order to detect
+		 * that mode was corrupt in check_filetype()
+		 */
+		badness += BADNESS_BAD_MODE;
 	}
 
 	if (inode.i_faddr) {
@@ -1320,6 +1335,7 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
 	}
 
 	switch (fs->super->s_creator_os) {
@@ -1337,6 +1353,7 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
 		pctx.num = 0;
 	}
 	if (fsize && *fsize) {
@@ -1346,9 +1363,26 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
 		pctx.num = 0;
 	}
 
+	/* In pass1 these conditions were used to mark inode bad so that
+	 * it calls e2fsck_process_bad_inode and make an extensive check
+	 * plus prompt for action to be taken. To compensate for badness
+	 * incremented in pass1 by this condition, decrease it.
+	 */
+	if ((inode.i_faddr || frag || fsize ||
+	     (LINUX_S_ISDIR(inode.i_mode) && inode.i_dir_acl)) ||
+	    (inode.i_file_acl &&
+	     (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) ||
+	      (inode.i_file_acl < fs->super->s_first_data_block) ||
+	      (inode.i_file_acl >= fs->super->s_blocks_count)))) {
+		/* badness can be 0 if called from pass4. */
+		if (badness)
+			badness -= BADNESS_NORMAL;
+	}
+
 	if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
 	    !(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
@@ -1358,6 +1392,8 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode.osd2.linux2.l_i_blocks_hi = 0;
 			inode_modified++;
 		}
+		/* Badness was increased in pass1 for this condition */
+		/* badness += BADNESS_NORMAL; */
 	}
 
 	if (inode.i_file_acl &&
@@ -1368,6 +1404,7 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
 	}
 	if (inode.i_dir_acl &&
 	    LINUX_S_ISDIR(inode.i_mode)) {
@@ -1376,12 +1413,29 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
+	}
+
+	/*
+	 * The high value due to BADNESS_BAD_MODE should not delete the inode.
+	 */
+	if (ctx->inode_badness &&
+	    (badness - ((badness >= BADNESS_BAD_MODE) ? BADNESS_BAD_MODE : 0))>=
+			ctx->inode_badness_threshold) {
+		pctx.num = badness;
+		if (fix_problem(ctx, PR_2_INODE_TOOBAD, &pctx)) {
+			deallocate_inode(ctx, ino, 0);
+			if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+				return 0;
+			return 1;
+		}
+		not_fixed++;
 	}
 
 	if (inode_modified)
 		e2fsck_write_inode(ctx, ino, &inode, "process_bad_inode");
-	if (!not_fixed && ctx->inode_bad_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
+	if (ctx->inode_badness)
+		ext2fs_icount_store(ctx->inode_badness, ino, 0);
 	return 0;
 }
 
Index: e2fsprogs-1.41.1/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/problem.c
+++ e2fsprogs-1.41.1/e2fsck/problem.c
@@ -1354,6 +1354,11 @@ static struct e2fsck_problem problem_tab
 	  N_("@i %N found in @g %g unused inodes area.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* Inode too bad */
+	{ PR_2_INODE_TOOBAD,
+	  N_("@i %i is badly corrupt (badness value = %N).  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
Index: e2fsprogs-1.41.1/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/problem.h
+++ e2fsprogs-1.41.1/e2fsck/problem.h
@@ -814,6 +814,9 @@ struct problem_context {
 /* Inode found in group unused inodes area */
 #define PR_2_INOREF_IN_UNUSED		0x020047
 
+/* Inode completely corrupt */
+#define PR_2_INODE_TOOBAD		0x020048
+
 /*
  * Pass 3 errors
  */
Index: e2fsprogs-1.41.1/lib/ext2fs/icount.c
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/icount.c
+++ e2fsprogs-1.41.1/lib/ext2fs/icount.c
@@ -467,6 +467,23 @@ static errcode_t get_inode_count(ext2_ic
 	return 0;
 }
 
+int ext2fs_icount_is_set(ext2_icount_t icount, ext2_ino_t ino)
+{
+	__u16 result;
+
+	if (ext2fs_test_inode_bitmap(icount->single, ino))
+		return 1;
+	else if (icount->multiple) {
+		if (ext2fs_test_inode_bitmap(icount->multiple, ino))
+			return 1;
+		return 0;
+	}
+	ext2fs_icount_fetch(icount, ino, &result);
+	if (result)
+		return 1;
+	return 0;
+}
+
 errcode_t ext2fs_icount_validate(ext2_icount_t icount, FILE *out)
 {
 	errcode_t	ret = 0;
Index: e2fsprogs-1.41.1/e2fsck/pass1b.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/pass1b.c
+++ e2fsprogs-1.41.1/e2fsck/pass1b.c
@@ -612,8 +612,8 @@ static void delete_file(e2fsck_t ctx, ex
 						     block_buf, delete_file_block, &pb);
 	if (pctx.errcode)
 		fix_problem(ctx, PR_1B_BLOCK_ITERATE, &pctx);
-	if (ctx->inode_bad_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
+	if (ctx->inode_badness)
+		e2fsck_mark_inode_bad(ctx, ino, 0);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
 
 	/* Inode may have changed by block_iterate, so reread it */
Index: e2fsprogs-1.41.1/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/unix.c
+++ e2fsprogs-1.41.1/e2fsck/unix.c
@@ -650,6 +650,18 @@ static void parse_extended_opts(e2fsck_t
 				extended_usage++;
 				continue;
 			}
+		/* -E inode_badness_threshold=<value> */
+ 		} else if (strcmp(token, "inode_badness_threshold") == 0) {
+ 			if (!arg) {
+ 				extended_usage++;
+ 				continue;
+ 			}
+ 			ctx->inode_badness_threshold = strtoul(arg, &p, 0);
+			if (*p != '\0' || (ctx->inode_badness_threshold > 200)){
+				fprintf(stderr, _("Invalid badness value.\n"));
+				extended_usage++;
+				continue;
+			}
 		} else {
 			fprintf(stderr, _("Unknown extended option: %s\n"),
 				token);
@@ -668,6 +680,7 @@ static void parse_extended_opts(e2fsck_t
 		fputs(("\tshared=<preserve|lost+found|delete>\n"), stderr);
 		fputs(("\tclone=<dup|zero>\n"), stderr);
 		fputs(("\texpand_extra_isize\n"), stderr);
+		fputs(("\tinode_badness_threhold=(value)\n"), stderr);
 		fputc('\n', stderr);
 		exit(1);
 	}
@@ -732,6 +745,9 @@ static errcode_t PRS(int argc, char *arg
 	profile_init(config_fn, &ctx->profile);
 	initialize_profile_options(ctx);
 
+	ctx->inode_badness_threshold = BADNESS_THRESHOLD;
+	ctx->now_tolerance_val = 172800; /* Two days */
+
 	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
 		switch (c) {
 		case 'C':
Index: e2fsprogs-1.41.1/e2fsck/e2fsck.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/e2fsck.c
+++ e2fsprogs-1.41.1/e2fsck/e2fsck.c
@@ -107,10 +107,6 @@ errcode_t e2fsck_reset_context(e2fsck_t 
 		ext2fs_free_inode_bitmap(ctx->inode_bb_map);
 		ctx->inode_bb_map = 0;
 	}
-	if (ctx->inode_bad_map) {
-		ext2fs_free_inode_bitmap(ctx->inode_bad_map);
-		ctx->inode_bad_map = 0;
-	}
 	if (ctx->inode_imagic_map) {
 		ext2fs_free_inode_bitmap(ctx->inode_imagic_map);
 		ctx->inode_imagic_map = 0;
Index: e2fsprogs-1.41.1/e2fsck/e2fsck.8.in
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/e2fsck.8.in
+++ e2fsprogs-1.41.1/e2fsck/e2fsck.8.in
@@ -203,6 +203,13 @@ Set the version of the extended attribut
 will require while checking the filesystem.  The version number may 
 be 1 or 2.  The default extended attribute version format is 2.
 .TP
+.BI inode_badness_threshold= threshold_value
+A badness counter is associated with every inode, which determines the degree
+of inode corruption. Each error found in the inode will increase the badness by
+1 or 2, and inodes with a badness at or above
+.I threshold_value will be prompted for deletion. The default
+.I threshold_value is 7.
+.TP
 .BI fragcheck
 During pass 1, print a detailed report of any discontiguous blocks for
 files in the filesystem.
Index: e2fsprogs-1.41.1/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.41.1/lib/ext2fs/ext2fs.h
@@ -974,6 +974,7 @@ extern errcode_t ext2fs_initialize(const
 
 /* icount.c */
 extern void ext2fs_free_icount(ext2_icount_t icount);
+extern int ext2fs_icount_is_set(ext2_icount_t icount, ext2_ino_t ino);
 extern errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 					  int flags, ext2_icount_t *ret);
 extern errcode_t ext2fs_create_icount2(ext2_filsys fs, int flags,
Index: e2fsprogs-1.41.1/tests/f_messy_inode/expect.1
===================================================================
--- e2fsprogs-1.41.1.orig/tests/f_messy_inode/expect.1
+++ e2fsprogs-1.41.1/tests/f_messy_inode/expect.1
@@ -20,19 +20,21 @@ Pass 2: Checking directory structure
 i_file_acl for inode 14 (/MAKEDEV) is 4294901760, should be zero.
 Clear? yes
 
+Inode 14 is badly corrupt (badness value = 13).  Clear? yes
+
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 Block bitmap differences:  -(43--49)
 Fix? yes
 
-Free blocks count wrong for group #0 (68, counted=75).
+Free blocks count wrong for group #0 (70, counted=77).
 Fix? yes
 
-Free blocks count wrong (68, counted=75).
+Free blocks count wrong (70, counted=77).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 29/32 files (3.4% non-contiguous), 25/100 blocks
+test_filesys: 28/32 files (3.6% non-contiguous), 23/100 blocks
 Exit status is 1
Index: e2fsprogs-1.41.1/tests/f_messy_inode/expect.2
===================================================================
--- e2fsprogs-1.41.1.orig/tests/f_messy_inode/expect.2
+++ e2fsprogs-1.41.1/tests/f_messy_inode/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 29/32 files (0.0% non-contiguous), 25/100 blocks
+test_filesys: 28/32 files (0.0% non-contiguous), 23/100 blocks
 Exit status is 0

--Boundary_(ID_RHBmS6bnD5ui4ufOf3znSQ)--
