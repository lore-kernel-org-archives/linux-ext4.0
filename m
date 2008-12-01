From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 2/4] ext4: mark the blocks/inode bitmap beyond end of group as used.
Date: Mon,  1 Dec 2008 19:13:44 +0530
Message-ID: <1228139026-22736-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1228139026-22736-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:54396 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYLANn4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 08:43:56 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id mB1Dhrbh011811
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 19:13:53 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB1Dh8fJ3453170
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 19:13:08 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id mB1DhqlM015872
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 00:43:52 +1100
In-Reply-To: <1228139026-22736-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to mark the block/inode bitmap beyond end of grou
with '1'

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ialloc.c  |    2 +-
 fs/ext4/mballoc.c |    4 ++--
 fs/ext4/resize.c  |    6 ++----
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1627868..cd5759d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -84,7 +84,7 @@ unsigned ext4_init_inode_bitmap(struct super_block *sb, struct buffer_head *bh,
 	}
 
 	memset(bh->b_data, 0, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
-	mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), EXT4_BLOCKS_PER_GROUP(sb),
+	mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), sb->s_blocksize * 8,
 			bh->b_data);
 
 	return EXT4_INODES_PER_GROUP(sb);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5d4105d..24fc3ab 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3044,8 +3044,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	    in_range(block + len - 1, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group)) {
 		ext4_error(sb, __func__,
-			   "Allocating block in system zone - block = %llu",
-			   block);
+			   "Allocating block %llu in system zone of %d group\n",
+			   block, ac->ac_b_ex.fe_group);
 		/* File system mounted not to panic on error
 		 * Fix the bitmap and repeat the block allocation
 		 * We leak some of the blocks here.
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 6a62360..ef143f4 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -284,11 +284,9 @@ static int setup_new_group_blocks(struct super_block *sb,
 	if ((err = extend_or_restart_transaction(handle, 2, bh)))
 		goto exit_bh;
 
-	mark_bitmap_end(input->blocks_count, EXT4_BLOCKS_PER_GROUP(sb),
-			bh->b_data);
+	mark_bitmap_end(input->blocks_count, sb->s_blocksize * 8, bh->b_data);
 	ext4_journal_dirty_metadata(handle, bh);
 	brelse(bh);
