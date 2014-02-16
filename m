From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: fix online resize with a non-standard blocks per group setting
Date: Sat, 15 Feb 2014 22:42:44 -0500
Message-ID: <1392522164-28841-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58461 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbaBPDmu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Feb 2014 22:42:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The set_flexbg_block_bitmap() function assumed that the number of
blocks in a blockgroup was sb->blocksize * 8, which is normally true,
but not always!  Use EXT4_BLOCKS_PER_GROUP(sb) instead, to fix block
bitmap corruption after:

mke2fs -t ext4 -g 3072 -i 4096 /dev/vdd 1G
mount -t ext4 /dev/vdd /vdd
resize2fs /dev/vdd 8G

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 69a6261..f3b84cd 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -409,7 +409,7 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
 		start = ext4_group_first_block_no(sb, group);
 		group -= flex_gd->groups[0].group;
 
-		count2 = sb->s_blocksize * 8 - (block - start);
+		count2 = EXT4_BLOCKS_PER_GROUP(sb) - (block - start);
 		if (count2 > count)
 			count2 = count;
 
-- 
1.8.5.rc3.362.gdf10213

