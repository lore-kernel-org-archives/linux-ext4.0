From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/11] jfs: Remove jfs_get_inode_flags()
Date: Wed, 12 Apr 2017 09:26:08 +0200
Message-ID: <20170412072611.29017-9-jack@suse.cz>
References: <20170412072611.29017-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <reiserfs-devel@vger.kernel.org>,
        jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <20170412072611.29017-1-jack@suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Now that all places setting inode->i_flags that should be reflected in
on-disk flags are gone, we can remove jfs_get_inode_flags() call.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jfs/ioctl.c     |  2 --
 fs/jfs/jfs_imap.c  |  1 -
 fs/jfs/jfs_inode.c | 18 ------------------
 fs/jfs/jfs_inode.h |  1 -
 4 files changed, 22 deletions(-)

diff --git a/fs/jfs/ioctl.c b/fs/jfs/ioctl.c
index fc89f9436784..5c5ac5b3aec3 100644
--- a/fs/jfs/ioctl.c
+++ b/fs/jfs/ioctl.c
@@ -64,7 +64,6 @@ long jfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 	case JFS_IOC_GETFLAGS:
-		jfs_get_inode_flags(jfs_inode);
 		flags = jfs_inode->mode2 & JFS_FL_USER_VISIBLE;
 		flags = jfs_map_ext2(flags, 0);
 		return put_user(flags, (int __user *) arg);
@@ -98,7 +97,6 @@ long jfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		/* Lock against other parallel changes of flags */
 		inode_lock(inode);
 
-		jfs_get_inode_flags(jfs_inode);
 		oldflags = jfs_inode->mode2;
 
 		/*
diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index 6aca224a5d68..f36ef68905a7 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -3148,7 +3148,6 @@ static void copy_to_dinode(struct dinode * dip, struct inode *ip)
 	else
 		dip->di_gid = cpu_to_le32(from_kgid(&init_user_ns,
 						    jfs_ip->saved_gid));
-	jfs_get_inode_flags(jfs_ip);
 	/*
 	 * mode2 is only needed for storing the higher order bits.
 	 * Trust i_mode for the lower order ones
diff --git a/fs/jfs/jfs_inode.c b/fs/jfs/jfs_inode.c
index 375dd257a34f..5e9b7bb3aabf 100644
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -45,24 +45,6 @@ void jfs_set_inode_flags(struct inode *inode)
 			S_DIRSYNC | S_SYNC);
 }
 
-void jfs_get_inode_flags(struct jfs_inode_info *jfs_ip)
-{
-	unsigned int flags = jfs_ip->vfs_inode.i_flags;
-
-	jfs_ip->mode2 &= ~(JFS_IMMUTABLE_FL | JFS_APPEND_FL | JFS_NOATIME_FL |
-			   JFS_DIRSYNC_FL | JFS_SYNC_FL);
-	if (flags & S_IMMUTABLE)
-		jfs_ip->mode2 |= JFS_IMMUTABLE_FL;
-	if (flags & S_APPEND)
-		jfs_ip->mode2 |= JFS_APPEND_FL;
-	if (flags & S_NOATIME)
-		jfs_ip->mode2 |= JFS_NOATIME_FL;
-	if (flags & S_DIRSYNC)
-		jfs_ip->mode2 |= JFS_DIRSYNC_FL;
-	if (flags & S_SYNC)
-		jfs_ip->mode2 |= JFS_SYNC_FL;
-}
-
 /*
  * NAME:	ialloc()
  *
diff --git a/fs/jfs/jfs_inode.h b/fs/jfs/jfs_inode.h
index 9271cfe4a149..7b0b3a40788f 100644
--- a/fs/jfs/jfs_inode.h
+++ b/fs/jfs/jfs_inode.h
@@ -33,7 +33,6 @@ extern void jfs_truncate(struct inode *);
 extern void jfs_truncate_nolock(struct inode *, loff_t);
 extern void jfs_free_zero_link(struct inode *);
 extern struct dentry *jfs_get_parent(struct dentry *dentry);
-extern void jfs_get_inode_flags(struct jfs_inode_info *);
 extern struct dentry *jfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	int fh_len, int fh_type);
 extern struct dentry *jfs_fh_to_parent(struct super_block *sb, struct fid *fid,
-- 
2.12.0

