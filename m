From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: avoid kmemcheck complaint from reading uninitialized memory
Date: Sun,  5 Aug 2012 23:29:08 -0400
Message-ID: <1344223748-13589-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43178 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab2HFD3K (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Aug 2012 23:29:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 03179fe923 introduced a kmemcheck complaint in
ext4_da_get_block_prep() because we save and restore
ei->i_da_metadata_calc_last_lblock even though it is left
uninitialized in the case where i_da_metadata_calc_len is zero.

This doesn't hurt anything, but silencing the kmemcheck complaint
makes it easier for people to find real bugs.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=45631
(which is marked as a regression).

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ Cc: stable@vger.kernel.org ]
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ccc4bca..56bcaec 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -959,6 +959,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_da_metadata_calc_len = 0;
+	ei->i_da_metadata_calc_last_lblock = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
-- 
1.7.12.rc0.22.gcdd159b

