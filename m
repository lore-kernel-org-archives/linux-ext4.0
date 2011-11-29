From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 29/50] e2fsck: Check extended attribute block checksums
Date: Mon, 28 Nov 2011 16:31:15 -0800
Message-ID: <20111129003115.17953.17893.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55461 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1K2Abm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 19:31:42 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 19:31:41 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0VHWe334318
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 19:31:18 -0500
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0VGeF031632
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:31:17 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify the checksums of separate extended attribute blocks and offer to clear
it if there is a mismatch.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass1.c   |    3 +++
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 3 files changed, 11 insertions(+), 0 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index eb71b7b..275dd6e 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1562,6 +1562,9 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	 */
 	pctx->blk = blk;
 	pctx->errcode = ext2fs_read_ext_attr3(fs, blk, block_buf, pctx->ino);
+	if (pctx->errcode == EXT2_ET_EXT_ATTR_CSUM_INVALID &&
+	    fix_problem(ctx, PR_1_EA_BLOCK_CSUM_INVALID, pctx))
+		goto clear_extattr;
 	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
 		goto clear_extattr;
 	header = (struct ext2_ext_attr_header *) block_buf;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index c78186d..35e078c 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -952,6 +952,11 @@ static struct e2fsck_problem problem_table[] = {
 	     "%c, @n physical @b %b, len %N)\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Checksum failure reading extended attribute block */
+	{ PR_1_EA_BLOCK_CSUM_INVALID,
+	  N_("Extended attribute @a @b %b for @i %i does not match.  "),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 25d73ee..0045872 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -556,6 +556,9 @@ struct problem_context {
 /* extent block checksum does not match extent block */
 #define PR_1_EXTENT_CSUM_INVALID	0x010067
 
+/* ea block checksum invalid */
+#define PR_1_EA_BLOCK_CSUM_INVALID	0x010068
+
 /*
  * Pass 1b errors
  */

