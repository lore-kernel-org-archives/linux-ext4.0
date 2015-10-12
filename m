From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/12] e2fsck: check the checksum seed feature flag is set
 correctly
Date: Mon, 12 Oct 2015 14:57:31 -0700
Message-ID: <20151012215731.29065.61420.stgit@birch.djwong.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40269 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbJLV5e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:57:34 -0400
In-Reply-To: <20151012215629.29065.24418.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 e2fsck/super.c   |    9 +++++++++
 3 files changed, 17 insertions(+)


diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index f761ec9..6a35e93 100644
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
index 2ff0f5e..943024b 100644
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

