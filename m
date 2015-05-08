From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: misc: fix Coverity bugs
Date: Fri, 8 May 2015 12:07:48 -0700
Message-ID: <20150508190748.GC30577@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18035 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbEHTH5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 May 2015 15:07:57 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix Coverity bugs 1297093 and 1297096.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/extents.c   |   10 +++++++---
 e2fsck/readahead.c |    2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/e2fsck/extents.c b/e2fsck/extents.c
index a08fa94..e1a027f 100644
--- a/e2fsck/extents.c
+++ b/e2fsck/extents.c
@@ -27,6 +27,8 @@ static errcode_t e2fsck_rebuild_extents(e2fsck_t ctx, ext2_ino_t ino);
 /* Schedule an inode to have its extent tree rebuilt during pass 1E. */
 errcode_t e2fsck_rebuild_extents_later(e2fsck_t ctx, ext2_ino_t ino)
 {
+	errcode_t retval = 0;
+
 	if (!EXT2_HAS_INCOMPAT_FEATURE(ctx->fs->super,
 				       EXT3_FEATURE_INCOMPAT_EXTENTS) ||
 	    (ctx->options & E2F_OPT_NO) ||
@@ -37,13 +39,15 @@ errcode_t e2fsck_rebuild_extents_later(e2fsck_t ctx, ext2_ino_t ino)
 		return e2fsck_rebuild_extents(ctx, ino);
 
 	if (!ctx->inodes_to_rebuild)
-		e2fsck_allocate_inode_bitmap(ctx->fs,
+		retval = e2fsck_allocate_inode_bitmap(ctx->fs,
 					     _("extent rebuild inode map"),
 					     EXT2FS_BMAP64_RBTREE,
 					     "inodes_to_rebuild",
 					     &ctx->inodes_to_rebuild);
-	if (ctx->inodes_to_rebuild)
-		ext2fs_mark_inode_bitmap2(ctx->inodes_to_rebuild, ino);
+	if (retval)
+		return retval;
+
+	ext2fs_mark_inode_bitmap2(ctx->inodes_to_rebuild, ino);
 	return 0;
 }
 
diff --git a/e2fsck/readahead.c b/e2fsck/readahead.c
index 4429a37..a860f2b 100644
--- a/e2fsck/readahead.c
+++ b/e2fsck/readahead.c
@@ -242,7 +242,7 @@ unsigned long long e2fsck_guess_readahead(ext2_filsys fs)
 	 * worth of inode table blocks seems to yield the largest reductions
 	 * in e2fsck runtime.
 	 */
-	guess = 2 * fs->blocksize * fs->inode_blocks_per_group;
+	guess = 2ULL * fs->blocksize * fs->inode_blocks_per_group;
 
 	/* Disable RA if it'd use more 1/50th of RAM. */
 	if (get_memory_size() > (guess * 50))
