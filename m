From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/7] ext4: endless truncate due to nonlocked dio readers V2
Date: Sun,  9 Sep 2012 21:27:13 +0400
Message-ID: <1347211634-11509-7-git-send-email-dmonakhov@openvz.org>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37543 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754043Ab2IIR13 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Sep 2012 13:27:29 -0400
Received: by mail-lpp01m010-f46.google.com with SMTP id y9so659795lag.19
        for <linux-ext4@vger.kernel.org>; Sun, 09 Sep 2012 10:27:28 -0700 (PDT)
In-Reply-To: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have enough aggressive DIO readers, truncate and other dio
waiters will wait forever inside inode_dio_wait(). It is reasonable
to disable nonlock DIO read optimization during truncate.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |    2 +-
 fs/ext4/fsync.c   |    2 +-
 fs/ext4/inode.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8252651..b5b801f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4853,7 +4853,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	}
 
 	/* finish any pending end_io work */
-	inode_dio_wait(inode);
+	ext4_inode_dio_wait(inode, 1);
 	ext4_flush_completed_IO(inode);
 
 	credits = ext4_writepage_trans_blocks(inode);
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 290c5cf..bdf6bfd 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -204,7 +204,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		goto out;
 
-	inode_dio_wait(inode);
+	ext4_inode_dio_wait(inode, 1);
 	ret = ext4_flush_completed_IO(inode);
 	if (ret < 0)
 		goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 93e6b09..a850026 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4335,7 +4335,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			truncate_setsize(inode, attr->ia_size);
 			/* Inode size will be reduced, wait for dio in flight */
 			if (orphan)
-				inode_dio_wait(inode);
+				ext4_inode_dio_wait(inode, 1);
 		}
 		ext4_truncate(inode);
 	}
-- 
1.7.7.6

