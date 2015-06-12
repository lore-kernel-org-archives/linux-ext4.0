From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] vfs, writeback: replace FS_CGROUP_WRITEBACK with MS_CGROUPWB
Date: Fri, 12 Jun 2015 16:57:33 -0500
Message-ID: <1434146254-26220-3-git-send-email-tj@kernel.org>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434146254-26220-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

FS_CGROUP_WRITEBACK indicates whether a file_system_type supports
cgroup writeback; however, different super_blocks of the same
file_system_type may or may not support cgroup writeback depending on
filesystem options.  This patch replaces FS_CGROUP_WRITEBACK with a
kernel-internal super_block->s_flags MS_CGROUPWB.  The concatenated
and abbreviated name is for consistency with other MS_* flags.

ext2_fill_super() is updated to assert MS_CGROUPWB.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 fs/ext2/super.c             | 4 ++--
 fs/namespace.c              | 2 +-
 include/linux/backing-dev.h | 2 +-
 include/linux/fs.h          | 1 -
 include/uapi/linux/fs.h     | 1 +
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 549219d..472ed34 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -879,7 +879,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	if (!parse_options((char *) data, sb))
 		goto failed_mount;
 
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) | MS_CGROUPWB |
 		((EXT2_SB(sb)->s_mount_opt & EXT2_MOUNT_POSIX_ACL) ?
 		 MS_POSIXACL : 0);
 
@@ -1543,7 +1543,7 @@ static struct file_system_type ext2_fs_type = {
 	.name		= "ext2",
 	.mount		= ext2_mount,
 	.kill_sb	= kill_block_super,
-	.fs_flags	= FS_REQUIRES_DEV | FS_CGROUP_WRITEBACK,
+	.fs_flags	= FS_REQUIRES_DEV,
 };
 MODULE_ALIAS_FS("ext2");
 
diff --git a/fs/namespace.c b/fs/namespace.c
index 1f4f9da..507b90b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2669,7 +2669,7 @@ long do_mount(const char *dev_name, const char __user *dir_name,
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
-		   MS_STRICTATIME);
+		   MS_STRICTATIME | MS_CGROUPWB);
 
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index dfce808..1489131 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -260,7 +260,7 @@ static inline bool inode_cgwb_enabled(struct inode *inode)
 
 	return bdi_cap_account_dirty(bdi) &&
 		(bdi->capabilities & BDI_CAP_CGROUP_WRITEBACK) &&
-		(inode->i_sb->s_type->fs_flags & FS_CGROUP_WRITEBACK);
+		(inode->i_sb->s_flags & MS_CGROUPWB);
 }
 
 /**
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5e1dcf..66e35dc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1912,7 +1912,6 @@ struct file_system_type {
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_USERNS_DEV_MOUNT	16 /* A userns mount does not imply MNT_NODEV */
-#define FS_CGROUP_WRITEBACK	32	/* Supports cgroup-aware writeback */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	struct dentry *(*mount) (struct file_system_type *, int,
 		       const char *, void *);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 9b964a5..60316e7 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -93,6 +93,7 @@ struct inodes_stat_t {
 #define MS_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily */
 
 /* These sb flags are internal to the kernel */
+#define MS_CGROUPWB	(1<<27)	/* cgroup-aware writeback enabled */
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
-- 
2.4.2
