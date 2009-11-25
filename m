From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] ext4: fix reserved space transferring on chown() [V2]
Date: Wed, 25 Nov 2009 09:57:39 +0300
Message-ID: <1259132261-16785-2-git-send-email-dmonakhov@openvz.org>
References: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:43482 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZKYG5h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Nov 2009 01:57:37 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KTN00EZYKVQR060@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Wed, 25 Nov 2009 10:02:16 +0300 (MSK)
In-reply-to: <1259132261-16785-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently all quota's functions except vfs_dq_reserve_block()
called without i_block_reservation_lock. This result in
ext4_reservation vs quota_reservation inconsistency which provoke
incorrect reservation transfer ==> incorrect quota after transfer.

Race (1)
| Task 1 (chown)                 | Task 2 (truncate)                    |
| dquot_transfer                 |                                      |
| ->down_write(dqptr_sem)        | ext4_da_release_spac                 |
| -->dquot_get_reserved_space    | ->lock(i_block_reservation_lock)     |
| --->get_reserved_space         | /* decrement reservation */          |
| ---->ext4_get_reserved_space   | ->unlock(i_block_reservation_lock)   |
| ----->lock(i_block_rsv_lock)   | /* During this time window           |
| /* Read ext4_rsv from inode */ | * fs's reservation not equals        |
| /* transfer it to new quota */ | * to quota's */                      |
| ->up_write(dqptr_sem)          | ->vfs_dq_release_reservation_block() |
|                                | /* quota_rsv goes negative here */   |
|                                |                                      |

Race (2)
| Task 1 (chown)                | Task 2 (flush-8:16)             |
| dquot_transfer()              | ext4_mb_mark_diskspace_used()   |
| ->down_write(dqptr_sem)       | ->vfs_dq_claim_block()          |
| --->get_reserved_space()      | /* After this moment         */ |
| --->ext4_get_reserved_space() | /* ext4_rsv != quota_ino_rsv */ |
| /* Read rsv from inode which  |                                 |
| ->dquot_free_reserved_space() |                                 |
| /* quota_rsv goes negative */ |                                 |
|                               |                                 |
|                               | dquot_free_reserved_space()     |
|                               | /* finally dec ext4_ino_rsv */  |

So, in order to protect us from this type of races we always have to
provides ext4_ino_rsv == quot_ino_rsv guarantee. And this is only
possible then i_block_reservation_lock is taken before entering any
quota operations.

In fact i_block_reservation_lock is held by ext4_da_reserve_space()
while calling vfs_dq_reserve_block(). Lock are held in following order
i_block_reservation_lock > dqptr_sem

This may result in deadlock because of different lock ordering:
ext4_da_reserve_space()             dquot_transfer()
lock(i_block_reservation_lock)	     down_write(dqptr_sem)
  down_write(dqptr_sem)		     lock(i_block_reservation_lock)

But this not happen only because both callers must have i_mutex so
serialization happens on i_mutex.

To prevent ext4_reservation vs dquot_reservation inconsistency we
have to make following changes
- Reorganize locking ordering like follows:
  i_block_reservation_lock > dqptr_sem
  This means what all functions which call vfs_dq_XXX must acquire
  i_block_reservation_lock before.

- Move space claiming to ext4_da_update_reserve_space()
  Only here we do know what we are dealing with data or metadata

- Delay dquot_claim for metadata before it until proper moment(
  until we are allowed to decrement inodes->i_reserved_meta_blocks)

The most useful test case for delalloc+quota is concurrent tasks
with write+truncate vs chown for the same file.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c   |   33 ++++++++++++++++++++++++---------
 fs/ext4/mballoc.c |    6 ------
 2 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cc4737e..979362d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1047,16 +1047,23 @@ cleanup:
 out:
 	return err;
 }
+/*
+ * Quota_transfer callback.
+ * During quota transfer we have to transfer rsv-blocks from one dquot to
+ * another. inode must be protected from concurrent reservation/reclamation.
+ * Locking ordering for all space reservation code:
+ *  i_block_reservation_lock > dqptr_sem
+ * This is differ from i_block,i_lock locking ordering, but this is the
+ * only possible way.
+ * NOTE: Caller must hold i_block_reservation_lock.
+ */
 
 qsize_t ext4_get_reserved_space(struct inode *inode)
 {
 	unsigned long long total;
 
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	total = EXT4_I(inode)->i_reserved_data_blocks +
 		EXT4_I(inode)->i_reserved_meta_blocks;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-
 	return (total << inode->i_blkbits);
 }
 /*
@@ -1096,7 +1103,7 @@ static int ext4_calc_metadata_amount(struct inode *inode, int blocks)
 static void ext4_da_update_reserve_space(struct inode *inode, int used)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	int total, mdb, mdb_free;
+	int total, mdb, mdb_free, mdb_claim = 0;
 
 	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	/* recalculate the number of metablocks still need to be reserved */
@@ -1109,7 +1116,9 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 
 	if (mdb_free) {
 		/* Account for allocated meta_blocks */
-		mdb_free -= EXT4_I(inode)->i_allocated_meta_blocks;
+		mdb_claim = EXT4_I(inode)->i_allocated_meta_blocks;
+		BUG_ON(mdb_free < mdb_claim);
+		mdb_free -= mdb_claim;
 
 		/* update fs dirty blocks counter */
 		percpu_counter_sub(&sbi->s_dirtyblocks_counter, mdb_free);
@@ -1119,14 +1128,16 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
 
 	/* update per-inode reservations */
 	BUG_ON(used  > EXT4_I(inode)->i_reserved_data_blocks);
-	EXT4_I(inode)->i_reserved_data_blocks -= used;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+ 	EXT4_I(inode)->i_reserved_data_blocks -= used;
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used + mdb_claim);
+	vfs_dq_claim_block(inode, used + mdb_claim);
 
 	/*
 	 * free those over-booking quota for metadata blocks
 	 */
 	if (mdb_free)
 		vfs_dq_release_reservation_block(inode, mdb_free);
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
 	 * If we have done all the pending block allocations and if
@@ -1863,8 +1874,8 @@ repeat:
 	}
 
 	if (ext4_claim_free_blocks(sbi, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		vfs_dq_release_reservation_block(inode, total);
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
@@ -1921,9 +1932,9 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	vfs_dq_release_reservation_block(inode, release);
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
 static void ext4_da_page_release_reservation(struct page *page,
@@ -5433,7 +5444,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			error = PTR_ERR(handle);
 			goto err_out;
 		}
+		/* i_block_reservation must being held in order to avoid races
+		 * with concurent block reservation. */
+		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 		error = vfs_dq_transfer(inode, attr) ? -EDQUOT : 0;
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		if (error) {
 			ext4_journal_stop(handle);
 			return error;
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

