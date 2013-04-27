From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH] ext4: remove unneeded call to ext4_es_remove_extent in punch hole
Date: Sat, 27 Apr 2013 10:00:53 +0530
Message-ID: <1367037053-1893-1-git-send-email-ashish.sangwan2@gmail.com>
Cc: linux-ext4@vger.kernel.org, wenqing.lz@taobao.com,
	Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:53883 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3D0Ebk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Apr 2013 00:31:40 -0400
Received: by mail-da0-f41.google.com with SMTP id p8so631395dan.0
        for <linux-ext4@vger.kernel.org>; Fri, 26 Apr 2013 21:31:39 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Ashish Sangwan <a.sangwan@samsung.com>

During punch hole, before removing extents we make sure that the blocks
are commited to disk by calling filemap_write_and_wait_range. So, the
extents cannot be present on extent status tree.

Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/ext4/inode.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 50cced9..944eb15 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3749,13 +3749,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_discard_preallocations(inode);
 
-	ret = ext4_es_remove_extent(inode, first_block,
-				    stop_block - first_block);
-	if (ret) {
-		up_write(&EXT4_I(inode)->i_data_sem);
-		goto out_stop;
-	}
