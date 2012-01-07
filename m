From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/51] e2fsck: Verify and correct inode checksums
Date: Sat, 07 Jan 2012 00:33:47 -0800
Message-ID: <20120107083347.25788.55969.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51611 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759568Ab2AGIdx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 Jan 2012 03:33:53 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 7 Jan 2012 03:33:53 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q078XoPY3035390
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 03:33:50 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q078XnfK004721
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 06:33:50 -0200
In-Reply-To: <20120107083256.25788.41238.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Detect mismatches of the inode and checksum, and prompt the user to fix the
situation.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass1.c   |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 e2fsck/problem.c |   10 +++++++++
 e2fsck/problem.h |    6 +++++
 3 files changed, 75 insertions(+), 1 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 62e49c6..c382a7b 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -540,6 +540,40 @@ extern void e2fsck_setup_tdb_icount(e2fsck_t ctx, int flags,
 		*ret = 0;
 }
 
+static errcode_t recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
+					    e2fsck_t ctx,
+					    struct problem_context *pctx)
+{
+	errcode_t retval;
+	struct ext2_inode_large inode;
+
+	/*
+	 * Reread inode.  If we don't see checksum error, then this inode
+	 * has been fixed elsewhere.
+	 */
+	retval = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
+					sizeof(inode));
+	if (retval && retval != EXT2_ET_INODE_CSUM_INVALID)
+		return retval;
+	if (!retval)
+		return 0;
+
+	/*
+	 * Checksum still doesn't match.  That implies that the inode passes
+	 * all the sanity checks, so maybe the checksum is simply corrupt.
+	 * See if the user will go for fixing that.
+	 */
+	if (!fix_problem(ctx, PR_1_INODE_ONLY_CSUM_INVALID, pctx))
+		return 0;
+
+	retval = ext2fs_write_inode_full(fs, ino, (struct ext2_inode *)&inode,
+					 sizeof(inode));
+	if (retval)
+		return retval;
+
+	return 0;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -560,6 +594,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	int		imagic_fs, extent_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
+	int		failed_csum = 0;
 
 	init_resource_track(&rtrack, ctx->fs->io);
 	clear_problem_context(&pctx);
@@ -729,7 +764,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			continue;
 		}
-		if (pctx.errcode) {
+		if (pctx.errcode &&
+		    pctx.errcode != EXT2_ET_INODE_CSUM_INVALID) {
 			fix_problem(ctx, PR_1_ISCAN_ERROR, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
 			return;
@@ -739,6 +775,14 @@ void e2fsck_pass1(e2fsck_t ctx)
 		pctx.ino = ino;
 		pctx.inode = inode;
 		ctx->stashed_ino = ino;
+
+		/* Clear corrupt inode? */
+		if (pctx.errcode == EXT2_ET_INODE_CSUM_INVALID) {
+			if (fix_problem(ctx, PR_1_INODE_CSUM_INVALID, &pctx))
+				goto clear_inode;
+			failed_csum = 1;
+		}
+
 		if (inode->i_links_count) {
 			pctx.errcode = ext2fs_icount_store(ctx->inode_link_info,
 					   ino, inode->i_links_count);
@@ -1135,6 +1179,20 @@ void e2fsck_pass1(e2fsck_t ctx)
 		} else
 			check_blocks(ctx, &pctx, block_buf);
 
+		/*
+		 * If the inode failed the checksum and the user didn't
+		 * clear the inode, test the checksum again -- if it still
+		 * fails, ask the user if the checksum should be corrected.
+		 */
+		if (failed_csum) {
+			pctx.errcode = recheck_bad_inode_checksum(fs, ino, ctx,
+								  &pctx);
+			if (pctx.errcode) {
+				ctx->flags |= E2F_FLAG_ABORT;
+				return;
+			}
+		}
+
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			return;
 
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index f042b89..39e34b4 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -934,8 +934,18 @@ static struct e2fsck_problem problem_table[] = {
 	/* Quota inode is user visible */
 	{ PR_1_QUOTA_INODE_NOT_HIDDEN,
 	  N_("@q @i is visible to the user.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* inode checksum does not match inode */
+	{ PR_1_INODE_CSUM_INVALID,
+	  N_("@i %i checksum does not match @i.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+	/* inode passes checks, but checksum does not match inode */
+	{ PR_1_INODE_ONLY_CSUM_INVALID,
+	  N_("@i %i passes checks, but checksum does not match @i.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
 	/* Invalid bad inode */
 	{ PR_1_INVALID_BAD_INODE,
 	  N_("The bad @b @i looks @n.  "),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 9db29d8..4ce9f41 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -550,6 +550,12 @@ struct problem_context {
 /* Invalid bad inode */
 #define PR_1_INVALID_BAD_INODE		0x010065
 
+/* inode checksum does not match inode */
+#define PR_1_INODE_CSUM_INVALID		0x010066
+
+/* inode passes checks, but checksum does not match inode */
+#define PR_1_INODE_ONLY_CSUM_INVALID	0x010067
+
 /*
  * Pass 1b errors
  */

