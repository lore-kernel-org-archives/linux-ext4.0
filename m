From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH v.2] Fix ext2fs_set_gdt_csum() to use access functions.
Date: Thu, 03 Sep 2009 17:18:46 -0400
Message-ID: <8879.1252012726@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:13548 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbZICVXl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 17:23:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Per Eric Sandeens' comments:

Fixed whitespace damage, reworded the commit message, and simplified
the flag setting/clearing.

I didn't do anything about old_unused needing, strictly speaking, 64 bits
currently; it should be 32, but that was part of the patch that I sent
out a couple of days ago, so that makes this patch depend on the earlier
one to avoid the compiler warning on the size mismatch. I could change
it however.

Comments welcome.

Thanks,
Nick



>From 583a476e8f8e7a778cb8328cc34b76941b58aa4e Mon Sep 17 00:00:00 2001
From: Nick Dokos <nicholas.dokos@hp.com>
Date: Thu, 3 Sep 2009 16:54:42 -0400
Subject: 

Replace all field accesses with calls to access functions.
Originally, the function stepped through the gdt using a pointer and
assuming that it knew the type of a gdt entry. This is no longer true:
different filesystems may have entries of different types. In fact,
Andreas Dilger has suggested that the entry type be made opaque, so
that the compiler will find errors of this type (this patch does not
address that suggestion.)

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/csum.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index a0f25e3..120ce6f 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -105,7 +105,6 @@ static __u32 find_last_inode_ingrp(ext2fs_inode_bitmap bitmap,
 errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 {
 	struct ext2_super_block *sb = fs->super;
-	struct ext2_group_desc *bg = fs->group_desc;
 	int dirty = 0;
 	dgrp_t i;
 
@@ -116,27 +115,31 @@ errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 					EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		return 0;
 
-	for (i = 0; i < fs->group_desc_count; i++, bg++) {
-		int old_csum = bg->bg_checksum;
-		int old_unused = bg->bg_itable_unused;
-		int old_flags = bg->bg_flags;
+	for (i = 0; i < fs->group_desc_count; i++) {
+		unsigned int old_csum = ext2fs_bg_checksum(fs, i);
+		int old_unused = ext2fs_bg_itable_unused(fs, i);
+		unsigned int old_flags = ext2fs_bg_flags(fs, i);
+		int old_free_inodes_count = ext2fs_bg_free_inodes_count(fs, i);
 
-		if (bg->bg_free_inodes_count == sb->s_inodes_per_group) {
-			bg->bg_flags |= EXT2_BG_INODE_UNINIT;
-			bg->bg_itable_unused = sb->s_inodes_per_group;
+		if (old_free_inodes_count == sb->s_inodes_per_group) {
+			ext2fs_bg_flag_set(fs, i, EXT2_BG_INODE_UNINIT);
+			ext2fs_bg_itable_unused_set(fs, i, sb->s_inodes_per_group);
 		} else {
-			bg->bg_flags &= ~EXT2_BG_INODE_UNINIT;
-			bg->bg_itable_unused = sb->s_inodes_per_group -
+			int unused =
+				sb->s_inodes_per_group -
 				find_last_inode_ingrp(fs->inode_map,
-						      sb->s_inodes_per_group,i);
+						      sb->s_inodes_per_group, i);
+
+			ext2fs_bg_flag_clear(fs, i, EXT2_BG_INODE_UNINIT);
+			ext2fs_bg_itable_unused_set(fs, i, unused);
 		}
 
 		ext2fs_group_desc_csum_set(fs, i);
-		if (old_flags != bg->bg_flags)
+		if (old_flags != ext2fs_bg_flags(fs, i))
 			dirty = 1;
-		if (old_unused != bg->bg_itable_unused)
+		if (old_unused != ext2fs_bg_itable_unused(fs, i))
 			dirty = 1;
-		if (old_csum != bg->bg_checksum)
+		if (old_csum != ext2fs_bg_checksum(fs, i))
 			dirty = 1;
 	}
 	if (dirty)
-- 
1.6.0.6

