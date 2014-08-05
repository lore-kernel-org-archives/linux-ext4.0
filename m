From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/21] e2fsck: check inline dir size is a multiple of 4
Date: Mon, 04 Aug 2014 18:06:55 -0700
Message-ID: <20140805010655.2611.5690.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44494 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaHEBHD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:07:03 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Directory entries must have a size that's a multiple of 4; therefore
the inline directory structure must also have a size that is a muliple
of 4.  Since e2fsck doesn't check this, we should check that now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c   |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c |   10 ++++++++
 e2fsck/problem.h |    6 +++++
 3 files changed, 80 insertions(+)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index abf95bd..ed2c4d7 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -772,6 +772,59 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 }
 #undef NEXT_DIRENT
 
+static errcode_t fix_inline_dir_size(e2fsck_t ctx, ext2_ino_t ino,
+				     size_t *inline_data_size,
+				     struct problem_context *pctx,
+				     char *buf)
+{
+	ext2_filsys fs = ctx->fs;
+	struct ext2_inode inode;
+	size_t new_size, old_size;
+	errcode_t retval;
+
+	old_size = *inline_data_size;
+	new_size = old_size + (4 - (old_size & 3));
+	memset(buf + old_size, 0, new_size - old_size);
+	retval = ext2fs_inline_data_set(fs, ino, 0, buf, new_size);
+	if (retval == EXT2_ET_INLINE_DATA_NO_SPACE) {
+		new_size -= 4;
+		retval = ext2fs_inline_data_set(fs, ino, 0, buf, new_size);
+		if (retval) {
+			if (fix_problem(ctx, PR_2_FIX_INLINE_DIR_FAILED,
+					pctx)) {
+				new_size = 0;
+				goto write_inode;
+			}
+			goto err;
+		}
+	} else if (retval) {
+		if (fix_problem(ctx, PR_2_FIX_INLINE_DIR_FAILED,
+				pctx)) {
+			new_size = 0;
+			goto write_inode;
+		}
+		goto err;
+	}
+
+write_inode:
+	retval = ext2fs_read_inode(fs, ino, &inode);
+	if (retval)
+		goto err;
+
+	retval = ext2fs_inode_size_set(fs, &inode, new_size);
+	if (retval)
+		goto err;
+	if (new_size == 0)
+		inode.i_flags &= ~EXT4_INLINE_DATA_FL;
+	retval = ext2fs_write_inode(fs, ino, &inode);
+	if (retval)
+		goto err;
+	*inline_data_size = new_size;
+
+err:
+	return retval;
+}
+
 static int check_dir_block(ext2_filsys fs,
 			   struct ext2_db_entry2 *db,
 			   void *priv_data)
@@ -885,6 +938,17 @@ static int check_dir_block(ext2_filsys fs,
 		cd->pctx.errcode = ext2fs_read_dir_block4(fs, block_nr,
 							  buf, 0, ino);
 inline_read_fail:
+	pctx.ino = ino;
+	pctx.num = inline_data_size;
+	if ((inline_data_size & 3) &&
+	    fix_problem(ctx, PR_2_BAD_INLINE_DIR_SIZE, &pctx)) {
+		errcode_t err = fix_inline_dir_size(ctx, ino,
+						    &inline_data_size, &pctx,
+						    buf);
+		if (err)
+			return DIRENT_ABORT;
+
+	}
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 4245244..4f975e5 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1523,6 +1523,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@d @i %i, %B, offset %N: @d passes checks but fails checksum.\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* inline directory inode size must be a multiple of 4 */
+	{ PR_2_BAD_INLINE_DIR_SIZE,
+	  N_("Inline @d @i %i size (%N) must be a multiple of 4.\n"),
+	  PROMPT_FIX, 0 },
+
+	/* fixing size of inline directory inode failed */
+	{ PR_2_FIX_INLINE_DIR_FAILED,
+	  N_("Fixing size of inline @d @i %i failed.\n"),
+	  PROMPT_TRUNCATE, 0 },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 22c86c5..e901c8e 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -906,6 +906,12 @@ struct problem_context {
 /* dir leaf node passes checks, but fails checksum */
 #define PR_2_LEAF_NODE_ONLY_CSUM_INVALID	0x02004D
 
+/* bad inline directory size */
+#define PR_2_BAD_INLINE_DIR_SIZE	0x02004E
+
+/* fixing inline dir size failed */
+#define PR_2_FIX_INLINE_DIR_FAILED	0x02004F
+
 /*
  * Pass 3 errors
  */

