From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: correctly write up the backup superblocks in big endian systems
Date: Sun,  4 Jun 2017 18:51:55 -0400
Message-ID: <20170604225155.16544-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42460 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751311AbdFDWwA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 4 Jun 2017 18:52:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This bug has been around since we added support for metadata
checksums, but it was unmasked by commit bf9f3b6d5b ("e2fsck: exit
with exit status 0 if no errors were fixed").  The backup superblocks
are not supposed to have the EXT2_VALID_FS or the NEEDS_RECOVERY bits
set, and earlier 1.43.x versions of e2fsprogs were byte swapping the
shadow superblock each time it was written, so that every other backup
superblock was incorrectly byte swapped.

Fortunately the primary backup superblock was correctly written
(modulo having the VALID_FS bit set when it should not have been set)
so for the most part no one noticed.  And very few architectures use
big endian byte ordering these days.  (Even IBM has seen the light
with the ppcle architecture.  :-)

Fortunately commit bf9f3b6d5b caused f_desc_size_bad and
f_resize_inode to fail on a big endian system, which allowed me to
notice the issue and investigate.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/closefs.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index b255759e..76444c05 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -260,10 +260,8 @@ static errcode_t write_backup_super(ext2_filsys fs, dgrp_t group,
 	if (sgrp > ((1 << 16) - 1))
 		sgrp = (1 << 16) - 1;
 
-	super_shadow->s_block_group_nr = sgrp;
-#ifdef WORDS_BIGENDIAN
-	ext2fs_swap_super(super_shadow);
-#endif
+	super_shadow->s_block_group_nr = ext2fs_cpu_to_le16(sgrp);
+
 	retval = ext2fs_superblock_csum_set(fs, super_shadow);
 	if (retval)
 		return retval;
@@ -316,7 +314,15 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 			goto errout;
 	}
 
-	/* Prepare the group descriptors for writing */
+	/*
+	 * Set the state of the FS to be non-valid.  (The state has
+	 * already been backed up earlier, and will be restored after
+	 * we write out the backup superblocks.)
+	 */
+	fs->super->s_state &= ~EXT2_VALID_FS;
+	ext2fs_clear_feature_journal_needs_recovery(fs->super);
+
+	/* Byte swap the superblock and the group descriptors if necessary */
 #ifdef WORDS_BIGENDIAN
 	retval = EXT2_ET_NO_MEMORY;
 	retval = ext2fs_get_mem(SUPERBLOCK_SIZE, &super_shadow);
@@ -330,7 +336,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	memcpy(group_shadow, fs->group_desc, (size_t) fs->blocksize *
 	       fs->desc_blocks);
 
-	/* swap the group descriptors */
+	ext2fs_swap_super(super_shadow);
 	for (j = 0; j < fs->group_desc_count; j++) {
 		gdp = ext2fs_group_desc(fs, group_shadow, j);
 		ext2fs_swap_group_desc2(fs, gdp);
@@ -341,14 +347,6 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 #endif
 
 	/*
-	 * Set the state of the FS to be non-valid.  (The state has
-	 * already been backed up earlier, and will be restored after
-	 * we write out the backup superblocks.)
-	 */
-	fs->super->s_state &= ~EXT2_VALID_FS;
-	ext2fs_clear_feature_journal_needs_recovery(fs->super);
