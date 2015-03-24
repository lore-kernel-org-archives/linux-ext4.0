From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] ext4: remove unnecessary lock/unlock of i_block_reservation_lock
Date: Tue, 24 Mar 2015 14:11:44 +0100
Message-ID: <1427202704-6264-1-git-send-email-mlombard@redhat.com>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbbCXNLs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Mar 2015 09:11:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a leftover of commit 71d4f7d032149b935a26eb3ff85c6c837f3714e1

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 fs/ext4/balloc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 83a6f49..2072c70 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -641,8 +641,6 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 	 * fail EDQUOT for metdata, but we do account for it.
 	 */
 	if (!(*errp) && (flags & EXT4_MB_DELALLOC_RESERVED)) {
-		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		dquot_alloc_block_nofail(inode,
 				EXT4_C2B(EXT4_SB(inode->i_sb), ar.len));
 	}
-- 
Maurizio Lombardi

