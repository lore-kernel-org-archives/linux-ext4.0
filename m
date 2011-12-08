From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix error handling on inode bitmap corruption
Date: Thu,  8 Dec 2011 21:28:34 +0100
Message-ID: <1323376115-23881-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab1LHU2q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Dec 2011 15:28:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When insert_inode_locked() fails in ext4_new_inode() it most likely means inode
bitmap got corrupted and we allocated again inode which is already in use. Also
doing unlock_new_inode() during error recovery is wrong since the inode does
not have I_NEW set. Fix the problem by jumping to fail: (instead of fail_drop:)
which declares filesystem error and does not call unlock_new_inode().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ialloc.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 00beb4f..8fb6844 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -885,8 +885,12 @@ got:
 	if (IS_DIRSYNC(inode))
 		ext4_handle_sync(handle);
 	if (insert_inode_locked(inode) < 0) {
-		err = -EINVAL;
-		goto fail_drop;
+		/*
+		 * Likely a bitmap corruption causing inode to be allocated
+		 * twice.
+		 */
+		err = -EIO;
+		goto fail;
 	}
 	spin_lock(&sbi->s_next_gen_lock);
 	inode->i_generation = sbi->s_next_generation++;
-- 
1.7.1

