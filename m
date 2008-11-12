From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 06/17] Convert mke2fs to new bitmap interface
Date: Tue, 11 Nov 2008 19:42:59 -0800
Message-ID: <1226461390-5502-7-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42468 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbYKLDn4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:43:56 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3hu4Z007445
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:43:56 -0500
In-Reply-To: <1226461390-5502-6-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 misc/mke2fs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index be9f4e6..7c35317 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -289,7 +289,7 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
 		exit(1);
 	}
 	while (ext2fs_badblocks_list_iterate(bb_iter, &blk))
-		ext2fs_mark_block_bitmap(fs->block_map, blk);
+		ext2fs_mark_block_bitmap2(fs->block_map, blk);
 	ext2fs_badblocks_list_iterate_end(bb_iter);
 }
 
@@ -473,7 +473,7 @@ static void create_bad_block_inode(ext2_filsys fs, badblocks_list bb_list)
 {
 	errcode_t	retval;
 
-	ext2fs_mark_inode_bitmap(fs->inode_map, EXT2_BAD_INO);
+	ext2fs_mark_inode_bitmap2(fs->inode_map, EXT2_BAD_INO);
 	ext2fs_inode_alloc_stats2(fs, EXT2_BAD_INO, +1, 0);
 	retval = ext2fs_update_bb_inode(fs, bb_list);
 	if (retval) {
-- 
1.5.6.5

