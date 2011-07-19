From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2 09/11] ext4: remove lock_buffer in bclean() and setup_new_group_blocks()
Date: Tue, 19 Jul 2011 12:02:15 +0800
Message-ID: <1311048137-16400-10-git-send-email-xiaoqiangnk@gmail.com>
References: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, amir73il@gmail.com, tm@tao.ma,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48758 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab1GSEGq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jul 2011 00:06:46 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so3708338iyb.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Jul 2011 21:06:46 -0700 (PDT)
In-Reply-To: <1311048137-16400-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Nobody touchs blocks beyond the filesystem, there is no need to lock
the buffers.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

 v1->v2:
   nothing changed.

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 5b423f8..65e5cb6 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -147,10 +147,8 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
 		brelse(bh);
 		bh = ERR_PTR(err);
 	} else {
-		lock_buffer(bh);
 		memset(bh->b_data, 0, sb->s_blocksize);
 		set_buffer_uptodate(bh);
-		unlock_buffer(bh);
 	}
 
 	return bh;
@@ -229,10 +227,8 @@ static int setup_new_group_blocks(struct super_block *sb,
 			brelse(gdb);
 			goto exit_journal;
 		}
-		lock_buffer(gdb);
 		memcpy(gdb->b_data, sbi->s_group_desc[i]->b_data, gdb->b_size);
 		set_buffer_uptodate(gdb);
-		unlock_buffer(gdb);
 		err = ext4_handle_dirty_metadata(handle, NULL, gdb);
 		if (unlikely(err)) {
 			brelse(gdb);
-- 
1.7.5.1

