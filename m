From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] resize2fs: clear uninit BG if allocating from new group
Date: Thu, 14 Jan 2016 12:46:03 -0600
Message-ID: <5697ECEB.3020408@redhat.com>
References: <55FB41CA.8010003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802AbcANSqF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jan 2016 13:46:05 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 165921836
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2016 18:46:05 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u0EIk40e025153
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jan 2016 13:46:04 -0500
In-Reply-To: <55FB41CA.8010003@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If resize2fs_get_alloc_block() allocates from a BLOCK_UNINIT
group, nothing clears the UNINIT flag, so it is skipped when we
go to write out modified bitmaps.  This leads to post-resize2fs
e2fsck errors; used blocks in UNINIT groups, not marked in the
block bitmap.  This was seen on r_ext4_small_bg.

This patch uses clear_block_uninit() to clear the flag,
and my problem goes away.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: don't cut and paste, sorry! :)

Thanks,
-Eric

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 86e7f99..9a575fd 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -39,7 +39,7 @@
 /*
  * Clear the uninit block bitmap flag if necessary
  */
-static void clear_block_uninit(ext2_filsys fs, dgrp_t group)
+void clear_block_uninit(ext2_filsys fs, dgrp_t group)
 {
 	if (!ext2fs_has_group_desc_csum(fs) ||
 	    !(ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 86d860f..0dca002 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -647,6 +647,7 @@ static inline int ext2fs_needs_large_file_feature(unsigned long long file_size)
 }
 
 /* alloc.c */
+extern void clear_block_uninit(ext2_filsys fs, dgrp_t group);
 extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int mode,
 				  ext2fs_inode_bitmap map, ext2_ino_t *ret);
 extern errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 07c6a0c..ffe9473 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1620,6 +1620,7 @@ static errcode_t resize2fs_get_alloc_block(ext2_filsys fs,
 {
 	ext2_resize_t rfs = (ext2_resize_t) fs->priv_data;
 	blk64_t blk;
+	int group;
 
 	blk = get_new_block(rfs);
 	if (!blk)
@@ -1632,6 +1633,12 @@ static errcode_t resize2fs_get_alloc_block(ext2_filsys fs,
 
 	ext2fs_mark_block_bitmap2(rfs->old_fs->block_map, blk);
 	ext2fs_mark_block_bitmap2(rfs->new_fs->block_map, blk);
+
+	group = ext2fs_group_of_blk2(rfs->old_fs, blk);
+	clear_block_uninit(rfs->old_fs, group);
+	group = ext2fs_group_of_blk2(rfs->new_fs, blk);
+	clear_block_uninit(rfs->new_fs, group);
+
 	*ret = (blk64_t) blk;
 	return 0;
 }

