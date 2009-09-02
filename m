From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2fs: use proper functions to set/clear block group
 flags
Date: Wed, 02 Sep 2009 15:36:42 -0500
Message-ID: <4A9ED75A.7030406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Justin Maggard <jmaggard10@gmail.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZIBUgn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Sep 2009 16:36:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As Justin & Ric reported, something like this on a
22T (sparse) bigfile:

	e2fsprogs/misc/mke2fs -E lazy_itable_init=1 \
			      -O uninit_bg -b 4096 bigfile
	mount -o loop bigfile mnt/
	for I in `seq 1 5`; do mkdir mnt/$I; done
	umount mnt/
	e2fsprogs/e2fsck/e2fsck -f bigfile

would give us corrupted block group checksums:

	<other problems related to uninit snipped>
	One or more block group descriptor checksums are invalid.  Fix<y>? yes

	Group descriptor 6301 checksum is invalid.  FIXED.
	Group descriptor 7799 checksum is invalid.  FIXED.

There wer=re a few places which accessed bg_flags directly 
rather than using the helper functions; fixing these seems
to resolve the problem.

Reported-by: Justin Maggard <jmaggard10@gmail.com>
Reported-by: Ric Wheeler <rwheeler@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Applies to the pu branch

Index: e2fsprogs/e2fsck/pass2.c
===================================================================
--- e2fsprogs.orig/e2fsck/pass2.c
+++ e2fsprogs/e2fsck/pass2.c
@@ -987,12 +987,12 @@ out_htree:
 		 * we could call a function in pass1.c that checks the
 		 * newly visible inodes.
 		 */
-		if (fs->group_desc[group].bg_flags & EXT2_BG_INODE_UNINIT) {
+		if (ext2fs_bg_flag_test(fs, group, EXT2_BG_INODE_UNINIT)) {
 			pctx.num = dirent->inode;
 			if (fix_problem(ctx, PR_2_INOREF_BG_INO_UNINIT,
 					&cd->pctx)){
-				fs->group_desc[group].bg_flags &=
-					~EXT2_BG_INODE_UNINIT;
+				ext2fs_bg_flags_clear(fs, group,
+						      EXT2_BG_INODE_UNINIT);
 				ext2fs_mark_super_dirty(fs);
 				ctx->flags |= E2F_FLAG_RESTART_LATER;
 			} else {
Index: e2fsprogs/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/openfs.c
+++ e2fsprogs/lib/ext2fs/openfs.c
@@ -350,11 +350,12 @@ errcode_t ext2fs_open2(const char *name,
 	if (superblock > 1 && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
 		struct ext2_group_desc *gd;
-		for (i = 0, gd = fs->group_desc; i < fs->group_desc_count;
-		     i++, gd++) {
-			gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
-			gd->bg_flags &= ~EXT2_BG_INODE_UNINIT;
-			gd->bg_itable_unused = 0;
+		dgrp_t group;
+
+		for (group = 0; group < fs->group_desc_count; group++) {
+			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+			ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
+			fs->group_desc[group].bg_itable_unused = 0;
 		}
 		ext2fs_mark_super_dirty(fs);
 	}

