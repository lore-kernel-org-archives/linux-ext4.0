From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 10/21] e2fsck: clear inline_data inode flag if EA missing
Date: Fri, 8 Aug 2014 15:44:48 -0700
Message-ID: <20140808224448.GG11191@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010602.2611.64599.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32567 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaHHWox (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 18:44:53 -0400
Content-Disposition: inline
In-Reply-To: <20140805010602.2611.64599.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If i_size indicates that an inode requires a system.data extended
attribute to hold overflow from i_blocks but the EA cannot be found,
offer to truncate the file.

v2: Use the raw xattr editing interface since it'll return error codes
to us directly.  This is a side effect of modifying the library inline
data code not to return "key error" when it can't find the system.data
EA.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c   |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c |    5 +++
 e2fsck/problem.h |    3 ++
 3 files changed, 88 insertions(+)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3fbf00a..5115a85 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -669,6 +669,30 @@ static void reserve_block_for_lnf_repair(e2fsck_t ctx)
 	ctx->lnf_repair_block = blk;
 }
 
+static errcode_t get_inline_data_ea_size(ext2_filsys fs, ext2_ino_t ino,
+					 size_t *sz)
+{
+	void *p;
+	struct ext2_xattr_handle *handle;
+	errcode_t retval;
+
+	retval = ext2fs_xattrs_open(fs, ino, &handle);
+	if (retval)
+		return retval;
+
+	retval = ext2fs_xattrs_read(handle);
+	if (retval)
+		goto err;
+
+	retval = ext2fs_xattr_get(handle, "system.data", &p, sz);
+	if (retval)
+		goto err;
+	ext2fs_free_mem(&p);
+err:
+	(void) ext2fs_xattrs_close(&handle);
+	return retval;
+}
+
 static void finish_processing_inode(e2fsck_t ctx, ext2_ino_t ino,
 				    struct problem_context *pctx,
 				    int failed_csum)
@@ -959,6 +983,62 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
+		/* Test for inline data flag but no attr */
+		if ((inode->i_flags & EXT4_INLINE_DATA_FL) && inlinedata_fs &&
+		    EXT2_I_SIZE(inode) > EXT4_MIN_INLINE_DATA_SIZE &&
+		    (ino >= EXT2_FIRST_INODE(fs->super))) {
+			size_t size = 0;
+			errcode_t err;
+			int flags;
+
+			flags = fs->flags;
+			if (failed_csum)
+				fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			err = get_inline_data_ea_size(fs, ino, &size);
+			fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
+				    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
+
+			switch (err) {
+			case 0:
+				/* Everything is awesome... */
+				break;
+			case EXT2_ET_BAD_EA_BLOCK_NUM:
+			case EXT2_ET_BAD_EA_HASH:
+			case EXT2_ET_BAD_EA_HEADER:
+			case EXT2_ET_EA_BAD_NAME_LEN:
+			case EXT2_ET_EA_BAD_VALUE_SIZE:
+			case EXT2_ET_EA_KEY_NOT_FOUND:
+			case EXT2_ET_EA_NO_SPACE:
+			case EXT2_ET_MISSING_EA_FEATURE:
+			case EXT2_ET_INLINE_DATA_CANT_ITERATE:
+			case EXT2_ET_INLINE_DATA_NO_BLOCK:
+			case EXT2_ET_INLINE_DATA_NO_SPACE:
+			case EXT2_ET_NO_INLINE_DATA:
+			case EXT2_ET_EXT_ATTR_CSUM_INVALID:
+			case EXT2_ET_EA_BAD_VALUE_OFFSET:
+				/* broken EA or no system.data EA; truncate */
+				if (fix_problem(ctx, PR_1_INLINE_DATA_NO_ATTR,
+						&pctx)) {
+					err = ext2fs_inode_size_set(fs, inode,
+							sizeof(inode->i_block));
+					if (err) {
+						pctx.errcode = err;
+						ctx->flags |= E2F_FLAG_ABORT;
+						goto endit;
+					}
+					e2fsck_write_inode(ctx, ino, inode,
+							   "pass1");
+					failed_csum = 0;
+				}
+				break;
+			default:
+				/* Some other kind of non-xattr error? */
+				pctx.errcode = err;
+				ctx->flags |= E2F_FLAG_ABORT;
+				goto endit;
+			}
+		}
+
 		/*
 		 * Test for incorrect extent flag settings.
 		 *
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index b982a27..9081277 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1045,6 +1045,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i logical @b %b (physical @b %c) violates cluster allocation rules.\nWill fix in pass 1B.\n"),
 	  PROMPT_NONE, 0 },
 
+	/* Inode has INLINE_DATA_FL flag but extended attribute not found */
+	{ PR_1_INLINE_DATA_NO_ATTR,
+	  N_("@i %i has INLINE_DATA_FL flag but @a not found.  "),
+	  PROMPT_TRUNCATE, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f051c11..1f0be2d 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -609,6 +609,9 @@ struct problem_context {
 /* Inode logical block is misaligned */
 #define PR_1_MISALIGNED_CLUSTER		0x010074
 
+/* Inode has INLINE_DATA_FL flag but extended attribute not found */
+#define PR_1_INLINE_DATA_NO_ATTR	0x010075
+
 /*
  * Pass 1b errors
  */
