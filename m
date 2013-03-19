From: Andrey Sidorov <qrxd43@motorola.com>
Subject: [PATCH 1/5] libext2fs: Optimize ext2fs_allocate_group_table()
Date: Tue, 19 Mar 2013 20:06:00 +0400
Message-ID: <1363709164-3210-2-git-send-email-qrxd43@motorola.com>
References: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:41388 "EHLO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3CSQGX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 12:06:23 -0400
Received: from il93mgrg01.am.mot-mobility.com ([10.22.94.168])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id r2JFsu1b021374
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 11:54:56 -0400 (EDT)
Received: from mail-ee0-f54.google.com (mail-ee0-f54.google.com [74.125.83.54])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id r2JFstcq021330
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 11:54:56 -0400 (EDT)
Received: by mail-ee0-f54.google.com with SMTP id c41so326368eek.27
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 09:06:20 -0700 (PDT)
In-Reply-To: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Iterate over groups instead of blocks.

Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>
---
 lib/ext2fs/alloc_tables.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 5e6e556..e51dcee 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -205,16 +205,27 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 						bmap, &new_blk);
 		if (retval)
 			return retval;
-		for (j=0, blk = new_blk;
-		     j < fs->inode_blocks_per_group;
-		     j++, blk++) {
-			ext2fs_mark_block_bitmap2(bmap, blk);
-			if (flexbg_size) {
-				dgrp_t gr = ext2fs_group_of_blk2(fs, blk);
-				ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
-				ext2fs_free_blocks_count_add(fs->super, -1);
-				ext2fs_bg_flags_clear(fs, gr,
-						     EXT2_BG_BLOCK_UNINIT);
+
+		ext2fs_mark_block_bitmap_range2(bmap, new_blk, fs->inode_blocks_per_group);
+		if (flexbg_size) {
+			blk64_t last_blk = new_blk + fs->inode_blocks_per_group - 1;
+			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
+			dgrp_t last_gr = ext2fs_group_of_blk2(fs, last_blk);
+
+			ext2fs_free_blocks_count_add(fs->super, -(blk64_t)(fs->inode_blocks_per_group));
+			for (; gr <= last_gr; ++gr) {
+				blk64_t gr_first_blk = ext2fs_group_first_block2(fs, gr);
+				blk64_t gr_last_blk = ext2fs_group_last_block2(fs, gr);
+				__u32 free_blocks = ext2fs_bg_free_blocks_count(fs, gr);
+				if (gr_first_blk < new_blk)
+					gr_first_blk = new_blk;
+				if (gr_last_blk > last_blk)
+					gr_last_blk = last_blk;
+
+				free_blocks -= (__u32)(gr_last_blk - gr_first_blk + 1);
+
+				ext2fs_bg_free_blocks_count_set(fs, gr, free_blocks);
+				ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
 				ext2fs_group_desc_csum_set(fs, gr);
 			}
 		}
-- 
1.7.10.4

