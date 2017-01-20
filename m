From: Geliang Tang <geliangtang@gmail.com>
Subject: [PATCH] ext4: use i_blocksize()
Date: Fri, 20 Jan 2017 22:29:49 +0800
Message-ID: <0a58b38c7ddfbbc8f56cb8d815114bd4357a6016.1484895399.git.geliangtang@gmail.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35336 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752674AbdATOaH (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jan 2017 09:30:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since i_blocksize() helper has been defined in fs.h, use it instead
of open-coding.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 fs/ext4/move_extent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 578f8c3..60222ed 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -382,7 +382,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	/* Perform all necessary steps similar write_begin()/write_end()
 	 * but keeping in mind that i_size will not change */
 	if (!page_has_buffers(pagep[0]))
-		create_empty_buffers(pagep[0], 1 << orig_inode->i_blkbits, 0);
+		create_empty_buffers(pagep[0], i_blocksize(orig_inode), 0);
 	bh = page_buffers(pagep[0]);
 	for (i = 0; i < data_offset_in_page; i++)
 		bh = bh->b_this_page;
-- 
2.9.3

