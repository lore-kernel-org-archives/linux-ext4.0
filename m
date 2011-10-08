From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 28/47] e2fsck: Check extended attribute block checksums
Date: Sat, 08 Oct 2011 00:36:14 -0700
Message-ID: <20111008073614.17888.40928.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42523 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab1JHHi7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:38:59 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:38:58 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987aGw8272778
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:36:16 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987aEij016568
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 01:36:16 -0600
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify the checksums of separate extended attribute blocks and offer to clear
it if there is a mismatch.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass1.c   |    7 +++++++
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 3 files changed, 15 insertions(+), 0 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 0423565..616e26d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1594,7 +1594,9 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	 * validate it
 	 */
 	pctx->blk = blk;
+	fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	pctx->errcode = ext2fs_read_ext_attr3(fs, blk, block_buf, pctx->ino);
+	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
 		goto clear_extattr;
 	header = (struct ext2_ext_attr_header *) block_buf;
@@ -1607,6 +1609,11 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 			goto clear_extattr;
 	}
 
+	if (!ext2fs_ext_attr_block_csum_verify(fs, pctx->ino, pctx->blk,
+			(struct ext2_ext_attr_header *)block_buf) &&
+	    fix_problem(ctx, PR_1_EA_BLOCK_CSUM_INVALID, pctx))
+		goto clear_extattr;
+
 	if (header->h_blocks != 1) {
 		if (fix_problem(ctx, PR_1_EA_MULTI_BLOCK, pctx))
 			goto clear_extattr;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 5412dc8..76a13de 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -956,6 +956,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("The bad @b @i looks @n.  "),
 	  PROMPT_CLEAR, 0 },
 
+	/* Checksum failure reading extended attribute block */
+	{ PR_1_EA_BLOCK_CSUM_INVALID,
+	  N_("Checksum failure @a @b %b for @i %i.  "),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 573a7f5..fdb7f99 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -559,6 +559,9 @@ struct problem_context {
 /* inode checksum should not be set */
 #define PR_1_INODE_CSUM_NONZERO		0x010068
 
+/* ea block checksum invalid */
+#define PR_1_EA_BLOCK_CSUM_INVALID	0x010065
+
 /*
  * Pass 1b errors
  */

