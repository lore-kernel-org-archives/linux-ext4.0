From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 37/54] e2fsck: Ensure block group checksum uses metadata_csum
 algorithm
Date: Tue, 06 Mar 2012 16:01:45 -0800
Message-ID: <20120307000144.11945.30934.stgit@elm3b70.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56703 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965279Ab2CGACH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Mar 2012 19:02:07 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 19:02:07 -0500
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 1CE996E804A
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 19:02:05 -0500 (EST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q270244p3731650
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 19:02:04 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q275WqSs016676
	for <linux-ext4@vger.kernel.org>; Wed, 7 Mar 2012 00:32:56 -0500
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the helper function to determine if group descriptors have a checksum.
Ensure that metadata_csum and uninit_bg flags are not set simultaneously, as
part of pass 0.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass5.c   |   18 ++++++------------
 e2fsck/problem.c |    9 +++++++++
 e2fsck/problem.h |    5 +++++
 e2fsck/super.c   |   16 ++++++++++++++--
 e2fsck/unix.c    |    2 +-
 5 files changed, 35 insertions(+), 15 deletions(-)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index f1ce6d7..c5dba0b 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -88,7 +88,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 	int		nbytes;
 	ext2_ino_t	ino_itr;
 	errcode_t	retval;
-	int		csum_flag = 0;
+	int		csum_flag;
 
 	/* If bitmap is dirty from being fixed, checksum will be corrected */
 	if (ext2fs_test_ib_dirty(ctx->fs))
@@ -103,9 +103,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 		fatal_error(ctx, 0);
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(ctx->fs);
 
 	clear_problem_context(&pctx);
 	for (i = 0; i < ctx->fs->group_desc_count; i++) {
@@ -149,7 +147,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 	int		nbytes;
 	blk64_t		blk_itr;
 	errcode_t	retval;
-	int		csum_flag = 0;
+	int		csum_flag;
 
 	/* If bitmap is dirty from being fixed, checksum will be corrected */
 	if (ext2fs_test_bb_dirty(ctx->fs))
@@ -164,9 +162,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 		fatal_error(ctx, 0);
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(ctx->fs);
 
 	clear_problem_context(&pctx);
 	for (i = 0; i < ctx->fs->group_desc_count; i++) {
@@ -322,8 +318,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
@@ -599,8 +594,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index ad6887e..8c55721 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -423,6 +423,15 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@S has invalid MMP magic.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
+	/*
+	 * metadata_csum implies uninit_bg; both feature bits cannot
+	 * be set simultaneously.
+	 */
+	{ PR_0_META_AND_GDT_CSUM_SET,
+	  N_("@S metadata_csum supersedes uninit_bg; both feature "
+	     "bits cannot be set simultaneously."),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index b8a7548..e47984c 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -242,6 +242,11 @@ struct problem_context {
 /* Superblock has invalid MMP magic. */
 #define PR_0_MMP_INVALID_MAGIC			0x000043
 
+/*
+ * metadata_csum supersedes uninit_bg; both feature bits cannot be set
+ * simultaneously.
+ */
+#define PR_0_META_AND_GDT_CSUM_SET		0x000044
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/super.c b/e2fsck/super.c
index dbd337c..939a71e 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -577,14 +577,26 @@ void check_super_block(e2fsck_t ctx)
 		}
 	}
 
+	/* Are metadata_csum and uninit_bg both set? */
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	    fix_problem(ctx, PR_0_META_AND_GDT_CSUM_SET, &pctx)) {
+		fs->super->s_feature_ro_compat &=
+			~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+		ext2fs_mark_super_dirty(fs);
+		for (i = 0; i < fs->group_desc_count; i++)
+			ext2fs_group_desc_csum_set(fs, i);
+	}
+
 	/*
 	 * Verify the group descriptors....
 	 */
 	first_block = sb->s_first_data_block;
 	last_block = ext2fs_blocks_count(sb)-1;
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 	for (i = 0; i < fs->group_desc_count; i++) {
 		pctx.group = i;
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index a8e3775..678ce9b 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1653,7 +1653,7 @@ no_journal:
 	}
 
 	if ((run_result & E2F_FLAG_CANCEL) == 0 &&
-	    sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM &&
+	    ext2fs_has_group_desc_csum(ctx->fs) &&
 	    !(ctx->options & E2F_OPT_READONLY)) {
 		retval = ext2fs_set_gdt_csum(ctx->fs);
 		if (retval) {

