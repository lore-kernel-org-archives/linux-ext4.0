From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] cgroup, writeback: replace SB_I_CGROUPWB with per-inode S_CGROUPWB
Date: Mon,  9 Oct 2017 14:29:09 -0700
Message-ID: <20171009212911.473208-2-tj@kernel.org>
References: <20171009212911.473208-1-tj@kernel.org>
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
To: jack@suse.cz, axboe@kernel.dk, clm@fb.com, jbacik@fb.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171009212911.473208-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently, filesystem can indiate cgroup writeback support per
superblock; however, depending on the filesystem, especially if inodes
are used to carry metadata, it can be useful to indicate cgroup
writeback support per inode.

This patch replaces the superblock flag SB_I_CGROUPWB with per-inode
S_CGROUPWB, so that cgroup writeback can be enabled selectively.

* block_dev sets the new flag in bdget() when initializing new inode.

* ext2/4 set the new flag in ext?_set_inode_flags() function.

* btrfs sets the new flag in btrfs_update_iflags() function.  Note
  that this automatically excludes btree_inode which doesn't use
  btrfs_update_iflags() during initialization.  This is an intended
  behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/block_dev.c              | 3 +--
 fs/btrfs/ioctl.c            | 4 +++-
 fs/btrfs/super.c            | 1 -
 fs/ext2/inode.c             | 3 ++-
 fs/ext2/super.c             | 1 -
 fs/ext4/inode.c             | 5 ++++-
 fs/ext4/super.c             | 2 --
 include/linux/backing-dev.h | 2 +-
 include/linux/fs.h          | 3 ++-
 9 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 93d088f..ff9c282 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -800,8 +800,6 @@ static struct dentry *bd_mount(struct file_system_type *fs_type,
 {
 	struct dentry *dent;
 	dent = mount_pseudo(fs_type, "bdev:", &bdev_sops, NULL, BDEVFS_MAGIC);
-	if (!IS_ERR(dent))
-		dent->d_sb->s_iflags |= SB_I_CGROUPWB;
 	return dent;
 }
 
@@ -893,6 +891,7 @@ struct block_device *bdget(dev_t dev)
 		inode->i_mode = S_IFBLK;
 		inode->i_rdev = dev;
 		inode->i_bdev = bdev;
+		inode->i_flags |= S_CGROUPWB;
 		inode->i_data.a_ops = &def_blk_aops;
 		mapping_set_gfp_mask(&inode->i_data, GFP_USER);
 		spin_lock(&bdev_lock);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6c7a49f..117cc63 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -150,9 +150,11 @@ void btrfs_update_iflags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (ip->flags & BTRFS_INODE_DIRSYNC)
 		new_fl |= S_DIRSYNC;
+	new_fl |= S_CGROUPWB;
 
 	set_mask_bits(&inode->i_flags,
-		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC,
+		      S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME | S_DIRSYNC |
+		      S_CGROUPWB,
 		      new_fl);
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 35a128a..46a1488 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1136,7 +1136,6 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_flags |= MS_POSIXACL;
 #endif
 	sb->s_flags |= MS_I_VERSION;
-	sb->s_iflags |= SB_I_CGROUPWB;
 
 	err = super_setup_bdi(sb);
 	if (err) {
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 4dca6f3..3c5d822 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1372,7 +1372,7 @@ void ext2_set_inode_flags(struct inode *inode)
 	unsigned int flags = EXT2_I(inode)->i_flags;
 
 	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
-				S_DIRSYNC | S_DAX);
+				S_DIRSYNC | S_DAX | S_CGROUPWB);
 	if (flags & EXT2_SYNC_FL)
 		inode->i_flags |= S_SYNC;
 	if (flags & EXT2_APPEND_FL)
@@ -1385,6 +1385,7 @@ void ext2_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_DIRSYNC;
 	if (test_opt(inode->i_sb, DAX) && S_ISREG(inode->i_mode))
 		inode->i_flags |= S_DAX;
+	inode->i_flags |= S_CGROUPWB;
 }
 
 struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 1458706..e6ba669e 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -922,7 +922,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((EXT2_SB(sb)->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ?
 		 MS_POSIXACL : 0);
-	sb->s_iflags |= SB_I_CGROUPWB;
 
 	if (le32_to_cpu(es->s_rev_level) == EXT2_GOOD_OLD_REV &&
 	    (EXT2_HAS_COMPAT_FEATURE(sb, ~0U) ||
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 31db875..344f12b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4591,8 +4591,11 @@ void ext4_set_inode_flags(struct inode *inode)
 	    !ext4_should_journal_data(inode) && !ext4_has_inline_data(inode) &&
 	    !ext4_encrypted_inode(inode))
 		new_fl |= S_DAX;
+	if (test_opt(inode->i_sb, DATA_FLAGS) != EXT4_MOUNT_JOURNAL_DATA)
+		new_fl |= S_CGROUPWB;
 	inode_set_flags(inode, new_fl,
-			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX);
+			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC|S_DAX|
+			S_CGROUPWB);
 }
 
 static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b104096..44ddf1d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3620,8 +3620,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 		if (test_opt(sb, DELALLOC))
 			clear_opt(sb, DELALLOC);
-	} else {
-		sb->s_iflags |= SB_I_CGROUPWB;
 	}
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 854e1bd..7274de0 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -246,7 +246,7 @@ static inline bool inode_cgwb_enabled(struct inode *inode)
 		cgroup_subsys_on_dfl(io_cgrp_subsys) &&
 		bdi_cap_account_dirty(bdi) &&
 		(bdi->capabilities & BDI_CAP_CGROUP_WRITEBACK) &&
-		(inode->i_sb->s_iflags & SB_I_CGROUPWB);
+		IS_CGROUPWB(inode);
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 13dab19..be2d8a6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1308,7 +1308,6 @@ extern int send_sigurg(struct fown_struct *fown);
 #define UMOUNT_UNUSED	0x80000000	/* Flag guaranteed to be unused */
 
 /* sb->s_iflags */
-#define SB_I_CGROUPWB	0x00000001	/* cgroup-aware writeback enabled */
 #define SB_I_NOEXEC	0x00000002	/* Ignore executables on this fs */
 #define SB_I_NODEV	0x00000004	/* Ignore devices on this fs */
 
@@ -1853,6 +1852,7 @@ struct super_operations {
 #else
 #define S_DAX		0	/* Make all the DAX code disappear */
 #endif
+#define S_CGROUPWB	16384	/* Enable cgroup writeback for this inode */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -1892,6 +1892,7 @@ static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags
 #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
 #define IS_DAX(inode)		((inode)->i_flags & S_DAX)
+#define IS_CGROUPWB(inode)	((inode)->i_flags & S_CGROUPWB)
 
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev == WHITEOUT_DEV)
-- 
2.9.5
