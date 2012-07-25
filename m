From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH] Ext4: No need to add inode to orphan list during hole punch
Date: Wed, 25 Jul 2012 19:48:28 +0530
Message-ID: <1343225908-1997-1-git-send-email-ashish.sangwan2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	lczerner@redhat.com, a.sangwan@samsung.com,
	namjae.jeon@samsung.com,
	Ashish Sangwan <ashish.sangwan2@gmail.com>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56171 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933117Ab2GYOTR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Jul 2012 10:19:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Ashish Sangwan <ashish.sangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/ext4/extents.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91341ec..3e902f9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4801,9 +4801,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	err = ext4_orphan_add(handle, inode);
-	if (err)
-		goto out;
 
 	/*
 	 * Now we need to zero out the non-page-aligned data in the
@@ -4889,7 +4886,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	up_write(&EXT4_I(inode)->i_data_sem);
 
 out:
-	ext4_orphan_del(handle, inode);
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
-- 
1.7.10.4

