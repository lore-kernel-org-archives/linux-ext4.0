From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 18/30] ext4: snapshot control - fix new snapshot
Date: Mon,  9 May 2011 19:41:36 +0300
Message-ID: <1304959308-11122-19-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35313 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1EIQn7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:59 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5955868wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:59 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

On snapshot take, after copying the pre-allocated blocks, some are
fixed to make the snapshot image appear as a valid Ext4 file system.
The has_snapshot flags is cleared from the super block as well as
the last_snapshot field and all snapshot inodes are cleared
(to appear as empty inodes).

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h  |    2 ++
 fs/ext4/inode.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3cf6602..c04a031 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1850,6 +1850,8 @@ struct buffer_head *ext4_bread(handle_t *, struct inode *,
 int ext4_get_block(struct inode *inode, sector_t iblock,
 				struct buffer_head *bh_result, int create);
 
+extern blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
+		struct ext4_inode_info *ei);
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
 extern int  ext4_write_inode(struct inode *, struct writeback_control *);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c3d4e7a..4bc60f1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5203,8 +5203,8 @@ void ext4_get_inode_flags(struct ext4_inode_info *ei)
 	} while (cmpxchg(&ei->i_flags, old_fl, new_fl) != old_fl);
 }
 
-static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
-				  struct ext4_inode_info *ei)
+blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
+			  struct ext4_inode_info *ei)
 {
 	blkcnt_t i_blocks ;
 	struct inode *inode = &(ei->vfs_inode);
-- 
1.7.0.4

