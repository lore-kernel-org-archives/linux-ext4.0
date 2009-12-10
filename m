From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix sleep inside spinlock issue aka #14739
Date: Thu, 10 Dec 2009 04:42:42 +0300
Message-ID: <1260409362-4349-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: cmm@us.ibm.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:43537 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759394AbZLJBma (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 20:42:30 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KUE00990YAW8370@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Thu, 10 Dec 2009 04:47:23 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

drop i_block_reservation_lock before vfs_dq_reserve_block().
this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=14739

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 942e183..f693768 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1852,19 +1852,8 @@ repeat:
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
-	/*
-	 * Make quota reservation here to prevent quota overflow
-	 * later. Real quota accounting is done at pages writeout
-	 * time.
-	 */
-	if (vfs_dq_reserve_block(inode, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-		return -EDQUOT;
-	}
-
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
@@ -1872,10 +1861,24 @@ repeat:
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
+	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	/*
+	 * Make quota reservation here to prevent quota overflow
+	 * later. Real quota accounting is done at pages writeout
+	 * time.
+	 */
+	if (!vfs_dq_reserve_block(inode, total))
+		return 0;       /* success */
 
+	/* Quota reservation has failed, revert inode's reservation */
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, total);
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+	EXT4_I(inode)->i_reserved_data_blocks -= nrblocks;
+	EXT4_I(inode)->i_reserved_meta_blocks -= md_needed;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-	return 0;       /* success */
+	return -EDQUOT;
 }
 
 static void ext4_da_release_space(struct inode *inode, int to_free)
-- 
1.6.0.4

