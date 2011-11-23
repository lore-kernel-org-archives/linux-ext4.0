From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/2] ext4: let mpage_submit_io works well when blocksize < pagesize
Date: Wed, 23 Nov 2011 17:15:25 +0800
Message-ID: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, tytso@mit.edu,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54225 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1KWLsb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Nov 2011 06:48:31 -0500
Received: by iage36 with SMTP id e36so1471959iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Nov 2011 03:48:31 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If there is a unwritten but clean buffer in a page and there is a dirty buffer
after the buffer, then mpage_submit_io does not write the dirty buffer out.
As a result, da_writepages loops forever.

This patch fixes the problem by checking dirty flag.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 755f6c7..20a1d17 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1339,8 +1339,11 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 					clear_buffer_unwritten(bh);
 				}
 
-				/* skip page if block allocation undone */
-				if (buffer_delay(bh) || buffer_unwritten(bh))
+				/*
+				 * skip page if block allocation undone and
+				 * block is dirty
+				 */
+				if (ext4_bh_delay_or_unwritten(NULL, bh))
 					skip_page = 1;
 				bh = bh->b_this_page;
 				block_start += bh->b_size;
-- 
1.7.5.1

