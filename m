From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/9] e2fsck: check the checksum seed feature flag is set
 correctly
Date: Sat, 13 Feb 2016 14:37:44 -0800
Message-ID: <20160213223744.25381.96382.stgit@birch.djwong.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33929 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbcBMWhr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Feb 2016 17:37:47 -0500
In-Reply-To: <20160213223725.25381.20929.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 e2fsck/super.c   |    9 +++++++++
 3 files changed, 17 insertions(+)


diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index a7da94d..971b0ad 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -467,6 +467,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("External @j @S checksum does not match @S.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* metadata_csum_seed means nothing without metadata_csum */
+	{ PR_0_CSUM_SEED_WITHOUT_META_CSUM,
+	  N_("@S metadata_csum_seed is not necessary without metadata_csum."),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 3b92e41..b3f5b8f 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -268,6 +268,9 @@ struct problem_context {
 /* External journal has corrupt superblock */
 #define PR_0_EXT_JOURNAL_SUPER_CSUM_INVALID	0x00004A
 
+/* metadata_csum_seed means nothing without metadata_csum */
+#define PR_0_CSUM_SEED_WITHOUT_META_CSUM	0x00004B
+
 /*
  * Pass 1 errors
  */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index af6d680..e09c14c 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -589,6 +589,15 @@ void check_super_block(e2fsck_t ctx)
 			ext2fs_group_desc_csum_set(fs, i);
 	}
 
+	/* We can't have ^metadata_csum,metadata_csum_seed */
+	if (!ext2fs_has_feature_metadata_csum(fs->super) &&
+	    ext2fs_has_feature_csum_seed(fs->super) &&
+	    fix_problem(ctx, PR_0_CSUM_SEED_WITHOUT_META_CSUM, &pctx)) {
+		ext2fs_clear_feature_csum_seed(fs->super);
+		fs->super->s_checksum_seed = 0;
+		ext2fs_mark_super_dirty(fs);
+	}
+
 	/* Is 64bit set and extents unset? */
 	if (ext2fs_has_feature_64bit(fs->super) &&
 	    !ext2fs_has_feature_extents(fs->super) &&

