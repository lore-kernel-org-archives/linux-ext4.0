From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 12/25] e2fsck: Don't store old_op from ehandler_operation if we don't restore it.
Date: Fri, 16 Sep 2011 15:49:27 -0500
Message-ID: <1316206180-6375-13-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46747 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab1IPUtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:45 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

old_op is set but never used, because we restore "0"
not old_op.  So don't bother with it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 e2fsck/pass1.c |    3 +--
 e2fsck/pass2.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 16ddcda..4c3fe3f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -402,7 +402,6 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 {
 	struct ext2_inode *inode = pctx->inode;
 	struct ext2_dir_entry 	*dirent;
-	const char		*old_op;
 	errcode_t		retval;
 	blk64_t			blk;
 	unsigned int		i, rec_len, not_device = 0;
@@ -472,7 +471,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 		return;
 
 	/* read the first block */
-	old_op = ehandler_operation(_("reading directory block"));
+	ehandler_operation(_("reading directory block"));
 	retval = ext2fs_read_dir_block3(ctx->fs, blk, buf, 0);
 	ehandler_operation(0);
 	if (retval)
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 9c44aa2..43ba5b2 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -711,7 +711,6 @@ static int check_dir_block(ext2_filsys fs,
 	struct ext2_dir_entry 	*dirent, *prev;
 	ext2_dirhash_t		hash;
 	unsigned int		offset = 0;
-	const char *		old_op;
 	int			dir_modified = 0;
 	int			dot_state;
 	unsigned int		rec_len;
@@ -774,7 +773,7 @@ static int check_dir_block(ext2_filsys fs,
 	       db->blockcnt, ino);
 #endif
 
-	old_op = ehandler_operation(_("reading directory block"));
+	ehandler_operation(_("reading directory block"));
 	cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, 0);
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
-- 
1.7.4.1

