From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/5] ext4: don't crash when validating block bitmap
Date: Thu, 01 May 2014 16:17:47 -0700
Message-ID: <20140501231747.892.95073.stgit@birch.djwong.org>
References: <20140501231720.892.58712.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29579 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaEAXRv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:17:51 -0400
In-Reply-To: <20140501231720.892.58712.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If EXT4FS_DEBUG is defined, ext4_validate_block_bitmap is called via
ext4_count_free_clusters before sb->s_group_info is set up.  When this
happens, the kernel crashes because group info hasn't been loaded.
Forego marking the group corrupt for now; not setting BH_Verified
means we'll revisit the bitmap if something went wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/balloc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 59c3ba8..8f7bed0 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -357,7 +357,10 @@ void ext4_validate_block_bitmap(struct super_block *sb,
 			       struct buffer_head *bh)
 {
 	ext4_fsblk_t	blk;
-	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
+	struct ext4_group_info *grp = NULL;
+
+	if (EXT4_SB(sb)->s_group_info)
+		grp = ext4_get_group_info(sb, block_group);
 
 	if (buffer_verified(bh))
 		return;
@@ -368,14 +371,18 @@ void ext4_validate_block_bitmap(struct super_block *sb,
 		ext4_unlock_group(sb, block_group);
 		ext4_error(sb, "bg %u: block %llu: invalid block bitmap",
 			   block_group, blk);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		if (grp)
+			set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
+				&grp->bb_state);
 		return;
 	}
 	if (unlikely(!ext4_block_bitmap_csum_verify(sb, block_group,
 			desc, bh))) {
 		ext4_unlock_group(sb, block_group);
 		ext4_error(sb, "bg %u: bad block bitmap checksum", block_group);
-		set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT, &grp->bb_state);
+		if (grp)
+			set_bit(EXT4_GROUP_INFO_BBITMAP_CORRUPT_BIT,
+				&grp->bb_state);
 		return;
 	}
 	set_buffer_verified(bh);

