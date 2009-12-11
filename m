From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix sleep inside spinlock issue aka #14739 [V3]
Date: Fri, 11 Dec 2009 05:36:27 +0300
Message-ID: <1260498987-6131-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: jmaggard10@gmail.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:52619 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758085AbZLKCgM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2009 21:36:12 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KUG00AYPVGHNE30@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Fri, 11 Dec 2009 05:41:07 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

unlock i_block_reservation_lock before vfs_dq_reserve_block().
this patch fix http://bugzilla.kernel.org/show_bug.cgi?id=14739

changes from V2:
 - fix meta_blocks leak.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 942e183..6fb7c73 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1851,6 +1851,7 @@ repeat:
 
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
 	 * Make quota reservation here to prevent quota overflow
@@ -1858,12 +1859,10 @@ repeat:
 	 * time.
 	 */
 	if (vfs_dq_reserve_block(inode, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		return -EDQUOT;
 	}
 
 	if (ext4_claim_free_blocks(sbi, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
@@ -1871,10 +1870,11 @@ repeat:
 		}
 		return -ENOSPC;
 	}
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
