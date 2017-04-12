From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/11] ext4: Remove ext4_get_inode_flags()
Date: Wed, 12 Apr 2017 09:26:06 +0200
Message-ID: <20170412072611.29017-7-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Now that all places setting inode->i_flags that should be reflected in
on-disk flags are gone, we can remove ext4_get_inode_flags() call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |  1 -
 fs/ext4/inode.c | 26 --------------------------
 fs/ext4/ioctl.c |  2 --
 3 files changed, 29 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f493af666591..3e8a03b88b3a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2476,7 +2476,6 @@ extern int ext4_truncate(struct inode *);
 extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
 extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
 extern void ext4_set_inode_flags(struct inode *);
-extern void ext4_get_inode_flags(struct ext4_inode_info *);
 extern int ext4_alloc_da_blocks(struct inode *inode);
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4247d8d25687..cfd8b29bbf92 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4502,31 +4502,6 @@ void ext4_set_inode_flags(struct inode *inode)
 			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
 }
 
-/* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
-void ext4_get_inode_flags(struct ext4_inode_info *ei)
-{
-	unsigned int vfs_fl;
-	unsigned long old_fl, new_fl;
-
-	do {
-		vfs_fl = ei->vfs_inode.i_flags;
-		old_fl = ei->i_flags;
-		new_fl = old_fl & ~(EXT4_SYNC_FL|EXT4_APPEND_FL|
-				EXT4_IMMUTABLE_FL|EXT4_NOATIME_FL|
-				EXT4_DIRSYNC_FL);
-		if (vfs_fl & S_SYNC)
-			new_fl |= EXT4_SYNC_FL;
-		if (vfs_fl & S_APPEND)
-			new_fl |= EXT4_APPEND_FL;
-		if (vfs_fl & S_IMMUTABLE)
-			new_fl |= EXT4_IMMUTABLE_FL;
-		if (vfs_fl & S_NOATIME)
-			new_fl |= EXT4_NOATIME_FL;
-		if (vfs_fl & S_DIRSYNC)
-			new_fl |= EXT4_DIRSYNC_FL;
-	} while (cmpxchg(&ei->i_flags, old_fl, new_fl) != old_fl);
-}
-
 static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 				  struct ext4_inode_info *ei)
 {
@@ -4963,7 +4938,6 @@ static int ext4_do_update_inode(handle_t *handle,
 	if (ext4_test_inode_state(inode, EXT4_STATE_NEW))
 		memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
 
-	ext4_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	i_uid = i_uid_read(inode);
 	i_gid = i_gid_read(inode);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a4273ddb9922..184e74eb3004 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -500,7 +500,6 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case EXT4_IOC_GETFLAGS:
-		ext4_get_inode_flags(ei);
 		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT4_IOC_SETFLAGS: {
@@ -888,7 +887,6 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		struct fsxattr fa;
 
 		memset(&fa, 0, sizeof(struct fsxattr));
-		ext4_get_inode_flags(ei);
 		fa.fsx_xflags = ext4_iflags_to_xflags(ei->i_flags & EXT4_FL_USER_VISIBLE);
 
 		if (ext4_has_feature_project(inode->i_sb)) {
-- 
2.12.0
