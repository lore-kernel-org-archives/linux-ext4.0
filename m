From: akpm@linux-foundation.org
Subject: [patch 40/41] exportfs: make struct export_operations const
Date: Sun, 21 Oct 2007 16:42:17 -0700
Message-ID: <200710212342.l9LNgH02000468@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, hch@lst.de, aia21@cantab.net,
	bfields@fieldses.org, dgc@sgi.com, hirofumi@mail.parknet.co.jp,
	hugh@veritas.com, jeffm@suse.com, linux-ext4@vger.kernel.org,
	mark.fasheh@oracle.com, mason@suse.com, neilb@suse.de,
	shaggy@austin.ibm.com, swhiteho@redhat.com, tes@sgi.com,
	vs@namesys.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152AbXJUXxY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Oct 2007 19:53:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Now that nfsd has stopped writing to the find_exported_dentry member we an
mark the export_operations const

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-ext4@vger.kernel.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Chris Mason <mason@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.h              |    2 +-
 fs/cifs/export.c              |    2 +-
 fs/efs/super.c                |    2 +-
 fs/exportfs/expfs.c           |    6 +++---
 fs/ext2/super.c               |    2 +-
 fs/ext3/super.c               |    2 +-
 fs/ext4/super.c               |    2 +-
 fs/fat/inode.c                |    2 +-
 fs/gfs2/ops_export.c          |    2 +-
 fs/gfs2/ops_fstype.h          |    2 +-
 fs/isofs/export.c             |    2 +-
 fs/isofs/isofs.h              |    2 +-
 fs/jfs/super.c                |    4 ++--
 fs/ntfs/namei.c               |    2 +-
 fs/ntfs/ntfs.h                |    2 +-
 fs/ocfs2/export.c             |    2 +-
 fs/ocfs2/export.h             |    2 +-
 fs/reiserfs/super.c           |    2 +-
 fs/xfs/linux-2.6/xfs_export.c |    2 +-
 fs/xfs/linux-2.6/xfs_super.h  |    2 +-
 include/linux/fs.h            |    2 +-
 mm/shmem.c                    |    2 +-
 22 files changed, 25 insertions(+), 25 deletions(-)

diff -puN fs/cifs/cifsfs.h~exportfs-make-struct-export_operations-const fs/cifs/cifsfs.h
--- a/fs/cifs/cifsfs.h~exportfs-make-struct-export_operations-const
+++ a/fs/cifs/cifsfs.h
@@ -103,7 +103,7 @@ extern int cifs_ioctl(struct inode *inod
 		       unsigned int command, unsigned long arg);
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
-extern struct export_operations cifs_export_ops;
+extern const struct export_operations cifs_export_ops;
 #endif /* EXPERIMENTAL */
 
 #define CIFS_VERSION   "1.51"
diff -puN fs/cifs/export.c~exportfs-make-struct-export_operations-const fs/cifs/export.c
--- a/fs/cifs/export.c~exportfs-make-struct-export_operations-const
+++ a/fs/cifs/export.c
@@ -53,7 +53,7 @@ static struct dentry *cifs_get_parent(st
 	return ERR_PTR(-EACCES);
 }
 
-struct export_operations cifs_export_ops = {
+const struct export_operations cifs_export_ops = {
 	.get_parent = cifs_get_parent,
 /*	Following five export operations are unneeded so far and can default:
 	.get_dentry =
diff -puN fs/efs/super.c~exportfs-make-struct-export_operations-const fs/efs/super.c
--- a/fs/efs/super.c~exportfs-make-struct-export_operations-const
+++ a/fs/efs/super.c
@@ -113,7 +113,7 @@ static const struct super_operations efs
 	.remount_fs	= efs_remount,
 };
 
-static struct export_operations efs_export_ops = {
+static const struct export_operations efs_export_ops = {
 	.fh_to_dentry	= efs_fh_to_dentry,
 	.fh_to_parent	= efs_fh_to_parent,
 	.get_parent	= efs_get_parent,
diff -puN fs/exportfs/expfs.c~exportfs-make-struct-export_operations-const fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~exportfs-make-struct-export_operations-const
+++ a/fs/exportfs/expfs.c
@@ -16,7 +16,7 @@ static int get_name(struct dentry *dentr
 static int exportfs_get_name(struct dentry *dir, char *name,
 		struct dentry *child)
 {
-	struct export_operations *nop = dir->d_sb->s_export_op;
+	const struct export_operations *nop = dir->d_sb->s_export_op;
 
 	if (nop->get_name)
 		return nop->get_name(dir, name, child);
@@ -333,7 +333,7 @@ static int export_encode_fh(struct dentr
 int exportfs_encode_fh(struct dentry *dentry, struct fid *fid, int *max_len,
 		int connectable)
 {
- 	struct export_operations *nop = dentry->d_sb->s_export_op;
+	const struct export_operations *nop = dentry->d_sb->s_export_op;
 	int error;
 
 	if (nop->encode_fh)
@@ -349,7 +349,7 @@ struct dentry *exportfs_decode_fh(struct
 		int fh_len, int fileid_type,
 		int (*acceptable)(void *, struct dentry *), void *context)
 {
-	struct export_operations *nop = mnt->mnt_sb->s_export_op;
+	const struct export_operations *nop = mnt->mnt_sb->s_export_op;
 	struct dentry *result, *alias;
 	int err;
 
diff -puN fs/ext2/super.c~exportfs-make-struct-export_operations-const fs/ext2/super.c
--- a/fs/ext2/super.c~exportfs-make-struct-export_operations-const
+++ a/fs/ext2/super.c
@@ -357,7 +357,7 @@ static struct dentry *ext2_fh_to_parent(
  * systems, but can be improved upon.
  * Currently only get_parent is required.
  */
-static struct export_operations ext2_export_ops = {
+static const struct export_operations ext2_export_ops = {
 	.fh_to_dentry = ext2_fh_to_dentry,
 	.fh_to_parent = ext2_fh_to_parent,
 	.get_parent = ext2_get_parent,
diff -puN fs/ext3/super.c~exportfs-make-struct-export_operations-const fs/ext3/super.c
--- a/fs/ext3/super.c~exportfs-make-struct-export_operations-const
+++ a/fs/ext3/super.c
@@ -741,7 +741,7 @@ static const struct super_operations ext
 #endif
 };
 
-static struct export_operations ext3_export_ops = {
+static const struct export_operations ext3_export_ops = {
 	.fh_to_dentry = ext3_fh_to_dentry,
 	.fh_to_parent = ext3_fh_to_parent,
 	.get_parent = ext3_get_parent,
diff -puN fs/ext4/super.c~exportfs-make-struct-export_operations-const fs/ext4/super.c
--- a/fs/ext4/super.c~exportfs-make-struct-export_operations-const
+++ a/fs/ext4/super.c
@@ -796,7 +796,7 @@ static const struct super_operations ext
 #endif
 };
 
-static struct export_operations ext4_export_ops = {
+static const struct export_operations ext4_export_ops = {
 	.fh_to_dentry = ext4_fh_to_dentry,
 	.fh_to_parent = ext4_fh_to_parent,
 	.get_parent = ext4_get_parent,
diff -puN fs/fat/inode.c~exportfs-make-struct-export_operations-const fs/fat/inode.c
--- a/fs/fat/inode.c~exportfs-make-struct-export_operations-const
+++ a/fs/fat/inode.c
@@ -774,7 +774,7 @@ out:
 	return parent;
 }
 
-static struct export_operations fat_export_ops = {
+static const struct export_operations fat_export_ops = {
 	.encode_fh	= fat_encode_fh,
 	.fh_to_dentry	= fat_fh_to_dentry,
 	.get_parent	= fat_get_parent,
diff -puN fs/gfs2/ops_export.c~exportfs-make-struct-export_operations-const fs/gfs2/ops_export.c
--- a/fs/gfs2/ops_export.c~exportfs-make-struct-export_operations-const
+++ a/fs/gfs2/ops_export.c
@@ -294,7 +294,7 @@ static struct dentry *gfs2_fh_to_parent(
 	}
 }
 
-struct export_operations gfs2_export_ops = {
+const struct export_operations gfs2_export_ops = {
 	.encode_fh = gfs2_encode_fh,
 	.fh_to_dentry = gfs2_fh_to_dentry,
 	.fh_to_parent = gfs2_fh_to_parent,
diff -puN fs/gfs2/ops_fstype.h~exportfs-make-struct-export_operations-const fs/gfs2/ops_fstype.h
--- a/fs/gfs2/ops_fstype.h~exportfs-make-struct-export_operations-const
+++ a/fs/gfs2/ops_fstype.h
@@ -14,6 +14,6 @@
 
 extern struct file_system_type gfs2_fs_type;
 extern struct file_system_type gfs2meta_fs_type;
-extern struct export_operations gfs2_export_ops;
+extern const struct export_operations gfs2_export_ops;
 
 #endif /* __OPS_FSTYPE_DOT_H__ */
diff -puN fs/isofs/export.c~exportfs-make-struct-export_operations-const fs/isofs/export.c
--- a/fs/isofs/export.c~exportfs-make-struct-export_operations-const
+++ a/fs/isofs/export.c
@@ -207,7 +207,7 @@ static struct dentry *isofs_fh_to_parent
 			fh_len > 4 ? ifid->parent_generation : 0);
 }
 
-struct export_operations isofs_export_ops = {
+const struct export_operations isofs_export_ops = {
 	.encode_fh	= isofs_export_encode_fh,
 	.fh_to_dentry	= isofs_fh_to_dentry,
 	.fh_to_parent	= isofs_fh_to_parent,
diff -puN fs/isofs/isofs.h~exportfs-make-struct-export_operations-const fs/isofs/isofs.h
--- a/fs/isofs/isofs.h~exportfs-make-struct-export_operations-const
+++ a/fs/isofs/isofs.h
@@ -178,4 +178,4 @@ isofs_normalize_block_and_offset(struct 
 extern const struct inode_operations isofs_dir_inode_operations;
 extern const struct file_operations isofs_dir_operations;
 extern const struct address_space_operations isofs_symlink_aops;
-extern struct export_operations isofs_export_ops;
+extern const struct export_operations isofs_export_ops;
diff -puN fs/jfs/super.c~exportfs-make-struct-export_operations-const fs/jfs/super.c
--- a/fs/jfs/super.c~exportfs-make-struct-export_operations-const
+++ a/fs/jfs/super.c
@@ -48,7 +48,7 @@ MODULE_LICENSE("GPL");
 static struct kmem_cache * jfs_inode_cachep;
 
 static const struct super_operations jfs_super_operations;
-static struct export_operations jfs_export_operations;
+static const struct export_operations jfs_export_operations;
 static struct file_system_type jfs_fs_type;
 
 #define MAX_COMMIT_THREADS 64
@@ -737,7 +737,7 @@ static const struct super_operations jfs
 #endif
 };
 
-static struct export_operations jfs_export_operations = {
+static const struct export_operations jfs_export_operations = {
 	.fh_to_dentry	= jfs_fh_to_dentry,
 	.fh_to_parent	= jfs_fh_to_parent,
 	.get_parent	= jfs_get_parent,
diff -puN fs/ntfs/namei.c~exportfs-make-struct-export_operations-const fs/ntfs/namei.c
--- a/fs/ntfs/namei.c~exportfs-make-struct-export_operations-const
+++ a/fs/ntfs/namei.c
@@ -499,7 +499,7 @@ static struct dentry *ntfs_fh_to_parent(
  * allowing the inode number 0 which is used in NTFS for the system file $MFT
  * and due to using iget() whereas NTFS needs ntfs_iget().
  */
-struct export_operations ntfs_export_ops = {
+const struct export_operations ntfs_export_ops = {
 	.get_parent	= ntfs_get_parent,	/* Find the parent of a given
 						   directory. */
 	.fh_to_dentry	= ntfs_fh_to_dentry,
diff -puN fs/ntfs/ntfs.h~exportfs-make-struct-export_operations-const fs/ntfs/ntfs.h
--- a/fs/ntfs/ntfs.h~exportfs-make-struct-export_operations-const
+++ a/fs/ntfs/ntfs.h
@@ -69,7 +69,7 @@ extern const struct inode_operations ntf
 extern const struct  file_operations ntfs_empty_file_ops;
 extern const struct inode_operations ntfs_empty_inode_ops;
 
-extern struct export_operations ntfs_export_ops;
+extern const struct export_operations ntfs_export_ops;
 
 /**
  * NTFS_SB - return the ntfs volume given a vfs super block
diff -puN fs/ocfs2/export.c~exportfs-make-struct-export_operations-const fs/ocfs2/export.c
--- a/fs/ocfs2/export.c~exportfs-make-struct-export_operations-const
+++ a/fs/ocfs2/export.c
@@ -222,7 +222,7 @@ static struct dentry *ocfs2_fh_to_parent
 	return ocfs2_get_dentry(sb, &parent);
 }
 
-struct export_operations ocfs2_export_ops = {
+const struct export_operations ocfs2_export_ops = {
 	.encode_fh	= ocfs2_encode_fh,
 	.fh_to_dentry	= ocfs2_fh_to_dentry,
 	.fh_to_parent	= ocfs2_fh_to_parent,
diff -puN fs/ocfs2/export.h~exportfs-make-struct-export_operations-const fs/ocfs2/export.h
--- a/fs/ocfs2/export.h~exportfs-make-struct-export_operations-const
+++ a/fs/ocfs2/export.h
@@ -28,6 +28,6 @@
 
 #include <linux/exportfs.h>
 
-extern struct export_operations ocfs2_export_ops;
+extern const struct export_operations ocfs2_export_ops;
 
 #endif /* OCFS2_EXPORT_H */
diff -puN fs/reiserfs/super.c~exportfs-make-struct-export_operations-const fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~exportfs-make-struct-export_operations-const
+++ a/fs/reiserfs/super.c
@@ -661,7 +661,7 @@ static struct quotactl_ops reiserfs_qctl
 };
 #endif
 
-static struct export_operations reiserfs_export_ops = {
+static const struct export_operations reiserfs_export_ops = {
 	.encode_fh = reiserfs_encode_fh,
 	.fh_to_dentry = reiserfs_fh_to_dentry,
 	.fh_to_parent = reiserfs_fh_to_parent,
diff -puN fs/xfs/linux-2.6/xfs_export.c~exportfs-make-struct-export_operations-const fs/xfs/linux-2.6/xfs_export.c
--- a/fs/xfs/linux-2.6/xfs_export.c~exportfs-make-struct-export_operations-const
+++ a/fs/xfs/linux-2.6/xfs_export.c
@@ -220,7 +220,7 @@ xfs_fs_get_parent(
 	return parent;
 }
 
-struct export_operations xfs_export_operations = {
+const struct export_operations xfs_export_operations = {
 	.encode_fh		= xfs_fs_encode_fh,
 	.fh_to_dentry		= xfs_fs_fh_to_dentry,
 	.fh_to_parent		= xfs_fs_fh_to_parent,
diff -puN fs/xfs/linux-2.6/xfs_super.h~exportfs-make-struct-export_operations-const fs/xfs/linux-2.6/xfs_super.h
--- a/fs/xfs/linux-2.6/xfs_super.h~exportfs-make-struct-export_operations-const
+++ a/fs/xfs/linux-2.6/xfs_super.h
@@ -118,7 +118,7 @@ extern int  xfs_blkdev_get(struct xfs_mo
 extern void xfs_blkdev_put(struct block_device *);
 extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
 
-extern struct export_operations xfs_export_operations;
+extern const struct export_operations xfs_export_operations;
 
 #define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
 
diff -puN include/linux/fs.h~exportfs-make-struct-export_operations-const include/linux/fs.h
--- a/include/linux/fs.h~exportfs-make-struct-export_operations-const
+++ a/include/linux/fs.h
@@ -987,7 +987,7 @@ struct super_block {
 	const struct super_operations	*s_op;
 	struct dquot_operations	*dq_op;
  	struct quotactl_ops	*s_qcop;
-	struct export_operations *s_export_op;
+	const struct export_operations *s_export_op;
 	unsigned long		s_flags;
 	unsigned long		s_magic;
 	struct dentry		*s_root;
diff -puN mm/shmem.c~exportfs-make-struct-export_operations-const mm/shmem.c
--- a/mm/shmem.c~exportfs-make-struct-export_operations-const
+++ a/mm/shmem.c
@@ -2071,7 +2071,7 @@ static int shmem_encode_fh(struct dentry
 	return 1;
 }
 
-static struct export_operations shmem_export_ops = {
+static const struct export_operations shmem_export_ops = {
 	.get_parent     = shmem_get_parent,
 	.encode_fh      = shmem_encode_fh,
 	.fh_to_dentry	= shmem_fh_to_dentry,
_
