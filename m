From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 42/54] e2fsck: Verify and correct MMP checksum problems
Date: Tue, 06 Mar 2012 16:02:22 -0800
Message-ID: <20120307000222.11945.34243.stgit@elm3b70.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:42632 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031608Ab2CGADN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Mar 2012 19:03:13 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Mar 2012 17:03:11 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 063583E4004F
	for <linux-ext4@vger.kernel.org>; Tue,  6 Mar 2012 17:03:07 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2702UWC100110
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 17:02:32 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2702Qks019115
	for <linux-ext4@vger.kernel.org>; Tue, 6 Mar 2012 17:02:27 -0700
In-Reply-To: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
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
index 8c55721..91617bc 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -432,6 +432,11 @@ static struct e2fsck_problem problem_table[] = {
 	     "bits cannot be set simultaneously."),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
+	/* Superblock has invalid MMP checksum. */
+	{ PR_0_MMP_CSUM_INVALID,
+	  N_("@S MMP block checksum does not match MMP block.  "),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index e47984c..f6f1eee 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -248,6 +248,9 @@ struct problem_context {
  */
 #define PR_0_META_AND_GDT_CSUM_SET		0x000044
 
+/* Superblock has invalid MMP checksum. */
+#define PR_0_MMP_CSUM_INVALID			0x000045
+
 /*
  * Pass 1 errors
  */
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 678ce9b..d3fb8f8 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1098,6 +1098,11 @@ check_error:
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

