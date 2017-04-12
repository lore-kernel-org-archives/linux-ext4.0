From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/11] ext2: Remove ext2_get_inode_flags()
Date: Wed, 12 Apr 2017 09:26:07 +0200
Message-ID: <20170412072611.29017-8-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Now that all places setting inode->i_flags that should be reflected in
on-disk flags are gone, we can remove ext2_get_inode_flags() call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ext2.h  |  1 -
 fs/ext2/inode.c | 20 --------------------
 fs/ext2/ioctl.c |  1 -
 3 files changed, 22 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 5e64de9c5093..c7cfe9afa375 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -779,7 +779,6 @@ extern void ext2_evict_inode(struct inode *);
 extern int ext2_get_block(struct inode *, sector_t, struct buffer_head *, int);
 extern int ext2_setattr (struct dentry *, struct iattr *);
 extern void ext2_set_inode_flags(struct inode *inode);
-extern void ext2_get_inode_flags(struct ext2_inode_info *);
 extern int ext2_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
 
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 128cce540645..1e2663fbbc54 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1384,25 +1384,6 @@ void ext2_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_DAX;
 }
 
-/* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
-void ext2_get_inode_flags(struct ext2_inode_info *ei)
-{
-	unsigned int flags = ei->vfs_inode.i_flags;
-
-	ei->i_flags &= ~(EXT2_SYNC_FL|EXT2_APPEND_FL|
-			EXT2_IMMUTABLE_FL|EXT2_NOATIME_FL|EXT2_DIRSYNC_FL);
-	if (flags & S_SYNC)
-		ei->i_flags |= EXT2_SYNC_FL;
-	if (flags & S_APPEND)
-		ei->i_flags |= EXT2_APPEND_FL;
-	if (flags & S_IMMUTABLE)
-		ei->i_flags |= EXT2_IMMUTABLE_FL;
-	if (flags & S_NOATIME)
-		ei->i_flags |= EXT2_NOATIME_FL;
-	if (flags & S_DIRSYNC)
-		ei->i_flags |= EXT2_DIRSYNC_FL;
-}
-
 struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 {
 	struct ext2_inode_info *ei;
@@ -1563,7 +1544,6 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 	if (ei->i_state & EXT2_STATE_NEW)
 		memset(raw_inode, 0, EXT2_SB(sb)->s_inode_size);
 
-	ext2_get_inode_flags(ei);
 	raw_inode->i_mode = cpu_to_le16(inode->i_mode);
 	if (!(test_opt(sb, NO_UID32))) {
 		raw_inode->i_uid_low = cpu_to_le16(low_16_bits(uid));
diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
index 191e02b28ce8..087f122cca42 100644
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@ -29,7 +29,6 @@ long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case EXT2_IOC_GETFLAGS:
-		ext2_get_inode_flags(ei);
 		flags = ei->i_flags & EXT2_FL_USER_VISIBLE;
 		return put_user(flags, (int __user *) arg);
 	case EXT2_IOC_SETFLAGS: {
-- 
2.12.0

