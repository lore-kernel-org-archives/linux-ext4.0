From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 09/37] e2fsck: Verify and correct inode checksums
Date: Wed, 31 Aug 2011 17:36:09 -0700
Message-ID: <20110901003609.1176.69789.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34273 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321Ab1IAAgN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:36:13 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p810MDvx022117
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:22:13 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810aBIV2723924
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:36:11 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810aAtE013019
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:36:11 -0400
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Detect mismatches of the inode and checksum, and prompt the user to fix the
situation.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 e2fsck/pass1.c   |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c |   15 +++++++++++++++
 e2fsck/problem.h |    9 +++++++++
 3 files changed, 76 insertions(+), 0 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ba17b30..e9b0876 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -540,6 +540,50 @@ extern void e2fsck_setup_tdb_icount(e2fsck_t ctx, int flags,
 		*ret = 0;
 }
 
+static int validate_inode_checksum(ext2_filsys fs,
+				   e2fsck_t ctx,
+				   struct problem_context *pctx,
+				   ext2_ino_t ino,
+				   struct ext2_inode_large *inode)
+{
+	struct ext2_inode_large *linode = (struct ext2_inode_large *)inode;
+
+	/* Ignore non-Linux filesystems */
+	if (fs->super->s_creator_os != EXT2_OS_LINUX)
+		return 0;
+
+	/* Check for checksums present even w/o feature flag */
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    linode->i_checksum &&
+	    fix_problem(ctx, PR_1_INODE_CSUM_NONZERO, pctx)) {
+		e2fsck_write_inode(ctx, ino, inode, "pass1");
+		return PR_1_INODE_CSUM_NONZERO;
+	}
+
+	/* Check for invalid inode checksum */
+	if (ext2fs_inode_csum_verify(fs, ino, linode))
+		return 0;
+
+	/*
+	 * TODO: Change the following check to use the inode badness patch.
+	 * For the moment we'll just assume that the user wants to clear the
+	 * bad inode.
+	 */
+	if (fix_problem(ctx, PR_1_INODE_CORRUPT, pctx)) {
+		e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
+		if (ino == EXT2_BAD_INO)
+			ext2fs_mark_inode_bitmap2(ctx->inode_used_map,
+						  ino);
+		return PR_1_INODE_CORRUPT;
+	} else if (fix_problem(ctx, PR_1_INODE_CSUM_INVALID, pctx)) {
+		e2fsck_write_inode(ctx, ino, inode, "pass1");
+		return PR_1_INODE_CSUM_INVALID;
+	}
+
+	return 0;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -707,8 +751,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 
 	while (1) {
 		old_op = ehandler_operation(_("getting next inode from scan"));
+		ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino,
 							  inode, inode_size);
+		ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		ehandler_operation(old_op);
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			return;
@@ -740,6 +786,12 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
+		check_inode_extra_space(ctx, &pctx);
+		/* Validate inode checksum.  i_extra_isize must be sane. */
+		if (validate_inode_checksum(fs, ctx, &pctx, ino, inode) ==
+		    PR_1_INODE_CORRUPT)
+			continue;
+
 		/*
 		 * Test for incorrect extent flag settings.
 		 *
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index c5bebf8..b5176d4 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -905,6 +905,21 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error converting subcluster @b @B: %m\n"),
 	  PROMPT_NONE, PR_FATAL },
 
+	/* inode checksum probably not set */
+	{ PR_1_INODE_CSUM_INVALID,
+	  N_("@i %i checksum incorrect.  "),
+	  PROMPT_FIX, PR_PREEN_OK },
+
+	/* inode checksum probably set, but does not match */
+	{ PR_1_INODE_CORRUPT,
+	  N_("@i %i checksum shows corruption.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* inode checksumming disabled, yet checksum is probably set? */
+	{ PR_1_INODE_CSUM_NONZERO,
+	  N_("@i %i checksum should not be set.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index a4d96ae..4e353b7 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -529,6 +529,15 @@ struct problem_context {
 /* Failed to convert subcluster bitmap */
 #define PR_1_CONVERT_SUBCLUSTER		0x010061
 
+/* inode checksum probably not set */
+#define PR_1_INODE_CSUM_INVALID		0x010062
+
+/* inode checksum probably set, but does not match */
+#define PR_1_INODE_CORRUPT		0x010063
+
+/* inode checksum should not be set */
+#define PR_1_INODE_CSUM_NONZERO		0x010064
+
 /*
  * Pass 1b errors
  */

