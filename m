From: Valerie Aurora <vaurora@redhat.com>
Subject: [RFC PATCH 1/2] union-mount: Add support for whiteouts
Date: Fri, 19 Nov 2010 15:48:17 -0500
Message-ID: <20101119204817.GA26824@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860Ab0KSUsU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 15:48:20 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a request for review, not a pull.  Does this file type-based
approach to supporting whiteouts and fallthrus in ext* make sense?
(Fallthru support in next patch.)

-VAL

From: Valerie Aurora <vaurora@redhat.com>

union-mount: Add support for whiteouts

Whiteouts are used to record deleted directory entries in a union
mounted file system.  Whiteouts are enabled with the incompat feature
"whiteout".  e2fsck on a file system with the whiteout feature
disabled removes all whiteouts and opaque flags.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 e2fsck/e2fsck.c      |    2 ++
 e2fsck/e2fsck.h      |    2 ++
 e2fsck/pass1.c       |   19 +++++++++++++++++++
 e2fsck/pass2.c       |   40 +++++++++++++++++++++++++++++++++++++---
 e2fsck/problem.c     |   10 ++++++++++
 e2fsck/problem.h     |    6 ++++++
 e2fsck/unix.c        |    4 ++++
 e2fsck/util.c        |    5 +++++
 lib/blkid/probe.h    |    3 +++
 lib/e2p/feature.c    |    2 ++
 lib/ext2fs/ext2_fs.h |   10 +++++++---
 lib/ext2fs/ext2fs.h  |    2 ++
 misc/mke2fs.c        |   10 ++++++++++
 misc/tune2fs.8.in    |   18 +++++++++++++++++-
 misc/tune2fs.c       |   22 ++++++++++++++++++++++
 15 files changed, 148 insertions(+), 7 deletions(-)

diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index f1da97a..7a2f2a5 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -152,6 +152,8 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
 	ctx->fs_total_count = 0;
 	ctx->fs_badblocks_count = 0;
 	ctx->fs_sockets_count = 0;
+	ctx->fs_whiteouts_count = 0;
+	ctx->fs_opaque_dirs_count = 0;
 	ctx->fs_ind_count = 0;
 	ctx->fs_dind_count = 0;
 	ctx->fs_tind_count = 0;
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index d4df5f3..e768997 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -330,6 +330,8 @@ struct e2fsck_struct {
 	__u32 fs_total_count;
 	__u32 fs_badblocks_count;
 	__u32 fs_sockets_count;
+	__u32 fs_whiteouts_count;
+	__u32 fs_opaque_dirs_count;
 	__u32 fs_ind_count;
 	__u32 fs_dind_count;
 	__u32 fs_tind_count;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 93763cd..c1572a6 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -508,6 +508,24 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	}
 }
 
+static void check_opaque_flag(e2fsck_t ctx, struct problem_context *pctx)
+{
+	struct ext2_inode *inode = pctx->inode;
+	if (inode->i_flags & EXT2_OPAQUE_FL) {
+		if (!(ctx->fs->super->s_feature_incompat &
+		      EXT2_FEATURE_INCOMPAT_WHITEOUT)) {
+			if (!fix_problem(ctx, PR_1_CLEAR_OPAQUE, pctx))
+				return;
+			inode->i_flags &= ~EXT2_OPAQUE_FL;
+			e2fsck_write_inode_full(ctx, pctx->ino, inode,
+						EXT2_INODE_SIZE(ctx->fs->super),
+						"check_opaque_flag");
+		} else {
+			ctx->fs_opaque_dirs_count++;
+		}
+	}
+}
+
 extern void e2fsck_setup_tdb_icount(e2fsck_t ctx, int flags,
 				    ext2_icount_t *ret)
 {
@@ -1006,6 +1024,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 		check_inode_extra_space(ctx, &pctx);
 		check_is_really_dir(ctx, &pctx, block_buf);
+		check_opaque_flag(ctx, &pctx);
 
 		/*
 		 * ext2fs_inode_has_valid_blocks does not actually look
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 8d1cbc6..bff5d9a 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -489,6 +489,35 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 		return 1;
 	}
 
+	/*
+	 * Whiteouts have no inodes and therefore no way to disagree
+	 * with the dentry's idea of the file type.  However, we need
+	 * to check them against the feature flags in the superblock
+	 * and clear the dentry if the feature isn't enabled.  Thus,
+	 * tunefs -O ^whiteout followed by e2fsck -f is a poor man's
+	 * method of removing all whiteouts in a file system.
+	 */
+	if (filetype == EXT2_FT_WHT) {
+		if (!(ctx->fs->super->s_feature_incompat &
+		      EXT2_FEATURE_INCOMPAT_WHITEOUT)) {
+			if (!fix_problem(ctx, PR_2_CLEAR_WHITEOUT, pctx))
+				return 0;
+			/*
+			 * A directory entry with an inode number of 0 and no
+			 * filetype is free.  The inode is already zero, so
+			 * clear the filetype and this dentry is free.
+			 */
+			dirent->name_len = dirent->name_len & 0xFF;
+			return 1;
+		} else {
+			ctx->fs_whiteouts_count++;
+		}
+	}
+
+	/* Otherwise, if there's no inode, there's nothing to check. */
+	if (!dirent->inode)
+		return 0;
+
 	if (ext2fs_test_inode_bitmap2(ctx->inode_dir_map, dirent->inode)) {
 		should_be = EXT2_FT_DIR;
 	} else if (ext2fs_test_inode_bitmap2(ctx->inode_reg_map,
@@ -881,6 +910,14 @@ out_htree:
 				goto next;
 			}
 		}
+
+		/*
+		 * File type check moved here, since whiteouts and
+		 * fallthrus don't necessarily have inodes.
+		 */
+		if (check_filetype(ctx, dirent, ino, &cd->pctx))
+			dir_modified++;
+
 		if (!dirent->inode)
 			goto next;
 
@@ -1035,9 +1072,6 @@ out_htree:
 		if (check_name(ctx, dirent, ino, &cd->pctx))
 			dir_modified++;
 
-		if (check_filetype(ctx, dirent, ino, &cd->pctx))
-			dir_modified++;
-
 #ifdef ENABLE_HTREE
 		if (dx_db) {
 			ext2fs_dirhash(dx_dir->hashversion, dirent->name,
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 8032fda..25b0295 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -890,6 +890,11 @@ static struct e2fsck_problem problem_table[] = {
 	     "(size %Is, lblk %r)\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+	/* Opaque flag set in a non-whiteout enabled fs */
+	{ PR_1_CLEAR_OPAQUE,
+	  N_("@i %i has opaque flag set but file system whiteout feature is disabled.\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
@@ -1313,6 +1318,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("i_file_acl_hi @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+	/* Whiteout in a non-whiteout enabled fs */
+	{ PR_2_CLEAR_WHITEOUT,
+	  N_("@E is a whiteout but file system whiteout feature is disabled.\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 7c4c156..9850274 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -520,6 +520,9 @@ struct problem_context {
 /* EOFBLOCKS flag set when not necessary */
 #define PR_1_EOFBLOCKS_FL_SET		0x010060
 
+/* Opaque flag set in a non-whiteout enabled fs */
+#define PR_1_CLEAR_OPAQUE		0x010061
+
 /*
  * Pass 1b errors
  */
@@ -785,6 +788,9 @@ struct problem_context {
 /* i_file_acl_hi should be zero */
 #define PR_2_I_FILE_ACL_HI_ZERO		0x020048
 
+/* Whiteout in a non-whiteout enabled fs */
+#define PR_2_CLEAR_WHITEOUT	0x020049
+
 /*
  * Pass 3 errors
  */
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 6cb2214..b9dd26f 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -190,6 +190,10 @@ static void show_stats(e2fsck_t	ctx)
 		   ctx->fs_fast_symlinks_count), ctx->fs_fast_symlinks_count);
 	printf (P_("%8u socket\n", "%8u sockets\n", ctx->fs_sockets_count),
 		ctx->fs_sockets_count);
+	printf (P_("%8u whiteout\n", "%8u whiteouts\n", ctx->fs_whiteouts_count),
+		ctx->fs_whiteouts_count);
+	printf (P_("%8u opaque dir\n", "%8u opaque dirs\n", ctx->fs_opaque_dirs_count),
+		ctx->fs_opaque_dirs_count);
 	printf ("--------\n");
 	printf (P_("%8u file\n", "%8u files\n",
 		   ctx->fs_total_count - dir_links),
diff --git a/e2fsck/util.c b/e2fsck/util.c
index fa156a1..1fef6d5 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -544,6 +544,11 @@ int ext2_file_type(unsigned int mode)
 	if (LINUX_S_ISSOCK(mode))
 		return EXT2_FT_SOCK;
 
+	/*
+	 * This function is called on the mode of an inode. Whiteouts
+	 * don't have inodes, therefore we will never see EXT2_FT_WHT.
+	 */
+
 	return 0;
 }
 
diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index 37fc9c0..374d8ae 100644
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -115,6 +115,7 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_RECOVER		0x0004
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
+#define EXT2_FEATURE_INCOMPAT_WHITEOUT		0x0020
 #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP		0x0100
@@ -124,6 +125,7 @@ struct ext2_super_block {
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT2_FEATURE_INCOMPAT_WHITEOUT| \
 					 EXT2_FEATURE_INCOMPAT_META_BG)
 #define EXT2_FEATURE_INCOMPAT_UNSUPPORTED	~EXT2_FEATURE_INCOMPAT_SUPP
 #define EXT2_FEATURE_RO_COMPAT_UNSUPPORTED	~EXT2_FEATURE_RO_COMPAT_SUPP
@@ -132,6 +134,7 @@ struct ext2_super_block {
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
 #define EXT3_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT2_FEATURE_INCOMPAT_WHITEOUT| \
 					 EXT3_FEATURE_INCOMPAT_RECOVER| \
 					 EXT2_FEATURE_INCOMPAT_META_BG)
 #define EXT3_FEATURE_INCOMPAT_UNSUPPORTED	~EXT3_FEATURE_INCOMPAT_SUPP
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index c7f8a35..245e6ae 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -74,6 +74,8 @@ static struct feature feature_list[] = {
 			"64bit" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
                         "flex_bg"},
+	{       E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_WHITEOUT,
+			"whiteout" },
 	{	0, 0, 0 },
 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fa256e5..a945434 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -279,6 +279,7 @@ struct ext2_dx_countlimit {
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
+#define EXT2_OPAQUE_FL			0x00800000 /* Dir is opaque */
 #define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
@@ -680,6 +681,7 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_RECOVER		0x0004 /* Needs recovery */
 #define EXT3_FEATURE_INCOMPAT_JOURNAL_DEV	0x0008 /* Journal device */
 #define EXT2_FEATURE_INCOMPAT_META_BG		0x0010
+#define EXT2_FEATURE_INCOMPAT_WHITEOUT		0x0020
 #define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP		0x0100
@@ -689,7 +691,8 @@ struct ext2_super_block {
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
-#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
+#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					 EXT2_FEATURE_INCOMPAT_WHITEOUT)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
@@ -741,7 +744,7 @@ struct ext2_dir_entry_2 {
 };
 
 /*
- * Ext2 directory file types.  Only the low 3 bits are used.  The
+ * Ext2 directory file types.  Only the low 4 bits are used.  The
  * other bits are reserved for now.
  */
 #define EXT2_FT_UNKNOWN		0
@@ -752,8 +755,9 @@ struct ext2_dir_entry_2 {
 #define EXT2_FT_FIFO		5
 #define EXT2_FT_SOCK		6
 #define EXT2_FT_SYMLINK		7
+#define EXT2_FT_WHT		8
 
-#define EXT2_FT_MAX		8
+#define EXT2_FT_MAX		9
 
 /*
  * EXT2_DIR_PAD defines the directory entries boundaries
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index e2c3b09..45001b7 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -530,6 +530,7 @@ typedef struct ext2_icount *ext2_icount_t;
  #warning "Compression support is experimental"
 #endif
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
+					 EXT2_FEATURE_INCOMPAT_WHITEOUT|\
 					 EXT2_FEATURE_INCOMPAT_COMPRESSION|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
@@ -539,6 +540,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
+					 EXT2_FEATURE_INCOMPAT_WHITEOUT|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index add7c0c..033d261 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -789,6 +789,7 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_COMPAT_EXT_ATTR,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|
+		EXT2_FEATURE_INCOMPAT_WHITEOUT|
 		EXT3_FEATURE_INCOMPAT_EXTENTS|
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
@@ -1590,6 +1591,15 @@ static void PRS(int argc, char *argv[])
 		exit(1);
 	}
 
+	/* Whiteout feature requires filetype feature */
+	if ((fs_param.s_feature_incompat &
+	     EXT2_FEATURE_INCOMPAT_WHITEOUT) &&
+	    !(fs_param.s_feature_incompat &
+	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
+		fprintf(stderr, _("Whiteout support requires filetype support\n"));
+		exit(1);
+	}
+
 	/* Set first meta blockgroup via an environment variable */
 	/* (this is mostly for debugging purposes) */
 	if ((fs_param.s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 62934f7..0457759 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -474,14 +474,19 @@ watermark for the unused inodes in a filesystem, to reduce
 time.  This first e2fsck run after enabling this feature will take the
 full time, but subsequent e2fsck runs will take only a fraction of the
 original time, depending on how full the file system is.
+.TP
+.B whiteout
+Support whiteouts, which record directory entries that have been
+deleted on a union mounted file system.
 .RE
 .IP
 After setting or clearing 
 .BR sparse_super ,
 .BR uninit_bg ,
 .BR filetype ,
+.B resize_inode ,
 or
-.B resize_inode
+.B whiteout
 filesystem features,
 .BR e2fsck (8)
 must be run on the filesystem to return the filesystem to a consistent state.
@@ -499,6 +504,17 @@ mounted by kernels which do not support those features.  In particular, the
 and
 .BR flex_bg
 features are only supported by the ext4 filesystem.
+.IP
+.B Warning:
+Linux kernels without union mounts enabled do not support file systems
+with whiteouts.  Enabling the whiteout feature on a filesystem will
+prevent it from being mounted by kernels without union mount support.
+Disabling the whiteout feature with
+.B tune2fs
+followed by running
+.B e2fsck
+on the file system will delete all the whiteouts and allow the
+filesystem to be mounted again.
 .TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 4734331..a7624b2 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -122,6 +122,7 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
+		EXT2_FEATURE_INCOMPAT_WHITEOUT |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
@@ -140,6 +141,7 @@ static __u32 clear_ok_features[3] = {
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
+		EXT2_FEATURE_INCOMPAT_WHITEOUT |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
@@ -435,6 +437,24 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		}
 	}
 
+	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_WHITEOUT)) {
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fputs(_("The whiteout flag may only be "
+				"cleared when the filesystem is\n"
+				"unmounted.\n"), stderr);
+			exit(1);
+		}
+		sb->s_state &= ~EXT2_VALID_FS;
+		printf(_("\nWhiteout superblock flag cleared.  %s"),
+		       _(please_fsck));
+	}
+
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_WHITEOUT)) {
+		sb->s_state &= ~EXT2_VALID_FS;
+		printf(_("\nWhiteout superblock flag set.  %s"),
+		       _(please_fsck));
+	}
+
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
 			    EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
 		if ((mount_flags & EXT2_MF_MOUNTED) &&
@@ -488,6 +508,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 			EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
 	    FEATURE_CHANGED(E2P_FEATURE_INCOMPAT,
 			    EXT2_FEATURE_INCOMPAT_FILETYPE) ||
+	    FEATURE_CHANGED(E2P_FEATURE_INCOMPAT,
+			    EXT2_FEATURE_INCOMPAT_WHITEOUT) ||
 	    FEATURE_CHANGED(E2P_FEATURE_COMPAT,
 			    EXT2_FEATURE_COMPAT_RESIZE_INODE) ||
 	    FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
-- 
1.6.3.3

