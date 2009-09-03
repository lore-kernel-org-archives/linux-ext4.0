From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2fs: last of the incorrect direct group_desc accesses
Date: Thu, 03 Sep 2009 16:02:04 -0500
Message-ID: <4AA02ECC.4010101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbZICVCE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Sep 2009 17:02:04 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n83L26mR014308
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 17:02:06 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n83L24At001901
	for <linux-ext4@vger.kernel.org>; Thu, 3 Sep 2009 17:02:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This should be, I hope, the last of the fixes for accessing
the group descriptors directly in libext2fs, at least.

Soon we should make it opaque to avoid this mess.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/openfs.c
+++ e2fsprogs/lib/ext2fs/openfs.c
@@ -355,7 +355,7 @@ errcode_t ext2fs_open2(const char *name,
 		for (group = 0; group < fs->group_desc_count; group++) {
 			ext2fs_bg_flag_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 			ext2fs_bg_flag_clear(fs, group, EXT2_BG_INODE_UNINIT);
-			fs->group_desc[group].bg_itable_unused = 0;
+			ext2fs_bg_itable_unused_set(fs, group, 0);
 		}
 		ext2fs_mark_super_dirty(fs);
 	}
Index: e2fsprogs/e2fsck/pass2.c
===================================================================
--- e2fsprogs.orig/e2fsck/pass2.c
+++ e2fsprogs/e2fsck/pass2.c
@@ -1003,7 +1003,7 @@ out_htree:
 		} else if (dirent->inode >= first_unused_inode) {
 			pctx.num = dirent->inode;
 			if (fix_problem(ctx, PR_2_INOREF_IN_UNUSED, &cd->pctx)){
-				fs->group_desc[group].bg_itable_unused = 0;
+				ext2fs_bg_itable_unused_set(fs, group, 0);
 				ext2fs_mark_super_dirty(fs);
 				ctx->flags |= E2F_FLAG_RESTART_LATER;
 			} else {

