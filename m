From: Valerie Aurora <vaurora@redhat.com>
Subject: [RFC PATCH 2/2] union-mount: Add support for fallthrus
Date: Fri, 19 Nov 2010 15:49:00 -0500
Message-ID: <20101119204900.GB26824@shell>
References: <20101119204817.GA26824@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab0KSUtD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Nov 2010 15:49:03 -0500
Content-Disposition: inline
In-Reply-To: <20101119204817.GA26824@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Support fallthrus, which allow lookup to fall through to the lower
layer filesystems in a union mounted filesystem.  Fallthrus are
enabled with the incompat feature "fallthru".  e2fsck on a file system
with the fallthru feature disabled removes all fallthrus.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 e2fsck/e2fsck.c      |    1 +
 e2fsck/e2fsck.h      |    1 +
 e2fsck/pass2.c       |   13 +++++++++++++
 e2fsck/problem.c     |    5 +++++
 e2fsck/problem.h     |    3 +++
 e2fsck/util.c        |    3 ++-
 lib/e2p/feature.c    |    2 ++
 lib/ext2fs/ext2_fs.h |    7 +++++--
 lib/ext2fs/ext2fs.h  |    2 ++
 misc/mke2fs.c        |   10 ++++++++++
 misc/tune2fs.8.in    |   18 ++++++++++++------
 misc/tune2fs.c       |   22 ++++++++++++++++++++++
 12 files changed, 78 insertions(+), 9 deletions(-)

diff --git a/e2fsck/e2fsck.c b/e2fsck/e2fsck.c
index 7a2f2a5..48f0f61 100644
--- a/e2fsck/e2fsck.c
+++ b/e2fsck/e2fsck.c
@@ -154,6 +154,7 @@ errcode_t e2fsck_reset_context(e2fsck_t ctx)
 	ctx->fs_sockets_count = 0;
 	ctx->fs_whiteouts_count = 0;
 	ctx->fs_opaque_dirs_count = 0;
+	ctx->fs_fallthrus_count = 0;
 	ctx->fs_ind_count = 0;
 	ctx->fs_dind_count = 0;
 	ctx->fs_tind_count = 0;
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index e768997..97cd115 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -332,6 +332,7 @@ struct e2fsck_struct {
 	__u32 fs_sockets_count;
 	__u32 fs_whiteouts_count;
 	__u32 fs_opaque_dirs_count;
+	__u32 fs_fallthrus_count;
 	__u32 fs_ind_count;
 	__u32 fs_dind_count;
 	__u32 fs_tind_count;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index bff5d9a..b25da6b 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -514,6 +514,19 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 		}
 	}
 
+	/* Same goes for fallthrus */
+	if (filetype == EXT2_FT_FALLTHRU) {
+		if (!(ctx->fs->super->s_feature_incompat &
+		      EXT2_FEATURE_INCOMPAT_FALLTHRU)) {
+			if (!fix_problem(ctx, PR_2_CLEAR_FALLTHRU, pctx))
+				return 0;
+			dirent->name_len = dirent->name_len & 0xFF;
+			return 1;
+		} else {
+			ctx->fs_fallthrus_count++;
+		}
+	}
+
 	/* Otherwise, if there's no inode, there's nothing to check. */
 	if (!dirent->inode)
 		return 0;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 25b0295..59659d0 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1323,6 +1323,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@E is a whiteout but file system whiteout feature is disabled.\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Fallthru in a non-fallthru enabled fs */
+	{ PR_2_CLEAR_FALLTHRU,
+	  N_("@E is a fallthru but file system fallthru feature is disabled.\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 9850274..a91b1a0 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -791,6 +791,9 @@ struct problem_context {
 /* Whiteout in a non-whiteout enabled fs */
 #define PR_2_CLEAR_WHITEOUT	0x020049
 
+/* Fallthru in a non-fallthru enabled fs */
+#define PR_2_CLEAR_FALLTHRU	0x020049
+
 /*
  * Pass 3 errors
  */
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 1fef6d5..32cccb0 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -546,7 +546,8 @@ int ext2_file_type(unsigned int mode)
 
 	/*
 	 * This function is called on the mode of an inode. Whiteouts
-	 * don't have inodes, therefore we will never see EXT2_FT_WHT.
+	 * and fallthrus don't have inodes, therefore we will never
+	 * see EXT2_FT_WHT or EXT2_FT_FALLTHRU.
 	 */
 
 	return 0;
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 245e6ae..0c06c94 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -76,6 +76,8 @@ static struct feature feature_list[] = {
                         "flex_bg"},
 	{       E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_WHITEOUT,
 			"whiteout" },
+	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_FALLTHRU,
+			"fallthru" },
 	{	0, 0, 0 },
 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a945434..9f4584f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -688,11 +688,13 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
+#define EXT2_FEATURE_INCOMPAT_FALLTHRU		0x2000
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
-					 EXT2_FEATURE_INCOMPAT_WHITEOUT)
+					 EXT2_FEATURE_INCOMPAT_WHITEOUT| \
+					 EXT2_FEATURE_INCOMPAT_FALLTHRU)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
@@ -756,8 +758,9 @@ struct ext2_dir_entry_2 {
 #define EXT2_FT_SOCK		6
 #define EXT2_FT_SYMLINK		7
 #define EXT2_FT_WHT		8
+#define EXT2_FT_FALLTHRU	9
 
-#define EXT2_FT_MAX		9
+#define EXT2_FT_MAX		10
 
 /*
  * EXT2_DIR_PAD defines the directory entries boundaries
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 45001b7..c313578 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -531,6 +531,7 @@ typedef struct ext2_icount *ext2_icount_t;
 #endif
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT2_FEATURE_INCOMPAT_WHITEOUT|\
+					 EXT2_FEATURE_INCOMPAT_FALLTHRU|\
 					 EXT2_FEATURE_INCOMPAT_COMPRESSION|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
@@ -541,6 +542,7 @@ typedef struct ext2_icount *ext2_icount_t;
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT2_FEATURE_INCOMPAT_WHITEOUT|\
+					 EXT2_FEATURE_INCOMPAT_FALLTHRU|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 033d261..a180cd9 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -790,6 +790,7 @@ static __u32 ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|
 		EXT2_FEATURE_INCOMPAT_WHITEOUT|
+		EXT2_FEATURE_INCOMPAT_FALLTHRU|
 		EXT3_FEATURE_INCOMPAT_EXTENTS|
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
@@ -1600,6 +1601,15 @@ static void PRS(int argc, char *argv[])
 		exit(1);
 	}
 
+	/* Fallthru feature requires filetype feature */
+	if ((fs_param.s_feature_incompat &
+	     EXT2_FEATURE_INCOMPAT_FALLTHRU) &&
+	    !(fs_param.s_feature_incompat &
+	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
+		fprintf(stderr, _("Fallthru support requires filetype support\n"));
+		exit(1);
+	}
+
 	/* Set first meta blockgroup via an environment variable */
 	/* (this is mostly for debugging purposes) */
 	if ((fs_param.s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 0457759..74db33d 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -478,6 +478,10 @@ original time, depending on how full the file system is.
 .B whiteout
 Support whiteouts, which record directory entries that have been
 deleted on a union mounted file system.
+.TP
+.B fallthru
+Support fallthrus, which allow lookup to fall through to the lower
+layer filesystems in a union mounted filesystem.
 .RE
 .IP
 After setting or clearing 
@@ -485,8 +489,9 @@ After setting or clearing
 .BR uninit_bg ,
 .BR filetype ,
 .B resize_inode ,
+.B whiteout ,
 or
-.B whiteout
+.B fallthru
 filesystem features,
 .BR e2fsck (8)
 must be run on the filesystem to return the filesystem to a consistent state.
@@ -507,14 +512,15 @@ features are only supported by the ext4 filesystem.
 .IP
 .B Warning:
 Linux kernels without union mounts enabled do not support file systems
-with whiteouts.  Enabling the whiteout feature on a filesystem will
-prevent it from being mounted by kernels without union mount support.
-Disabling the whiteout feature with
+with whiteouts or fallthrus.  Enabling the whiteout or fallthru
+features on a filesystem will prevent it from being mounted by kernels
+without union mount support.  Disabling the whiteout and fallthru
+features with
 .B tune2fs
 followed by running
 .B e2fsck
-on the file system will delete all the whiteouts and allow the
-filesystem to be mounted again.
+on the file system will delete all the whiteouts and fallthrus and
+allow the filesystem to be mounted again.
 .TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index a7624b2..badb44e 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -123,6 +123,7 @@ static __u32 ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT2_FEATURE_INCOMPAT_WHITEOUT |
+		EXT2_FEATURE_INCOMPAT_FALLTHRU |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
@@ -142,6 +143,7 @@ static __u32 clear_ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT2_FEATURE_INCOMPAT_WHITEOUT |
+		EXT2_FEATURE_INCOMPAT_FALLTHRU |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
@@ -455,6 +457,24 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		       _(please_fsck));
 	}
 
+	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_FALLTHRU)) {
+		if (mount_flags & EXT2_MF_MOUNTED) {
+			fputs(_("The fallthru flag may only be "
+				"cleared when the filesystem is\n"
+				"unmounted.\n"), stderr);
+			exit(1);
+		}
+		sb->s_state &= ~EXT2_VALID_FS;
+		printf(_("\nFallthru superblock flag cleared.  %s"),
+		       _(please_fsck));
+	}
+
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_FALLTHRU)) {
+		sb->s_state &= ~EXT2_VALID_FS;
+		printf(_("\nFallthru superblock flag set.  %s"),
+		       _(please_fsck));
+	}
+
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
 			    EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
 		if ((mount_flags & EXT2_MF_MOUNTED) &&
@@ -510,6 +530,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 			    EXT2_FEATURE_INCOMPAT_FILETYPE) ||
 	    FEATURE_CHANGED(E2P_FEATURE_INCOMPAT,
 			    EXT2_FEATURE_INCOMPAT_WHITEOUT) ||
+	    FEATURE_CHANGED(E2P_FEATURE_INCOMPAT,
+			    EXT2_FEATURE_INCOMPAT_FALLTHRU) ||
 	    FEATURE_CHANGED(E2P_FEATURE_COMPAT,
 			    EXT2_FEATURE_COMPAT_RESIZE_INODE) ||
 	    FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
-- 
1.6.3.3

