From: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] fs:ext3: remove lock_buffer in bclean() and setup_new_group_blocks
Date: Sun,  2 Dec 2012 01:40:28 +0000
Message-ID: <1354412428-8938-1-git-send-email-dinggnu@gmail.com>
Cc: Cong Ding <dinggnu@gmail.com>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62109 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab2LBBko (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2012 20:40:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

it's not necessary to lock the buffers because no one touches them
beyond the file system.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 fs/ext3/resize.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 0f814f3..f76fcd6 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -122,10 +122,8 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
 		brelse(bh);
 		bh = ERR_PTR(err);
 	} else {
-		lock_buffer(bh);
 		memset(bh->b_data, 0, sb->s_blocksize);
 		set_buffer_uptodate(bh);
-		unlock_buffer(bh);
 	}
 
 	return bh;
@@ -242,10 +240,8 @@ static int setup_new_group_blocks(struct super_block *sb,
 			brelse(gdb);
 			goto exit_bh;
 		}
-		lock_buffer(gdb);
 		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
 		set_buffer_uptodate(gdb);
-		unlock_buffer(gdb);
 		err = ext3_journal_dirty_metadata(handle, gdb);
 		if (err) {
 			brelse(gdb);
-- 
1.7.4.5

