From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] resize2fs: clear uninit BG if allocating from new group
Date: Thu, 17 Sep 2015 17:42:18 -0500
Message-ID: <55FB41CA.8010003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbbIQWmY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Sep 2015 18:42:24 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 25DBDC07585F
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2015 22:42:24 +0000 (UTC)
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t8HMgMEc028244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2015 18:42:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If resize2fs_get_alloc_block() allocates from a BLOCK_UNINIT
group, nothing clears the UNINIT flag, so it is skipped when we
go to write out modified bitmaps.  This leads to post-resize2fs
e2fsck errors; used blocks in UNINIT groups, not marked in the
block bitmap.

This shamelessly cuts & pastes clear_block_uninit() into
resize2fs.c, and my problem goes away.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I've kind of lost the thread on resize2fs lately, so maybe this is
a hack job?  At least it highlights the issue, even if it's not
quite right.  Passes "make check" here and seems ok to me...

Thanks,
-Eric

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 07c6a0c..0f202bd 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1614,12 +1614,27 @@ static blk64_t get_new_block(ext2_resize_t rfs)
 	}
 }
 
+static void clear_block_uninit(ext2_filsys fs, dgrp_t group)
+{
+	if (!ext2fs_has_group_desc_csum(fs) ||
+	    !(ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
+		return;
+
+	/* uninit block bitmaps are now initialized in read_bitmaps() */
+
+	ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+	ext2fs_group_desc_csum_set(fs, group);
+	ext2fs_mark_super_dirty(fs);
+	ext2fs_mark_bb_dirty(fs);
+}
+
 static errcode_t resize2fs_get_alloc_block(ext2_filsys fs,
 					   blk64_t goal EXT2FS_ATTR((unused)),
 					   blk64_t *ret)
 {
 	ext2_resize_t rfs = (ext2_resize_t) fs->priv_data;
 	blk64_t blk;
+	int group;
 
 	blk = get_new_block(rfs);
 	if (!blk)
@@ -1632,6 +1647,12 @@ static errcode_t resize2fs_get_alloc_block(ext2_filsys fs,
 
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

