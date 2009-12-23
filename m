From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/5] ext4: fix sleep inside spinlock issue with quota and dealloc (#14739)
Date: Wed, 23 Dec 2009 18:25:08 +0100
Message-ID: <1261589108-17588-6-git-send-email-jack@suse.cz>
References: <1261589108-17588-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:58436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419AbZLWRZb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 12:25:31 -0500
In-Reply-To: <1261589108-17588-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

Unlock i_block_reservation_lock before vfs_dq_reserve_block().
This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=14739

CC: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9202696..676d880 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1847,19 +1847,17 @@ repeat:
 
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 
 	/*
 	 * Make quota reservation here to prevent quota overflow
 	 * later. Real quota accounting is done at pages writeout
 	 * time.
 	 */
-	if (vfs_dq_reserve_block(inode, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+	if (vfs_dq_reserve_block(inode, total))
 		return -EDQUOT;
-	}
 
 	if (ext4_claim_free_blocks(sbi, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
@@ -1867,10 +1865,11 @@ repeat:
 		}
 		return -ENOSPC;
 	}
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
