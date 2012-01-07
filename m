From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 29/51] e2fsck: Check extended attribute block checksums
Date: Sat, 07 Jan 2012 00:36:01 -0800
Message-ID: <20120107083601.25788.40869.stgit@elm3c44.beaverton.ibm.com>
References: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e32.co.us.ibm.com ([32.97.110.150]:34117 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758826Ab2AGIgI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jan 2012 03:36:08 -0500
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 01:36:08 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078a4jf096532
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:36:04 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078a3v5020848
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 01:36:04 -0700
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify the checksums of separate extended attribute blocks and offer to clear
it if there is a mismatch.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass1.c   |   18 ++++++++++++++++++
 e2fsck/problem.c |   15 +++++++++++++++
 e2fsck/problem.h |    6 ++++++
 3 files changed, 39 insertions(+), 0 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 2fb5560..5484840 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1540,6 +1540,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	struct ext2_ext_attr_entry *entry;
 	int		count;
 	region_t	region = 0;
+	int		failed_csum = 0;
 
 	blk = ext2fs_file_acl_block(fs, inode);
 	if (blk == 0)
@@ -1613,6 +1614,11 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	 */
 	pctx->blk = blk;
 	pctx->errcode = ext2fs_read_ext_attr3(fs, blk, block_buf, pctx->ino);
+	if (pctx->errcode == EXT2_ET_EXT_ATTR_CSUM_INVALID) {
+		if (fix_problem(ctx, PR_1_EA_BLOCK_CSUM_INVALID, pctx))
+			goto clear_extattr;
+		failed_csum = 1;
+	}
 	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
 		goto clear_extattr;
 	header = (struct ext2_ext_attr_header *) block_buf;
@@ -1694,6 +1700,18 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	}
 	region_free(region);
 
+	/*
+	 * We only get here if there was no other errors that were fixed.
+	 * If there was a checksum fail, ask to correct it.
+	 */
+	if (failed_csum &&
+	    fix_problem(ctx, PR_1_EA_BLOCK_ONLY_CSUM_INVALID, pctx)) {
+		pctx->errcode = ext2fs_write_ext_attr3(fs, blk, block_buf,
+						       pctx->ino);
+		if (pctx->errcode)
+			return 0;
+	}
+
 	count = header->h_refcount - 1;
 	if (count)
 		ea_refcount_store(ctx->refcount, blk, count);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 6dbd01c..bfc1ece 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -966,6 +966,21 @@ static struct e2fsck_problem problem_table[] = {
 	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
 	  PROMPT_FIX, 0 },
 
+	/* Extended attribute block checksum for inode does not match. */
+	{ PR_1_EA_BLOCK_CSUM_INVALID,
+	  N_("Extended attribute @a @b %b checksum for @i %i does not "
+	     "match.  "),
+	  PROMPT_CLEAR, 0 },
+
+	/*
+	 * Extended attribute block passes checks, but checksum for inode does
+	 * not match.
+	 */
+	{ PR_1_EA_BLOCK_CSUM_INVALID,
+	  N_("Extended attribute @a @b %b passes checks, but checksum for "
+	     "@i %i does not match.  "),
+	  PROMPT_FIX, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 3f2b2e9..3d952d5 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -562,6 +562,12 @@ struct problem_context {
 /* extent block passes checks, but checksum does not match extent block */
 #define PR_1_EXTENT_ONLY_CSUM_INVALID	0x010069
 
+/* ea block checksum invalid */
+#define PR_1_EA_BLOCK_CSUM_INVALID	0x010070
+
+/* ea block passes checks, but checksum invalid */
+#define PR_1_EA_BLOCK_ONLY_CSUM_INVALID	0x010071
+
 /*
  * Pass 1b errors
  */

