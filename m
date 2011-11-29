From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 41/50] e2fsck: Verify and correct MMP checksum problems
Date: Mon, 28 Nov 2011 16:32:37 -0800
Message-ID: <20111129003237.17953.78162.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41241 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1K2AdL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:33:11 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:33:09 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0Wf4R3031272
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:32:41 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0We11023960
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 22:32:41 -0200
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Check and handle MMP checksum problems by resetting the block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 e2fsck/unix.c    |    5 +++++
 3 files changed, 13 insertions(+), 0 deletions(-)


diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 35e078c..c36c527 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -428,6 +428,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@S has invalid MMP magic.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
+	/* Superblock has invalid MMP checksum. */
+	{ PR_0_MMP_CSUM_INVALID,
+	  N_("@S MMP block checksum does not match MMP block.  "),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 0045872..503cb39 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -242,6 +242,9 @@ struct problem_context {
 /* Superblock has invalid MMP magic. */
 #define PR_0_MMP_INVALID_MAGIC			0x000043
 
+/* Superblock has invalid MMP checksum. */
+#define PR_0_MMP_CSUM_INVALID			0x000044
+
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 0881002..3f7ca62 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1086,6 +1086,11 @@ check_error:
 			ext2fs_mmp_clear(fs);
 			retval = 0;
 		}
+	} else if (retval == EXT2_ET_MMP_CSUM_INVALID) {
+		if (fix_problem(ctx, PR_0_MMP_CSUM_INVALID, &pctx)) {
+			ext2fs_mmp_clear(fs);
+			retval = 0;
+		}
 	}
 	return retval;
 }

