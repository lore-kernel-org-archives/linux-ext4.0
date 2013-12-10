From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] ext4: Fix deadlock when writing in ENOSPC conditions
Date: Tue, 10 Dec 2013 11:14:00 +0100
Message-ID: <1386670440-3158-4-git-send-email-jack@suse.cz>
References: <1386670440-3158-1-git-send-email-jack@suse.cz>
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3LJKOG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 05:14:06 -0500
In-Reply-To: <1386670440-3158-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Akira-san has been reporting rare deadlocks of his machine when running
xfstests test 269 on ext4 filesystem. The problem turned out to be in
ext4_da_reserve_metadata() and ext4_da_reserve_space() which called
ext4_should_retry_alloc() while holding i_data_sem. Since
ext4_should_retry_alloc() can force a transaction commit, this is a
lock ordering violation and leads to deadlocks.

Fix the problem by just removing the retry loops. These functions should
just report ENOSPC to the caller (e.g. ext4_da_write_begin()) and that
function must take care of retrying after dropping all necessary locks.

Reported-and-tested-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 075763474118..61d49ff22c81 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1206,7 +1206,6 @@ static int ext4_journalled_write_end(struct file *file,
  */
 static int ext4_da_reserve_metadata(struct inode *inode, ext4_lblk_t lblock)
 {
-	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int md_needed;
@@ -1218,7 +1217,6 @@ static int ext4_da_reserve_metadata(struct inode *inode, ext4_lblk_t lblock)
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
-repeat:
 	spin_lock(&ei->i_block_reservation_lock);
 	/*
 	 * ext4_calc_metadata_amount() has side effects, which we have
@@ -1238,10 +1236,6 @@ repeat:
 		ei->i_da_metadata_calc_len = save_len;
 		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
 		spin_unlock(&ei->i_block_reservation_lock);
-		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-			cond_resched();
-			goto repeat;
-		}
 		return -ENOSPC;
 	}
 	ei->i_reserved_meta_blocks += md_needed;
@@ -1255,7 +1249,6 @@ repeat:
  */
 static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 {
-	int retries = 0;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int md_needed;
@@ -1277,7 +1270,6 @@ static int ext4_da_reserve_space(struct inode *inode, ext4_lblk_t lblock)
 	 * in order to allocate nrblocks
 	 * worse case is one extent per block
 	 */
-repeat:
 	spin_lock(&ei->i_block_reservation_lock);
 	/*
 	 * ext4_calc_metadata_amount() has side effects, which we have
@@ -1297,10 +1289,6 @@ repeat:
 		ei->i_da_metadata_calc_len = save_len;
 		ei->i_da_metadata_calc_last_lblock = save_last_lblock;
 		spin_unlock(&ei->i_block_reservation_lock);
-		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
-			cond_resched();
-			goto repeat;
-		}
 		dquot_release_reservation_block(inode, EXT4_C2B(sbi, 1));
 		return -ENOSPC;
 	}
-- 
1.8.1.4

