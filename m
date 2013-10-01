From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 29/31] e2fsck: Enable extents on all 64bit filesystems
Date: Mon, 30 Sep 2013 18:29:52 -0700
Message-ID: <20131001012952.28415.20120.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23006 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab3JAB34 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:29:56 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since it's impossible to address all blocks of a 64bit filesystem without
extents, have e2fsck turn on the feature if it finds (64bit && !extents).

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    2 ++
 e2fsck/super.c   |   11 +++++++++++
 3 files changed, 18 insertions(+)


diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index b0a6e19..897693a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -447,6 +447,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@S MMP block checksum does not match MMP block.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
+	/* 64bit is set but extents is unset. */
+	{ PR_0_64BIT_WITHOUT_EXTENTS,
+	  N_("@S 64bit filesystems needs extents to access the whole disk.  "),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index fcdc1a1..dd17e37 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -258,6 +258,8 @@ struct problem_context {
 /* Superblock has invalid MMP checksum. */
 #define PR_0_MMP_CSUM_INVALID			0x000047
 
+/* 64bit is set but extents are not set. */
+#define PR_0_64BIT_WITHOUT_EXTENTS		0x000048
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 16a1c23..0c879f5 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -595,6 +595,17 @@ void check_super_block(e2fsck_t ctx)
 			ext2fs_group_desc_csum_set(fs, i);
 	}
 
+	/* Is 64bit set and extents unset? */
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+			EXT4_FEATURE_INCOMPAT_64BIT) &&
+	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+			EXT3_FEATURE_INCOMPAT_EXTENTS) &&
+	    fix_problem(ctx, PR_0_64BIT_WITHOUT_EXTENTS, &pctx)) {
+		fs->super->s_feature_incompat |=
+			EXT3_FEATURE_INCOMPAT_EXTENTS;
+		ext2fs_mark_super_dirty(fs);
+	}
+
 	/*
 	 * Verify the group descriptors....
 	 */

