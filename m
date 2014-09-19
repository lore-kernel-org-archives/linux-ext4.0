From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] e2fsck: use ext2fs_get_mem() instad of ext2fs_get_memalign()
Date: Fri, 19 Sep 2014 01:50:58 -0400
Message-ID: <1411105858-21120-4-git-send-email-tytso@mit.edu>
References: <1411105858-21120-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36945 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaISFvE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Sep 2014 01:51:04 -0400
In-Reply-To: <1411105858-21120-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no reason to request a aligned buffer in
check_{inode,block}_bitmap, and this will cause failures for dietlibc,
which doesn't have support for posix_memalign() or any other way to
request an aligned memory allocation.  Fortunately, this is only
needed in very few places where direct I/O is required.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 e2fsck/pass5.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 86ac9fd..8d6032b 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -99,8 +99,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 		return;
 
 	nbytes = (size_t)(EXT2_INODES_PER_GROUP(ctx->fs->super) / 8);
-	retval = ext2fs_get_memalign(ctx->fs->blocksize, ctx->fs->blocksize,
-				     &buf);
+	retval = ext2fs_get_mem(ctx->fs->blocksize, &buf);
 	if (retval) {
 		com_err(ctx->program_name, 0, "%s",
 		    _("check_inode_bitmap_checksum: Memory allocation error"));
@@ -155,8 +154,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 		return;
 
 	nbytes = (size_t)(EXT2_CLUSTERS_PER_GROUP(ctx->fs->super) / 8);
-	retval = ext2fs_get_memalign(ctx->fs->blocksize, ctx->fs->blocksize,
-				     &buf);
+	retval = ext2fs_get_mem(ctx->fs->blocksize, &buf);
 	if (retval) {
 		com_err(ctx->program_name, 0, "%s",
 		    _("check_block_bitmap_checksum: Memory allocation error"));
-- 
2.1.0

