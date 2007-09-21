From: akpm@linux-foundation.org
Subject: + ext3-new-export-ops.patch added to -mm tree
Date: Thu, 20 Sep 2007 17:13:09 -0700
Message-ID: <200709210013.l8L0D9KZ009755@imap1.linux-foundation.org>
Cc: hch@lst.de, bfields@fieldses.org, linux-ext4@vger.kernel.org,
	neilb@suse.de
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49428 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbXIUAOH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Sep 2007 20:14:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: new export ops
has been added to the -mm tree.  Its filename is
     ext3-new-export-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3: new export ops
From: Christoph Hellwig <hch@lst.de>

Trivial switch over to the new generic helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff -puN fs/ext3/super.c~ext3-new-export-ops fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-new-export-ops
+++ a/fs/ext3/super.c
@@ -631,13 +631,10 @@ static int ext3_show_options(struct seq_
 }
 
 
-static struct dentry *ext3_get_dentry(struct super_block *sb, void *vobjp)
+static struct inode *ext3_nfs_get_inode(struct super_block *sb,
+		u64 ino, u32 generation)
 {
-	__u32 *objp = vobjp;
-	unsigned long ino = objp[0];
-	__u32 generation = objp[1];
 	struct inode *inode;
-	struct dentry *result;
 
 	if (ino < EXT3_FIRST_INO(sb) && ino != EXT3_ROOT_INO)
 		return ERR_PTR(-ESTALE);
@@ -660,15 +657,22 @@ static struct dentry *ext3_get_dentry(st
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
+static struct dentry *ext3_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    ext3_nfs_get_inode);
+}
+
+static struct dentry *ext3_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    ext3_nfs_get_inode);
 }
 
 #ifdef CONFIG_QUOTA
@@ -738,8 +742,9 @@ static const struct super_operations ext
 };
 
 static struct export_operations ext3_export_ops = {
+	.fh_to_dentry = ext3_fh_to_dentry,
+	.fh_to_parent = ext3_fh_to_parent,
 	.get_parent = ext3_get_parent,
-	.get_dentry = ext3_get_dentry,
 };
 
 enum {
_

Patches currently in -mm which might be from hch@lst.de are

git-nfs.patch
git-nfsd.patch
partially-fix-up-the-lookup_one_noperm-mess.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
git-xfs.patch
sysv-convert-to-new-aops.patch
alpha-convert-to-generic-sys_ptrace.patch
kill-declare_mutex_locked.patch
remove-unneded-lock_kernel-in-driver-block-loopc.patch
ufs-move-non-layout-parts-of-ufs_fsh-to-fs-ufs.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
xfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
