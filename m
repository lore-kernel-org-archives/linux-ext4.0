From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/4] ext4: fix race chown vs truncate
Date: Tue, 24 Nov 2009 01:58:56 +0300
Message-ID: <1259017138-19165-2-git-send-email-dmonakhov@openvz.org>
References: <877hthytz0.fsf@openvz.org>
 <1259017138-19165-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:56131 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbZKWW6y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 17:58:54 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KTL00DOP41TE510@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Tue, 24 Nov 2009 02:03:32 +0300 (MSK)
In-reply-to: <1259017138-19165-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently all functions which call vfs_dq_release_reservation_block()
call it without i_block_reservation_lock. This result in
ext4_reservation vs quota_reservation inconsistency which provoke
incorrect reservation transfer and incorrect quota.
Task 1 (chown)                   Task 2 (truncate)
dquot_transfer
 ->down_write(dqptr_sem)	 ext4_da_release_spac
 ->dquot_get_reserved_space	  ->lock(i_block_reservation_lock)
    ->get_reserved_space	    /* decrement reservation */
      ->ext4_get_reserved_spac	  ->unlock(i_block_reservation_lock)
        lock(i_block_rsv_lock) ---- /* During this time window
	Read incorrect value	     * fs's reservation not equals
				     * to quota's */
				    ->vfs_dq_release_reservation_block()
In fact i_block_reservation_lock is held by ext4_da_reserve_space()
while calling vfs_dq_reserve_block(). This may result in deadlock:
because of different lock ordering:
ext4_da_reserve_space()             dquot_transfer()
lock(i_block_reservation_lock)	     down_write(dqptr_sem)
  down_write(dqptr_sem)		     lock(i_block_reservation_lock)

But this not happens only because both callers must have i_mutex so
serialization happens on i_mutex.

To prevent ext4_reservation vs dquot_reservation inconsistency, we have
to reorganize locking ordering like follows:
i_block_reservation_lock > dqptr_sem
This means what all functions which changes ext4 or quota reservation have
to hold i_block_reservation_lock.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e642cdb..979362d 100644
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
@@ -1124,13 +1131,13 @@ static void ext4_da_update_reserve_space(struct inode *inode, int used)
  	EXT4_I(inode)->i_reserved_data_blocks -= used;
 	percpu_counter_sub(&sbi->s_dirtyblocks_counter, used + mdb_claim);
 	vfs_dq_claim_block(inode, used + mdb_claim);
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
 	 * free those over-booking quota for metadata blocks
 	 */
 	if (mdb_free)
 		vfs_dq_release_reservation_block(inode, mdb_free);
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
 	 * If we have done all the pending block allocations and if
@@ -1867,8 +1874,8 @@ repeat:
 	}
 
 	if (ext4_claim_free_blocks(sbi, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		vfs_dq_release_reservation_block(inode, total);
+		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
@@ -1925,9 +1932,9 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 
 	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
 	EXT4_I(inode)->i_reserved_meta_blocks = mdb;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	vfs_dq_release_reservation_block(inode, release);
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 }
 
 static void ext4_da_page_release_reservation(struct page *page,
@@ -5437,7 +5444,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
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
-- 
1.6.0.4

