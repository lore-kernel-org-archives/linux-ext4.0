From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 30/37] e2fsck: Check extended attribute block checksums
Date: Wed, 31 Aug 2011 17:38:23 -0700
Message-ID: <20110901003823.1176.78056.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e37.co.us.ibm.com ([32.97.110.158]:47102 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab1IAAic (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Aug 2011 20:38:32 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810ZDVF028978
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:35:13 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810cQut123278
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:38:26 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810cONr009830
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 18:38:25 -0600
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
index 71cbddb..e4d4c78 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1555,7 +1555,9 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	 * validate it
 	 */
 	pctx->blk = blk;
+	fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	pctx->errcode = ext2fs_read_ext_attr2(fs, blk, block_buf);
+	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
 		goto clear_extattr;
 	header = (struct ext2_ext_attr_header *) block_buf;
@@ -1568,6 +1570,11 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 			goto clear_extattr;
 	}
 
+	if (!ext2fs_ext_attr_block_csum_verify(fs, pctx->blk,
+			(struct ext2_ext_attr_header *)block_buf) &&
+	    fix_problem(ctx, PR_1_EA_BLOCK_CSUM_INVALID, pctx))
+		goto clear_extattr;
+
 	if (header->h_blocks != 1) {
 		if (fix_problem(ctx, PR_1_EA_MULTI_BLOCK, pctx))
 			goto clear_extattr;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 835f0ff..1259568 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -920,6 +920,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i checksum should not be set.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+	/* Checksum failure reading extended attribute block */
+	{ PR_1_EA_BLOCK_CSUM_INVALID,
+	  N_("Checksum failure @a @b %b for @i %i.  "),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index df29057..47e6904 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -538,6 +538,9 @@ struct problem_context {
 /* inode checksum should not be set */
 #define PR_1_INODE_CSUM_NONZERO		0x010064
 
+/* ea block checksum invalid */
+#define PR_1_EA_BLOCK_CSUM_INVALID	0x010065
+
 /*
  * Pass 1b errors
  */

