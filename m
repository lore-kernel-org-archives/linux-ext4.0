From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] libext2fs: avoid buffer overflow if s_first_meta_bg is too big
Date: Sat,  9 Aug 2014 13:10:15 -0400
Message-ID: <1407604220-2620-1-git-send-email-tytso@mit.edu>
Cc: antymat+debian@chelmska.waw.pl, 756922@bugs.debian.org,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52426 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaHIRK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Aug 2014 13:10:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If s_first_meta_bg is greater than the number block group descriptor
blocks, then reading or writing the block group descriptors will end
up overruning the memory buffer allocated for the descriptors.  Fix
this by limiting first_meta_bg to no more than fs->desc_blocks.  This
doesn't correct the bad s_first_meta_bg value, but it avoids causing
the e2fsprogs userspace programs from potentially crashing.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/closefs.c | 6 ++++--
 lib/ext2fs/openfs.c  | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 4599eef..1f99113 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -344,9 +344,11 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	 * superblocks and group descriptors.
 	 */
 	group_ptr = (char *) group_shadow;
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) {
 		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
+		if (old_desc_blocks > fs->super->s_first_meta_bg)
+			old_desc_blocks = fs->desc_blocks;
+	} else
 		old_desc_blocks = fs->desc_blocks;
 
 	ext2fs_numeric_progress_init(fs, &progress, NULL,
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index a1a3517..ba501e6 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -378,9 +378,11 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 #ifdef WORDS_BIGENDIAN
 	groups_per_block = EXT2_DESC_PER_BLOCK(fs->super);
 #endif
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) {
 		first_meta_bg = fs->super->s_first_meta_bg;
-	else
+		if (first_meta_bg > fs->desc_blocks)
+			first_meta_bg = fs->desc_blocks;
+	} else
 		first_meta_bg = fs->desc_blocks;
 	if (first_meta_bg) {
 		retval = io_channel_read_blk(fs->io, group_block +
-- 
2.0.0

