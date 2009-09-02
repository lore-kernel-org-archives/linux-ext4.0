From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: remove misleading argument from ext2fs_bg_flags_clear
Date: Wed, 02 Sep 2009 16:43:00 -0500
Message-ID: <4A9EE6E4.2000307@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZIBVm6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 17:42:58 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n82Lh1TQ026798
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 17:43:01 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n82Lh09c013684
	for <linux-ext4@vger.kernel.org>; Wed, 2 Sep 2009 17:43:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_bg_flags_clear shouldn't take an unused bg_flags argument
if its purpose is to clear -all- flags.  That just makes people
like me call it for the wrong purpose ;)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/ext2fs/blknum.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/blknum.c
+++ e2fsprogs/lib/ext2fs/blknum.c
@@ -435,9 +435,9 @@ void ext2fs_bg_flags_set(ext2_filsys fs,
 }
 
 /*
- * Clear the flags for this block group
+ * Clear all flags for this block group
  */
-void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flags)
+void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group)
 {
 	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
 		struct ext4_group_desc *gdp;
Index: e2fsprogs/lib/ext2fs/csum.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/csum.c
+++ e2fsprogs/lib/ext2fs/csum.c
@@ -204,7 +204,7 @@ int main(int argc, char **argv)
 		fs->group_desc[i].bg_free_blocks_count = 31119;
 		fs->group_desc[i].bg_free_inodes_count = 15701;
 		fs->group_desc[i].bg_used_dirs_count = 2;
-		ext2fs_bg_flags_clear(fs, i, 0);
+		ext2fs_bg_flags_clear(fs, i);
 	};
 
 	csum1 = ext2fs_group_desc_csum(fs, 0);
Index: e2fsprogs/resize/resize2fs.c
===================================================================
--- e2fsprogs.orig/resize/resize2fs.c
+++ e2fsprogs/resize/resize2fs.c
@@ -495,7 +495,7 @@ retry:
 		       sizeof(struct ext2_group_desc));
 		adjblocks = 0;
 
-		ext2fs_bg_flags_clear(fs, i, 0);
+		ext2fs_bg_flags_clear(fs, i);
 		if (csum_flag)
 			ext2fs_bg_flag_set(fs, i, EXT2_BG_INODE_UNINIT | EXT2_BG_INODE_ZEROED)
 				;
Index: e2fsprogs/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs/lib/ext2fs/ext2fs.h
@@ -777,8 +777,7 @@ extern void ext2fs_bg_itable_unused_set(
 				     blk64_t blk);
 extern __u16 ext2fs_bg_flags(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
-extern void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group,
-				  __u16 bg_flags);
+extern void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group);
 extern int ext2fs_bg_flag_test(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
 extern void ext2fs_bg_flag_set(ext2_filsys fs, dgrp_t group, __u16 bg_flag);
 extern void ext2fs_bg_flag_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flag);

