From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] vfs, writeback: replace FS_CGROUP_WRITEBACK with SB_I_CGROUPWB
Date: Tue, 16 Jun 2015 18:48:31 -0400
Message-ID: <1434494912-31043-3-git-send-email-tj@kernel.org>
References: <1434494912-31043-1-git-send-email-tj@kernel.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org,
	kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434494912-31043-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

FS_CGROUP_WRITEBACK indicates whether a file_system_type supports
cgroup writeback; however, different super_blocks of the same
file_system_type may or may not support cgroup writeback depending on
filesystem options.  This patch replaces FS_CGROUP_WRITEBACK with a
per-super_block flag.

super_block->s_flags carries some internal flags in the high bits but
it's exposd to userland through uapi header and running out of space
anyway.  This patch adds a new field super_block->s_iflags to carry
kernel-internal flags.  It is currently only used by the new
SB_I_CGROUPWB flag whose concatenated and abbreviated name is for
consistency with other super_block flags.

ext2_fill_super() is updated to set SB_I_CGROUPWB.

v2: Added super_block->s_iflags instead of stealing another high bit
    from sb->s_flags as suggested by Christoph and Jan.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/ext2/super.c             | 3 ++-
 include/linux/backing-dev.h | 2 +-
 include/linux/fs.h          | 4 +++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 549219d..900e19c 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -882,6 +882,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		((EXT2_SB(sb)->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ?
 		 MS_POSIXACL : 0);
+	sb->s_iflags |= SB_I_CGROUPWB;
 
 	if (le32_to_cpu(es->s_rev_level) == EXT2_GOOD_OLD_REV &&
 	    (EXT2_HAS_COMPAT_FEATURE(sb, ~0U) ||
@@ -1543,7 +1544,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext2_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV | FS_CGROUP_WRITEBACK,
+	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("ext2");
 
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index dfce808..a13181a 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -260,7 +260,7 @@ static inline bool inode_cgwb_enabled(struct inode *inode)
 
 	return bdi_cap_account_dirty(bdi) &&
 		(bdi->capabilities & BDI_CAP_CGROUP_WRITEBACK) &&
-		(inode->i_sb->s_type->fs_flags & FS_CGROUP_WRITEBACK);
+		(inode->i_sb->s_iflags & SB_I_CGROUPWB);
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5e1dcf..2c5e33a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1241,6 +1241,8 @@ struct mm_struct;
 #define UMOUNT_NOFOLLOW	0x00000008	/* Don't follow symlink on umount */
 #define UMOUNT_UNUSED	0x80000000	/* Flag guaranteed to be unused */
 
+/* sb->s_iflags */
+#define SB_I_CGROUPWB	0x00000001	/* cgroup-aware writeback enabled */
 
 /* Possible states of 'frozen' field */
 enum {
@@ -1279,6 +1281,7 @@ struct super_block {
 	const struct quotactl_ops	*s_qcop;
 	const struct export_operations *s_export_op;
 	unsigned long		s_flags;
+	unsigned long		s_iflags;	/* internal SB_I_* flags */
 	unsigned long		s_magic;
 	struct dentry		*s_root;
 	struct rw_semaphore	s_umount;
@@ -1912,7 +1915,6 @@ struct file_system_type {
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
-#define FS_CGROUP_WRITEBACK	32	/* Supports cgroup-aware writeback */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
-- 
2.4.3
