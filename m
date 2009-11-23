From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] ext4: delalloc quota fixes
Date: Tue, 24 Nov 2009 01:58:55 +0300
Message-ID: <1259017138-19165-1-git-send-email-dmonakhov@openvz.org>
References: <877hthytz0.fsf@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:56131 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbZKWW6x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 17:58:53 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KTL00DOP41TE510@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Tue, 24 Nov 2009 02:03:32 +0300 (MSK)
In-reply-to: <877hthytz0.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fix most visible problems with delalloc+quota issues
- ext4_get_reserved_space() must return bytes instead of blocks.
- Claim allocated meta blocks. Do it as we do for data blocks
  but delay it untill proper moment.
- Move space claiming to ext4_da_update_reserve_space()
  Only here we do know what we are dealing with data or metadata

The most useful test case for delalloc+quota is concurent tasks
with write+truncate vs chown for a same file.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c   |   12 ++++++++----
 fs/ext4/mballoc.c |    6 ------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ab22297..e642cdb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1057,7 +1057,7 @@ qsize_t ext4_get_reserved_space(struct inode *inode)
 		EXT4_I(inode)->i_reserved_meta_blocks;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
-	return total;
+	return (total << inode->i_blkbits);
 }
 /*
  * Calculate the number of metadata blocks need to reserve
@@ -1096,7 +1096,7 @@ static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
 static void ext4_da_update_reserve_space(struct inode *inode, int used)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int total, mdb, mdb_free;
+	int total, mdb, mdb_free, mdb_claim = 0;
 
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	/* recalculate the number of metablocks still need to be reserved */
@@ -1109,7 +1109,9 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 
 	if (mdb_free) {
 		/* Account for allocated meta_blocks */
-		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
+		BUG_ON(mdb_free < mdb_claim);
+		mdb_free -= mdb_claim;
 
 		/* update fs dirty blocks counter */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
@@ -1119,7 +1121,9 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 
 	/* update per-inode reservations */
 	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
-	EXT4_I(inode)->i_reserved_data_blocks -= used;
+ 	EXT4_I(inode)->i_reserved_data_blocks -= used;
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used + mdb_claim);
+	vfs_dq_claim_block(inode, used + mdb_claim);
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bba1282..d4c52db 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2750,12 +2750,6 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
 		/* release all the reserved blocks if non delalloc */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
-	else {
-		percpu_counter_sub(&sbi->s_dirtyblocks_counter,
-						ac->ac_b_ex.fe_len);
-		/* convert reserved quota blocks to real quota blocks */
-		vfs_dq_claim_block(ac->ac_inode, ac->ac_b_ex.fe_len);
-	}
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
-- 
1.6.0.4

