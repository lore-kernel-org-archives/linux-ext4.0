From: akpm@linux-foundation.org
Subject: - ext4-new-export-ops.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:30 -0700
Message-ID: <200710230647.l9N6lURT004287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: hch@lst.de, bfields@fieldses.org, linux-ext4@vger.kernel.org,
	neilb@suse.de, mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: new export ops
has been removed from the -mm tree.  Its filename was
     ext4-new-export-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: new export ops
From: Christoph Hellwig <hch@lst.de>

Trivial switch over to the new generic helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff -puN fs/ext4/super.c~ext4-new-export-ops fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-new-export-ops
+++ a/fs/ext4/super.c
@@ -686,13 +686,10 @@ static int ext4_show_options(struct seq_
 }
 
 
-static struct dentry *ext4_get_dentry(struct super_block *sb, void *vobjp)
+static struct inode *ext4_nfs_get_inode(struct super_block *sb,
+		u64 ino, u32 generation)
 {
-	__u32 *objp = vobjp;
-	unsigned long ino = objp[0];
-	__u32 generation = objp[1];
 	struct inode *inode;
-	struct dentry *result;
 
 	if (ino < EXT4_FIRST_INO(sb) && ino != EXT4_ROOT_INO)
 		return ERR_PTR(-ESTALE);
@@ -715,15 +712,22 @@ static struct dentry *ext4_get_dentry(st
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
-	/* now to find a dentry.
-	 * If possible, get a well-connected one
-	 */
-	result = d_alloc_anon(inode);
-	if (!result) {
-		iput(inode);
-		return ERR_PTR(-ENOMEM);
-	}
-	return result;
+
+	return inode;
+}
+
+static struct dentry *ext4_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    ext4_nfs_get_inode);
+}
+
+static struct dentry *ext4_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    ext4_nfs_get_inode);
 }
 
 #ifdef CONFIG_QUOTA
@@ -793,8 +797,9 @@ static const struct super_operations ext
 };
 
 static struct export_operations ext4_export_ops = {
+	.fh_to_dentry = ext4_fh_to_dentry,
+	.fh_to_parent = ext4_fh_to_parent,
 	.get_parent = ext4_get_parent,
-	.get_dentry = ext4_get_dentry,
 };
 
 enum {
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-unionfs.patch
git-xfs.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
make-__d_path-to-take-a-struct-path-argument.patch
use-struct-path-argument-in-proc_get_link.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
