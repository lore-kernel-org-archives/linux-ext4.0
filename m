From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][15/28] e2fsprogs-ibadness-counter.patch
Date: Sat, 02 Feb 2008 01:41:00 -0700
Message-ID: <20080202084100.GP31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58429 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbYBBIlE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:41:04 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128f49U016635
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:41:04 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00A01RU56300@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:41:04 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


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

Index: e2fsprogs-1.40.4/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.40.4/e2fsck/e2fsck.h
@@ -11,6 +11,7 @@
 
 #include <stdio.h>
 #include <string.h>
+#include <stddef.h>
 #ifdef HAVE_UNISTD_H
 #include <unistd.h>
 #endif
@@ -195,6 +196,18 @@ typedef enum {
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
@@ -229,7 +242,6 @@ struct e2fsck_struct {
 			unsigned long max);
 
 	ext2fs_inode_bitmap inode_used_map; /* Inodes which are in use */
-	ext2fs_inode_bitmap inode_bad_map; /* Inodes which are bad somehow */
 	ext2fs_inode_bitmap inode_dir_map; /* Inodes which are directories */
 	ext2fs_inode_bitmap inode_bb_map; /* Inodes which are in bad blocks */
 	ext2fs_inode_bitmap inode_imagic_map; /* AFS inodes */
@@ -244,6 +256,8 @@ struct e2fsck_struct {
 	 */
 	ext2_icount_t	inode_count;
 	ext2_icount_t inode_link_info;
+	ext2_icount_t inode_badness;
+	int inode_badness_threshold;
 
 	ext2_refcount_t	refcount;
 	ext2_refcount_t refcount_extra;
@@ -344,6 +358,7 @@ struct e2fsck_struct {
 	/* misc fields */
 	time_t now;
 	time_t time_fudge;	/* For working around buggy init scripts */
+	time_t now_tolerance_val;
 	int ext_attr_ver;
         shared_opt_t shared;
         clone_opt_t clone;
@@ -454,6 +469,8 @@ extern int e2fsck_pass1_check_device_ino
 					   struct ext2_inode *inode);
 extern int e2fsck_pass1_check_symlink(ext2_filsys fs,
 				      struct ext2_inode *inode, char *buf);
+extern void e2fsck_mark_inode_bad(e2fsck_t ctx, ino_t ino, int count);
+extern int is_inode_bad(e2fsck_t ctx, ino_t ino);
 
 /* pass2.c */
 extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
Index: e2fsprogs-1.40.4/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40.4/e2fsck/pass1.c
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
@@ -68,7 +69,6 @@ static void check_blocks(e2fsck_t ctx, s
 static void mark_table_blocks(e2fsck_t ctx);
 static void alloc_bb_map(e2fsck_t ctx);
 static void alloc_imagic_map(e2fsck_t ctx);
-static void mark_inode_bad(e2fsck_t ctx, ino_t ino);
 static void handle_fs_bad_blocks(e2fsck_t ctx);
 static void process_inodes(e2fsck_t ctx, char *block_buf);
 static EXT2_QSORT_TYPE process_inode_cmp(const void *a, const void *b);
@@ -220,6 +220,7 @@ static void check_immutable(e2fsck_t ctx
 	if (!(pctx->inode->i_flags & BAD_SPECIAL_FLAGS))
 		return;
 
+	e2fsck_mark_inode_bad(ctx, pctx->ino, BADNESS_NORMAL);
 	if (!fix_problem(ctx, PR_1_SET_IMMUTABLE, pctx))
 		return;
 
@@ -238,6 +239,7 @@ static void check_size(e2fsck_t ctx, str
 	if ((inode->i_size == 0) && (inode->i_size_high == 0))
 		return;
 	
+	e2fsck_mark_inode_bad(ctx, pctx->ino, BADNESS_NORMAL);
 	if (!fix_problem(ctx, PR_1_SET_NONZSIZE, pctx))
 		return;
 	
@@ -352,6 +354,7 @@ static void check_inode_extra_space(e2fs
 	 */
 	if (inode->i_extra_isize &&
 	    (inode->i_extra_isize < min || inode->i_extra_isize > max)) {
+		e2fsck_mark_inode_bad(ctx, pctx->ino, BADNESS_NORMAL);
 		if (!fix_problem(ctx, PR_1_EXTRA_ISIZE, pctx))
 			return;
 		inode->i_extra_isize = ctx->want_extra_isize;
@@ -441,6 +444,7 @@ static void check_is_really_dir(e2fsck_t
 	    (dirent->rec_len % 4))
 		return;
 
+	e2fsck_mark_inode_bad(ctx, pctx->ino, BADNESS_NORMAL);
 	if (fix_problem(ctx, PR_1_TREAT_AS_DIRECTORY, pctx)) {
 		inode->i_mode = (inode->i_mode & 07777) | LINUX_S_IFDIR;
 		e2fsck_write_inode_full(ctx, pctx->ino, inode, 
@@ -637,6 +641,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t	ino;
 	struct ext2_inode *inode;
+	struct ext2_inode_large *inode_large;
 	ext2_inode_scan	scan;
 	char		*block_buf;
 #ifdef RESOURCE_TRACK
@@ -873,8 +878,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 							    ino, 0);
 					e2fsck_write_inode(ctx, ino, inode,
 							   "pass1");
+				} else {
+					e2fsck_mark_inode_bad(ctx, ino,
+							BADNESS_NORMAL);
 				}
-
 			}
 			/*
 			 * If dtime is set, offer to clear it.  mke2fs
@@ -891,6 +898,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 					e2fsck_write_inode(ctx, ino, inode,
 							   "pass1");
 				}
+				e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 			}
 		} else if (ino == EXT2_JOURNAL_INO) {
 			ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
@@ -997,6 +1005,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				inode->i_dtime = 0;
 				e2fsck_write_inode(ctx, ino, inode, "pass1");
 			}
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		}
 		
 		ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
@@ -1013,14 +1022,16 @@ void e2fsck_pass1(e2fsck_t ctx)
 			frag = fsize = 0;
 		}
 		
+		/* Fixed in pass2, e2fsck_process_bad_inode(). */
 		if (inode->i_faddr || frag || fsize ||
 		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
-			mark_inode_bad(ctx, ino);
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
+		/* Fixed in pass2, e2fsck_process_bad_inode(). */
 		if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
 		    !(fs->super->s_feature_ro_compat & 
 		      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
 		    (inode->osd2.linux2.l_i_blocks_hi != 0))
-			mark_inode_bad(ctx, ino);
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		if (inode->i_flags & EXT2_IMAGIC_FL) {
 			if (imagic_fs) {
 				if (!ctx->inode_imagic_map)
@@ -1033,6 +1044,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 					e2fsck_write_inode(ctx, ino,
 							   inode, "pass1");
 				}
+				e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 			}
 		}
 
@@ -1075,8 +1087,41 @@ void e2fsck_pass1(e2fsck_t ctx)
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
 
 		eh = (struct ext3_extent_header *)inode->i_block;
 		if ((inode->i_flags & EXT4_EXTENTS_FL)) {
@@ -1091,19 +1136,28 @@ void e2fsck_pass1(e2fsck_t ctx)
 					ext2fs_mark_super_dirty(fs);
 					extent_fs = 1;
 				}
-			} else if (fix_problem(ctx, PR_1_SET_EXTENT_FL, &pctx)){
-				inode->i_flags &= ~EXT4_EXTENTS_FL;
-				e2fsck_write_inode(ctx, ino, inode, "pass1");
-				goto check_ind_inode;
+			} else {
+				e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
+				if (fix_problem(ctx, PR_1_SET_EXTENT_FL,
+							&pctx)) {
+					inode->i_flags &= ~EXT4_EXTENTS_FL;
+					e2fsck_write_inode(ctx, ino,
+							   inode,"pass1");
+					goto check_ind_inode;
+				}
 			}
 		} else if (extent_fs &&
 			   (LINUX_S_ISREG(inode->i_mode) ||
 			    LINUX_S_ISDIR(inode->i_mode)) &&
 			   ext2fs_extent_header_verify(eh, EXT2_N_BLOCKS *
-						       sizeof(__u32)) == 0 &&
-			   fix_problem(ctx, PR_1_UNSET_EXTENT_FL, &pctx)) {
-			inode->i_flags |= EXT4_EXTENTS_FL;
-			e2fsck_write_inode(ctx, ino, inode, "pass1");
+						       sizeof(__u32)) == 0) {
+				if (fix_problem(ctx, PR_1_UNSET_EXTENT_FL,
+							&pctx)) {
+					inode->i_flags |= EXT4_EXTENTS_FL;
+					e2fsck_write_inode(ctx, ino, inode,
+							"pass1");
+				}
+				e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		}
 		if (extent_fs && inode->i_flags & EXT4_EXTENTS_FL) {
 			ctx->extent_files++;
@@ -1344,29 +1398,27 @@ static EXT2_QSORT_TYPE process_inode_cmp
 }
 
 /*
- * Mark an inode as being bad in some what
+ * Mark an inode as being bad and increment its badness counter.
  */
-static void mark_inode_bad(e2fsck_t ctx, ino_t ino)
+void e2fsck_mark_inode_bad(e2fsck_t ctx, ino_t ino, int count)
 {
-	struct		problem_context pctx;
-
-	if (!ctx->inode_bad_map) {
-		clear_problem_context(&pctx);
+	struct	problem_context pctx;
+	__u16 result;
 	
-		pctx.errcode = ext2fs_allocate_inode_bitmap(ctx->fs,
-			    _("bad inode map"), &ctx->inode_bad_map);
+	if (!ctx->inode_badness) {
+		clear_problem_context(&pctx);
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
@@ -1521,7 +1573,8 @@ static int check_ext_attr(e2fsck_t ctx, 
 	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) ||
 	    (blk < fs->super->s_first_data_block) ||
 	    (blk >= fs->super->s_blocks_count)) {
-		mark_inode_bad(ctx, ino);
+		/* Fixed in pass2, e2fsck_process_bad_inode(). */
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		return 0;
 	}
 
@@ -1701,21 +1754,28 @@ static int handle_htree(e2fsck_t ctx, st
 
 	if ((!LINUX_S_ISDIR(inode->i_mode) &&
 	     fix_problem(ctx, PR_1_HTREE_NODIR, pctx)) ||
-	    (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) &&
-	     fix_problem(ctx, PR_1_HTREE_SET, pctx)))
-		return 1;
+	    (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX))) {
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
+	   	if (fix_problem(ctx, PR_1_HTREE_SET, pctx))
+			return 1;
+	}
 
 	ext2fs_block_iterate2(fs, ino, BLOCK_FLAG_DATA_ONLY | BLOCK_FLAG_HOLE,
 			      block_buf, htree_blk_iter_cb, &blk);
 	if (((blk == 0) ||
 	     (blk < fs->super->s_first_data_block) ||
-	     (blk >= fs->super->s_blocks_count)) &&
-	    fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
-		return 1;
+	     (blk >= fs->super->s_blocks_count))) {
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
+		if (fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
+			return 1;
+	}
 
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
@@ -1785,6 +1845,9 @@ static int e2fsck_ind_block_verify(struc
 			bad++;
 	}
 
+	if (num_indir <= EXT2_N_BLOCKS)
+		e2fsck_mark_inode_bad(p->ctx, p->ino, bad);
+
 	if ((num_indir <= EXT2_N_BLOCKS && bad > 4) || bad > 8)
 		return PR_1_INDIRECT_BAD;
 
@@ -1828,6 +1891,10 @@ static int e2fsck_ext_block_verify(struc
 				pctx->blkcount = ex->ee_start;
 				pctx->num = ex->ee_len;
 				pctx->blk = ex->ee_block;
+				/* To ensure that extent is in inode */
+				if (eh->eh_max == 4)
+					e2fsck_mark_inode_bad(p->ctx, p->ino,
+							BADNESS_HIGH);
 				if (fix_problem(ctx, PR_1_EXTENT_BAD, pctx)) {
 					ext2fs_extent_remove(eh, ex);
 					i--; ex--; /* check next (moved) item */
@@ -1854,6 +1921,10 @@ static int e2fsck_ext_block_verify(struc
 				pctx->blkcount = ix->ei_leaf;;
 				pctx->num = i;
 				pctx->blk = ix->ei_block;
+				/* To ensure that extent_idx is in inode */
+				if (eh->eh_max == 4)
+					e2fsck_mark_inode_bad(p->ctx, p->ino,
+							BADNESS_HIGH);
 				if (fix_problem(ctx, PR_1_EXTENT_IDX_BAD,pctx)){
 					ext2fs_extent_index_remove(eh, ix);
 					i--; ix--; /* check next (moved) item */
@@ -1861,7 +1932,6 @@ static int e2fsck_ext_block_verify(struc
 					continue;
 				}
 			}
-
 			ix_prev = ix;
 		}
 	}
@@ -1916,6 +1986,7 @@ static void check_blocks(e2fsck_t ctx, s
 				inode->i_flags &= ~EXT2_COMPRBLK_FL;
 				dirty_inode++;
 			}
+			e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		}
 	}
 
@@ -1961,6 +2032,7 @@ static void check_blocks(e2fsck_t ctx, s
 		ext2fs_icount_store(ctx->inode_link_info, ino, 0);
 		inode->i_dtime = ctx->now;
 		dirty_inode++;
+		ext2fs_icount_store(ctx->inode_badness, ino, 0);
 		ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, ino);
 		ext2fs_unmark_inode_bitmap(ctx->inode_reg_map, ino);
 		ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
@@ -2000,6 +2072,11 @@ static void check_blocks(e2fsck_t ctx, s
 			ctx->fs_directory_count--;
 			goto out;
 		}
+		/*
+		 * The mode might be in-correct. Increasing the badness by
+		 * small amount won't hurt much.
+		 */
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 	}
 
 	pb.num_blocks *= (fs->blocksize / 512);
@@ -2039,6 +2116,7 @@ static void check_blocks(e2fsck_t ctx, s
 				inode->i_size_high = pctx->num >> 32;
 			dirty_inode++;
 		}
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		pctx->num = 0;
 	}
 	if (LINUX_S_ISREG(inode->i_mode) &&
@@ -2050,6 +2128,7 @@ static void check_blocks(e2fsck_t ctx, s
 			inode->i_blocks = pb.num_blocks;
 			dirty_inode++;
 		}
+		e2fsck_mark_inode_bad(ctx, ino, BADNESS_NORMAL);
 		pctx->num = 0;
 	}
 out:
Index: e2fsprogs-1.40.4/e2fsck/pass4.c
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/pass4.c
+++ e2fsprogs-1.40.4/e2fsck/pass4.c
@@ -185,6 +185,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 	}
 	ext2fs_free_icount(ctx->inode_link_info); ctx->inode_link_info = 0;
 	ext2fs_free_icount(ctx->inode_count); ctx->inode_count = 0;
+	ext2fs_free_icount(ctx->inode_badness); ctx->inode_badness = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_bb_map);
 	ctx->inode_bb_map = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_imagic_map);
Index: e2fsprogs-1.40.4/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/pass2.c
+++ e2fsprogs-1.40.4/e2fsck/pass2.c
@@ -251,10 +251,6 @@ void e2fsck_pass2(e2fsck_t ctx)
 	ext2fs_free_mem(&buf);
 	ext2fs_free_dblist(fs->dblist);
 
-	if (ctx->inode_bad_map) {
-		ext2fs_free_inode_bitmap(ctx->inode_bad_map);
-		ctx->inode_bad_map = 0;
-	}
 	if (ctx->inode_reg_map) {
 		ext2fs_free_inode_bitmap(ctx->inode_reg_map);
 		ctx->inode_reg_map = 0;
@@ -501,6 +497,7 @@ static _INLINE_ int check_filetype(e2fsc
 {
 	int	filetype = dirent->name_len >> 8;
 	int	should_be = EXT2_FT_UNKNOWN;
+	__u32	result;
 	struct ext2_inode	inode;
 
 	if (!(ctx->fs->super->s_feature_incompat &
@@ -512,16 +509,18 @@ static _INLINE_ int check_filetype(e2fsc
 		return 1;
 	}
 
+	if (ctx->inode_badness)
+		ext2fs_icount_fetch32(ctx->inode_badness, dirent->inode,
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
@@ -956,12 +955,10 @@ static int check_dir_block(ext2_filsys f
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
@@ -1195,8 +1192,8 @@ static void deallocate_inode(e2fsck_t ct
 	e2fsck_read_bitmaps(ctx);
 	ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
 	ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, ino);
-	if (ctx->inode_bad_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
+	if (ctx->inode_badness)
+		ext2fs_icount_store(ctx->inode_badness, ino, 0);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
 
 	if (inode.i_file_acl &&
@@ -1261,8 +1258,10 @@ extern int e2fsck_process_bad_inode(e2fs
 	int			not_fixed = 0;
 	unsigned char		*frag, *fsize;
 	struct problem_context	pctx;
-	int	problem = 0;
+	int			problem = 0;
+	__u16			badness;
 
+	ext2fs_icount_fetch(ctx->inode_badness, ino, &badness);
 	e2fsck_read_inode(ctx, ino, &inode, "process_bad_inode");
 
 	clear_problem_context(&pctx);
@@ -1277,6 +1276,7 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
 	}
 
 	if (!LINUX_S_ISDIR(inode.i_mode) && !LINUX_S_ISREG(inode.i_mode) &&
@@ -1310,6 +1310,11 @@ extern int e2fsck_process_bad_inode(e2fs
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
@@ -1318,6 +1323,7 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
 	}
 
 	switch (fs->super->s_creator_os) {
@@ -1339,6 +1345,7 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
 		pctx.num = 0;
 	}
 	if (fsize && *fsize) {
@@ -1348,11 +1355,28 @@ extern int e2fsck_process_bad_inode(e2fs
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
-	    !(fs->super->s_feature_ro_compat & 
+	    !(fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
 	    (inode.osd2.linux2.l_i_blocks_hi != 0)) {
 		pctx.num = inode.osd2.linux2.l_i_blocks_hi;
@@ -1360,6 +1384,8 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode.osd2.linux2.l_i_blocks_hi = 0;
 			inode_modified++;
 		}
+		/* Badness was increased in pass1 for this condition */
+		/* badness += BADNESS_NORMAL; */
 	}
 
 	if (inode.i_file_acl &&
@@ -1370,6 +1396,7 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
 	}
 	if (inode.i_dir_acl &&
 	    LINUX_S_ISDIR(inode.i_mode)) {
@@ -1378,12 +1405,28 @@ extern int e2fsck_process_bad_inode(e2fs
 			inode_modified++;
 		} else
 			not_fixed++;
+		badness += BADNESS_NORMAL;
+	}
+
+	/*
+	 * The high value due to BADNESS_BAD_MODE should not delete the inode.
+	 */
+	if ((badness - ((badness >= BADNESS_BAD_MODE) ? BADNESS_BAD_MODE : 0))>=
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
 
Index: e2fsprogs-1.40.4/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/problem.c
+++ e2fsprogs-1.40.4/e2fsck/problem.c
@@ -1316,6 +1316,11 @@ static struct e2fsck_problem problem_tab
 	  N_("@i %i found in @g %g unused inodes area.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* Inode too bad */
+	{ PR_2_INODE_TOOBAD,
+	  N_("@i %i is badly corrupt (badness value = %N).  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
Index: e2fsprogs-1.40.4/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/problem.h
+++ e2fsprogs-1.40.4/e2fsck/problem.h
@@ -792,6 +792,9 @@ struct problem_context {
 /* Inode found in group unused inodes area */
 #define PR_2_INOREF_IN_UNUSED		0x020046
 
+/* Inode completely corrupt */
+#define PR_2_INODE_TOOBAD		0x020047
+
 /*
  * Pass 3 errors
  */
Index: e2fsprogs-1.40.4/lib/ext2fs/icount.c
===================================================================
--- e2fsprogs-1.40.4.orig/lib/ext2fs/icount.c
+++ e2fsprogs-1.40.4/lib/ext2fs/icount.c
@@ -462,6 +462,23 @@ static errcode_t get_inode_count(ext2_ic
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
@@ -501,6 +518,7 @@ errcode_t ext2fs_icount_fetch32(ext2_ico
 		*ret = 0;
 		return 0;
 	}
+
 	get_inode_count(icount, ino, ret);
 	return 0;
 }
Index: e2fsprogs-1.40.4/e2fsck/pass1b.c
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/pass1b.c
+++ e2fsprogs-1.40.4/e2fsck/pass1b.c
@@ -613,8 +613,8 @@ static void delete_file(e2fsck_t ctx, ex
 		fix_problem(ctx, PR_1B_BLOCK_ITERATE, &pctx);
 	ext2fs_unmark_inode_bitmap(ctx->inode_used_map, ino);
 	ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, ino);
-	if (ctx->inode_bad_map)
-		ext2fs_unmark_inode_bitmap(ctx->inode_bad_map, ino);
+ 	if (ctx->inode_badness)
+ 		e2fsck_mark_inode_bad(ctx, ino, 0);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
 
 	/* Inode may have changed by block_iterate, so reread it */
Index: e2fsprogs-1.40.4/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/unix.c
+++ e2fsprogs-1.40.4/e2fsck/unix.c
@@ -624,6 +624,18 @@ static void parse_extended_opts(e2fsck_t
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
@@ -639,6 +646,7 @@ static void parse_extended_opts(e2fsck_t
 		       "\tshared=<preserve|lost+found|delete>\n"
 		       "\tclone=<dup|zero>\n"
 		       "\tea_ver=<ea_version (1 or 2)>\n"
+ 		       "\tinode_badness_threhold=(value)\n"
  		       "\texpand_extra_isize\n"
 		       "\n"), stderr);
 		exit(1);
@@ -703,6 +711,9 @@ static errcode_t PRS(int argc, char *arg
 	profile_init(config_fn, &ctx->profile);
 	initialize_profile_options(ctx);
 
+	ctx->inode_badness_threshold = BADNESS_THRESHOLD;
+	ctx->now_tolerance_val = 172800; /* Two days */
+
 	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
 		switch (c) {
 		case 'C':
Index: e2fsprogs-1.40.4/e2fsck/e2fsck.c
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/e2fsck.c
+++ e2fsprogs-1.40.4/e2fsck/e2fsck.c
@@ -105,10 +105,6 @@ errcode_t e2fsck_reset_context(e2fsck_t 
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
Index: e2fsprogs-1.40.4/e2fsck/e2fsck.8.in
===================================================================
--- e2fsprogs-1.40.4.orig/e2fsck/e2fsck.8.in
+++ e2fsprogs-1.40.4/e2fsck/e2fsck.8.in
@@ -191,6 +191,13 @@ in place (preserve); 
 Assume the format of the extended attribute blocks in the filesystem is
 the specified version number.  The version number may be 1 or 2.  The
 default extended attribute version format is 2.
+.TP
+.BI inode_badness_threshold= threshold_value
+A badness counter is associated with every inode, which determines the degree
+of inode corruption. Each error found in the inode will increase the badness by
+1 or 2, and inodes with a badness at or above
+.I threshold_value will be prompted for deletion. The default
+.I threshold_value is 7.
 .RE
 .TP
 .B \-f
Index: e2fsprogs-1.40.4/tests/f_bad_disconnected_inode/expect.1
===================================================================
--- e2fsprogs-1.40.4.orig/tests/f_bad_disconnected_inode/expect.1
+++ e2fsprogs-1.40.4/tests/f_bad_disconnected_inode/expect.1
@@ -39,10 +39,7 @@ Clear? yes
 i_blocks_hi for inode 16 (...) is 62762, should be zero.
 Clear? yes
 
-Unattached inode 16
-Connect to /lost+found? yes
-
-Inode 16 ref count is 5925, should be 1.  Fix? yes
+Inode 16 is badly corrupt (badness value = 10).  Clear? yes
 
 Pass 5: Checking group summary information
 Block bitmap differences:  -(9--19)
@@ -54,19 +51,16 @@ Fix? yes
 Free blocks count wrong (79, counted=91).
 Fix? yes
 
-Inode bitmap differences:  +16
-Fix? yes
-
-Free inodes count wrong for group #0 (7, counted=4).
+Free inodes count wrong for group #0 (8, counted=5).
 Fix? yes
 
 Directories count wrong for group #0 (3, counted=2).
 Fix? yes
 
-Free inodes count wrong (7, counted=4).
+Free inodes count wrong (8, counted=5).
 Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 12/16 files (0.0% non-contiguous), 9/100 blocks
+test_filesys: 11/16 files (0.0% non-contiguous), 9/100 blocks
 Exit status is 1
Index: e2fsprogs-1.40.4/tests/f_bad_disconnected_inode/expect.2
===================================================================
--- e2fsprogs-1.40.4.orig/tests/f_bad_disconnected_inode/expect.2
+++ e2fsprogs-1.40.4/tests/f_bad_disconnected_inode/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 12/16 files (0.0% non-contiguous), 9/100 blocks
+test_filesys: 11/16 files (0.0% non-contiguous), 9/100 blocks
 Exit status is 0
Index: e2fsprogs-1.40.4/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.40.4.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40.4/lib/ext2fs/ext2fs.h
@@ -831,6 +831,7 @@ extern errcode_t ext2fs_initialize(const
 
 /* icount.c */
 extern void ext2fs_free_icount(ext2_icount_t icount);
+extern int ext2fs_icount_is_set(ext2_icount_t icount, ext2_ino_t ino);
 extern errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 					  int flags, ext2_icount_t *ret);
 extern errcode_t ext2fs_create_icount2(ext2_filsys fs, int flags, 

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
