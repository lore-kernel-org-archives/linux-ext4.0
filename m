From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH v3.1 37/54] e2fsck: Ensure block group checksum uses
	metadata_csum algorithm
Date: Mon, 12 Mar 2012 17:38:06 -0700
Message-ID: <20120313003806.GU15164@tux1.beaverton.ibm.com>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com> <20120307000144.11945.30934.stgit@elm3b70.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:37355 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999Ab2CMAiO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Mar 2012 20:38:14 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 12 Mar 2012 18:38:13 -0600
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id F2099C90050
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:38:08 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2D0c8BU293144
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:38:08 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2D0c7S8027517
	for <linux-ext4@vger.kernel.org>; Mon, 12 Mar 2012 20:38:08 -0400
Content-Disposition: inline
In-Reply-To: <20120307000144.11945.30934.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the helper function to determine if group descriptors have a
checksum.  Ensure that metadata_csum and uninit_bg flags are not set
simultaneously, as part of pass 0.

v3.1: Reworked bitmap checksum functions in e2fsck; patch shrunk.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 e2fsck/pass5.c   |    6 ++----
 e2fsck/problem.c |    9 +++++++++
 e2fsck/problem.h |    5 +++++
 e2fsck/super.c   |   16 ++++++++++++++--
 e2fsck/unix.c    |    2 +-
 5 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 64a751d..13c946f 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -318,8 +318,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
@@ -595,8 +594,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index b1faba0..c792a25 100644
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

