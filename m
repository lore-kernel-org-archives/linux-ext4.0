From: akpm@linux-foundation.org
Subject: - ext2-show-all-mount-options.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:53 -0700
Message-ID: <200710180653.l9I6rrPi030477@imap1.linux-foundation.org>
To: mszeredi@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932707AbXJRHlq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 03:41:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: show all mount options
has been removed from the -mm tree.  Its filename was
     ext2-show-all-mount-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext2: show all mount options
From: Miklos Szeredi <mszeredi@suse.cz>

Using mtab is problematic for various reasons, one of them is that
unprivileged mounts won't turn up in there.  So we want to get rid of it, and
use /proc/mounts instead.

But most filesystems are lazy, and are not showing all mount options.  Which
means, that without mtab, the user won't be able to see some or all of the
options.

It would be nice if the generic code could remember the mount options, and
show them without the need to add extra code to filesystems.  But this is not
easy, because different filesystems handle mount options given options, and
not tough the rest.  This is not taken into account by mount(8) either, so
/etc/mtab will be broken in this case.

This series fixes up ->show_options() in ext[234].

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/super.c            |   61 +++++++++++++++++++++++++++++++++--
 include/linux/ext2_fs_sb.h |    1 
 2 files changed, 60 insertions(+), 2 deletions(-)

diff -puN fs/ext2/super.c~ext2-show-all-mount-options fs/ext2/super.c
--- a/fs/ext2/super.c~ext2-show-all-mount-options
+++ a/fs/ext2/super.c
@@ -203,10 +203,66 @@ static void ext2_clear_inode(struct inod
 
 static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
-	struct ext2_sb_info *sbi = EXT2_SB(vfs->mnt_sb);
+	struct super_block *sb = vfs->mnt_sb;
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
+	struct ext2_super_block *es = sbi->s_es;
+	unsigned long def_mount_opts;
+
+	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 
-	if (sbi->s_mount_opt & EXT2_MOUNT_GRPID)
+	if (sbi->s_sb_block != 1)
+		seq_printf(seq, ",sb=%lu", sbi->s_sb_block);
+	if (test_opt(sb, MINIX_DF))
+		seq_puts(seq, ",minixdf");
+	if (test_opt(sb, GRPID))
 		seq_puts(seq, ",grpid");
+	if (!test_opt(sb, GRPID) && (def_mount_opts & EXT2_DEFM_BSDGROUPS))
+		seq_puts(seq, ",nogrpid");
+	if (sbi->s_resuid != EXT2_DEF_RESUID ||
+	    le16_to_cpu(es->s_def_resuid) != EXT2_DEF_RESUID) {
+		seq_printf(seq, ",resuid=%u", sbi->s_resuid);
+	}
+	if (sbi->s_resgid != EXT2_DEF_RESGID ||
+	    le16_to_cpu(es->s_def_resgid) != EXT2_DEF_RESGID) {
+		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
+	}
+	if (test_opt(sb, ERRORS_CONT)) {
+		int def_errors = le16_to_cpu(es->s_errors);
+
+		if (def_errors == EXT2_ERRORS_PANIC ||
+		    def_errors == EXT2_ERRORS_RO) {
+			seq_puts(seq, ",errors=continue");
+		}
+	}
+	if (test_opt(sb, ERRORS_RO))
+		seq_puts(seq, ",errors=remount-ro");
+	if (test_opt(sb, ERRORS_PANIC))
+		seq_puts(seq, ",errors=panic");
+	if (test_opt(sb, NO_UID32))
+		seq_puts(seq, ",nouid32");
+	if (test_opt(sb, DEBUG))
+		seq_puts(seq, ",debug");
+	if (test_opt(sb, OLDALLOC))
+		seq_puts(seq, ",oldalloc");
+
+#ifdef CONFIG_EXT2_FS_XATTR
+	if (test_opt(sb, XATTR_USER))
+		seq_puts(seq, ",user_xattr");
+	if (!test_opt(sb, XATTR_USER) &&
+	    (def_mount_opts & EXT2_DEFM_XATTR_USER)) {
+		seq_puts(seq, ",nouser_xattr");
+	}
+#endif
+
+#ifdef CONFIG_EXT2_FS_POSIX_ACL
+	if (test_opt(sb, POSIX_ACL))
+		seq_puts(seq, ",acl");
+	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT2_DEFM_ACL))
+		seq_puts(seq, ",noacl");
+#endif
+
+	if (test_opt(sb, NOBH))
+		seq_puts(seq, ",nobh");
 
 #if defined(CONFIG_QUOTA)
 	if (sbi->s_mount_opt & EXT2_MOUNT_USRQUOTA)
@@ -659,6 +715,7 @@ static int ext2_fill_super(struct super_
 	if (!sbi)
 		return -ENOMEM;
 	sb->s_fs_info = sbi;
+	sbi->s_sb_block = sb_block;
 
 	/*
 	 * See what the current blocksize for the device is, and
diff -puN include/linux/ext2_fs_sb.h~ext2-show-all-mount-options include/linux/ext2_fs_sb.h
--- a/include/linux/ext2_fs_sb.h~ext2-show-all-mount-options
+++ a/include/linux/ext2_fs_sb.h
@@ -39,6 +39,7 @@ struct ext2_sb_info {
 	struct ext2_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
 	unsigned long  s_mount_opt;
+	unsigned long s_sb_block;
 	uid_t s_resuid;
 	gid_t s_resgid;
 	unsigned short s_mount_state;
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts-fix-subtype-handling.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-propagation-inherit-owner-from-parent-fix-for-git-audit.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
fuse-fix-allowing-operations.patch
fuse-fix-race-between-getattr-and-write.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
fuse-clean-up-open-file-passing-in-setattr.patch
vfs-allow-filesystems-to-implement-atomic-opentruncate.patch
fuse-improve-utimes-support.patch
fuse-add-atomic-opentruncate-support.patch
fuse-support-bsd-locking-semantics.patch
fuse-add-list-of-writable-files-to-fuse_inode.patch
fuse-add-helper-for-asynchronous-writes.patch
fuse-add-support-for-mandatory-locking.patch
fuse-add-blksize-field-to-fuse_attr.patch
