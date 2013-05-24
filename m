From: ashishsangwan2@gmail.com
Subject: [PATCH] ext4: pass inode pointer instead of file poiner to punch hole
Date: Fri, 24 May 2013 20:06:55 +0530
Message-ID: <519f7b26.81b1440a.6cc8.ffffa881@mx.google.com>
Cc: linux-ext4@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: tytso@mit.edu, adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58100 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3EXOh1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 May 2013 10:37:27 -0400
Received: by mail-pa0-f44.google.com with SMTP id wp1so1770299pac.17
        for <linux-ext4@vger.kernel.org>; Fri, 24 May 2013 07:37:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Ashish Sangwan <a.sangwan@samsung.com>

No need to pass file pointer when we can directly pass inode pointer.

Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5aae3d1..04e4d1e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2088,7 +2088,7 @@ extern int ext4_change_inode_journal_flag(struct inode *, int);
 extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
 extern int ext4_can_truncate(struct inode *inode);
 extern void ext4_truncate(struct inode *);
-extern int ext4_punch_hole(struct file *file, loff_t offset, loff_t length);
+extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
 extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
 extern void ext4_set_inode_flags(struct inode *);
 extern void ext4_get_inode_flags(struct ext4_inode_info *);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bc0f191..3676dae 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4446,7 +4446,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EOPNOTSUPP;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
-		return ext4_punch_hole(file, offset, len);
+		return ext4_punch_hole(inode, offset, len);
 
 	ret = ext4_convert_inline_data(inode);
 	if (ret)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d6382b8..06e0fe2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3580,9 +3580,8 @@ int ext4_can_truncate(struct inode *inode)
  * Returns: 0 on success or negative on failure
  */
 
-int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
+int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 {
-	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
-- 
1.7.2.3

