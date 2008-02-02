From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][11/28] e2fsprogs-nlinks-flag.patch
Date: Sat, 02 Feb 2008 01:36:10 -0700
Message-ID: <20080202083610.GL31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58385 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYBBIgO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:36:14 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128aDpt016604
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:36:13 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00301RRI2W00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:36:13 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


If there are any directories with > 65000 subdirectories, enable the
DIR_NLINK feature in the superblock.  If there are any directories
that formerly had > 65000 subdirs (i_links_count == 1) but no longer
do, don't consider this an error to alert the user about, but silently
fix the link count to the currently counted link count.

The DIR_NLINK feature is not disabled if set but no many-subdir directories
are found, so that the kernel is not required to enable it on-the-fly.  The
admin should set it with tune2fs instead.

Index: e2fsprogs-1.40.5/e2fsck/pass4.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/pass4.c
+++ e2fsprogs-1.40.5/e2fsck/pass4.c
@@ -101,6 +101,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 	struct problem_context	pctx;
 	__u16	link_count;
 	__u32	link_counted;
+	__u32   many_subdirs = 0;
 	char	*buf = 0;
 	int	group, maxgroup;
 	
@@ -182,7 +183,20 @@ void e2fsck_pass4(e2fsck_t ctx)
 				e2fsck_write_inode(ctx, i, inode, "pass4");
 			}
 		}
+		if (link_count == 1 && link_counted > EXT2_LINK_MAX)
+			many_subdirs++;
 	}
+
+	if (many_subdirs) {
+		if (!(fs->super->s_feature_ro_compat &
+		      EXT4_FEATURE_RO_COMPAT_DIR_NLINK) &&
+		    fix_problem(ctx, PR_4_FEATURE_DIR_NLINK, &pctx)) {
+			fs->super->s_feature_ro_compat |=
+				EXT4_FEATURE_RO_COMPAT_DIR_NLINK;
+			ext2fs_mark_super_dirty(fs);
+		}
+	}
+
 	ext2fs_free_icount(ctx->inode_link_info); ctx->inode_link_info = 0;
 	ext2fs_free_icount(ctx->inode_count); ctx->inode_count = 0;
 	ext2fs_free_inode_bitmap(ctx->inode_bb_map);
Index: e2fsprogs-1.40.5/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/problem.c
+++ e2fsprogs-1.40.5/e2fsck/problem.c
@@ -1371,6 +1371,11 @@ static struct e2fsck_problem problem_tab
 	  "They @s the same!\n"),
 	  PROMPT_NONE, 0 },
 
+	/* DIR_NLINK flag not set but dirs with > 65000 subdirs found */
+	{ PR_4_FEATURE_DIR_NLINK,
+	  N_("@f has @d with > 65000 subdirs, but no DIR_NLINK flag in @S.\n"),
+          PROMPT_FIX, 0 },
+
 	/* Pass 5 errors */
 		  
 	/* Pass 5: Checking group summary information */
Index: e2fsprogs-1.40.5/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/problem.h
+++ e2fsprogs-1.40.5/e2fsck/problem.h
@@ -824,6 +824,10 @@ struct problem_context {
 /* Inconsistent inode count information cached */
 #define PR_4_INCONSISTENT_COUNT	0x040004
 
+/* Directory with > EXT2_LINK_MAX subdirs found but
+ * EXT4_FEATURE_RO_COMPAT_DIR_NLINK flag is not set */
+#define PR_4_FEATURE_DIR_NLINK	0x040005
+
 /*
  * Pass 5 errors
  */
Index: e2fsprogs-1.40.5/misc/tune2fs.8.in
===================================================================
--- e2fsprogs-1.40.5.orig/misc/tune2fs.8.in
+++ e2fsprogs-1.40.5/misc/tune2fs.8.in
@@ -400,6 +400,10 @@ The following filesystem features can be
 .B dir_index
 Use hashed b-trees to speed up lookups in large directories.
 .TP
+.B dir_nlink
+Allow directories to have more than 65000 subdirectories (read-only
+compatible).
+.TP
 .B filetype
 Store file type information in directory entries.
 .TP
Index: e2fsprogs-1.40.5/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.40.5.orig/misc/tune2fs.c
+++ e2fsprogs-1.40.5/misc/tune2fs.c
@@ -100,7 +100,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |	/* R/O compat */
-		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+		EXT4_FEATURE_RO_COMPAT_DIR_NLINK,
 };
 
 /*
@@ -286,6 +287,7 @@ static void update_feature_set(ext2_fils
 	int sparse, old_sparse, filetype, old_filetype;
 	int journal, old_journal, dxdir, old_dxdir;
 	int flex_bg, old_flex_bg;
+	int dir_nlink, old_dir_nlink;
 	struct ext2_super_block *sb= fs->super;
 	__u32	old_compat, old_incompat, old_ro_compat;
 
@@ -295,6 +297,8 @@ static void update_feature_set(ext2_fils
 
 	old_sparse = sb->s_feature_ro_compat &
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER;
+	old_dir_nlink = sb->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_DIR_NLINK;
 	old_filetype = sb->s_feature_incompat &
 		EXT2_FEATURE_INCOMPAT_FILETYPE;
 	old_flex_bg = sb->s_feature_incompat &
@@ -311,6 +315,8 @@ static void update_feature_set(ext2_fils
 	}
 	sparse = sb->s_feature_ro_compat &
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER;
+	dir_nlink = sb->s_feature_ro_compat &
+		EXT4_FEATURE_RO_COMPAT_DIR_NLINK;
 	filetype = sb->s_feature_incompat &
 		EXT2_FEATURE_INCOMPAT_FILETYPE;
 	flex_bg = sb->s_feature_incompat &
@@ -359,6 +365,14 @@ static void update_feature_set(ext2_fils
 		if (uuid_is_null((unsigned char *) sb->s_hash_seed))
 			uuid_generate((unsigned char *) sb->s_hash_seed);
 	}
+
+	if (old_dir_nlink && !dir_nlink) {
+		fputs(_("The dir_nlink flag was cleared.  "
+			"Please run e2fsck before using the filesystem\n"
+			"to verify no many-linked directories exist or "
+			"data loss may result.\n"), stderr);
+	}
+
 	if (!flex_bg && old_flex_bg) {
 		if (ext2fs_check_desc(fs)) {
 			fputs(_("Clearing the flex_bg flag would "

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
