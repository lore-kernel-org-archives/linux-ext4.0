From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 07/51] e2fsck: Verify and correct inode checksums
Date: Tue, 13 Dec 2011 17:14:03 -0800
Message-ID: <20111214011403.20947.54324.stgit@elm3c44.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e37.co.us.ibm.com ([32.97.110.158]:50130 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab1LNBOK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Dec 2011 20:14:10 -0500
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 13 Dec 2011 18:14:09 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBE1E6dw123754
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:14:06 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBE1E50q003776
	for <linux-ext4@vger.kernel.org>; Tue, 13 Dec 2011 18:14:06 -0700
In-Reply-To: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Detect mismatches of the inode and checksum, and prompt the user to fix the
situation.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass1.c   |    9 ++++++++-
 e2fsck/problem.c |    7 ++++++-
 e2fsck/problem.h |    3 +++
 3 files changed, 17 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 62e49c6..15320c6 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -729,7 +729,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			continue;
 		}
-		if (pctx.errcode) {
+		if (pctx.errcode &&
+		    pctx.errcode != EXT2_ET_INODE_CSUM_INVALID) {
 			fix_problem(ctx, PR_1_ISCAN_ERROR, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
 			return;
@@ -739,6 +740,12 @@ void e2fsck_pass1(e2fsck_t ctx)
 		pctx.ino = ino;
 		pctx.inode = inode;
 		ctx->stashed_ino = ino;
+
+		/* Clear corrupt inode */
+		if (pctx.errcode == EXT2_ET_INODE_CSUM_INVALID &&
+		    fix_problem(ctx, PR_1_INODE_CSUM_INVALID, &pctx))
+			goto clear_inode;
+
 		if (inode->i_links_count) {
 			pctx.errcode = ext2fs_icount_store(ctx->inode_link_info,
 					   ino, inode->i_links_count);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index f042b89..89dc72b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -934,7 +934,12 @@ static struct e2fsck_problem problem_table[] = {
 	/* Quota inode is user visible */
 	{ PR_1_QUOTA_INODE_NOT_HIDDEN,
 	  N_("@q @i is visible to the user.  "),
-	  PROMPT_CLEAR, PR_PREEN_OK },
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* inode checksum does not match inode */
+	{ PR_1_INODE_CSUM_INVALID,
+	  N_("@i %i checksum does not match @i.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
 
 	/* Invalid bad inode */
 	{ PR_1_INVALID_BAD_INODE,
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 9db29d8..f9f8cd7 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -550,6 +550,9 @@ struct problem_context {
 /* Invalid bad inode */
 #define PR_1_INVALID_BAD_INODE		0x010065
 
+/* inode checksum does not match inode */
+#define PR_1_INODE_CSUM_INVALID		0x010066
+
 /*
  * Pass 1b errors
  */

