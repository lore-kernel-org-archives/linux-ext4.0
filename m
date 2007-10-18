From: akpm@linux-foundation.org
Subject: - ext4-show-all-mount-options.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:57 -0700
Message-ID: <200710180653.l9I6rvv6030483@imap1.linux-foundation.org>
To: mszeredi@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761302AbXJRHl2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Oct 2007 03:41:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: show all mount options
has been removed from the -mm tree.  Its filename was
     ext4-show-all-mount-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: show all mount options
From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c            |   72 +++++++++++++++++++++++++++++++++++
 include/linux/ext4_fs_sb.h |    1 
 2 files changed, 73 insertions(+)

diff -puN fs/ext4/super.c~ext4-show-all-mount-options fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-show-all-mount-options
+++ a/fs/ext4/super.c
@@ -596,9 +596,80 @@ static inline void ext4_show_quota_optio
 #endif
 }
 
+/*
+ * Show an option if
+ *  - it's set to a non-default value OR
+ *  - if the per-sb default is different from the global default
+ */
 static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
 	struct super_block *sb = vfs->mnt_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
+	unsigned long def_mount_opts;
+
+	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
+
+	if (sbi->s_sb_block != 1)
+		seq_printf(seq, ",sb=%llu", sbi->s_sb_block);
+	if (test_opt(sb, MINIX_DF))
+		seq_puts(seq, ",minixdf");
+	if (test_opt(sb, GRPID))
+		seq_puts(seq, ",grpid");
+	if (!test_opt(sb, GRPID) && (def_mount_opts & EXT4_DEFM_BSDGROUPS))
+		seq_puts(seq, ",nogrpid");
+	if (sbi->s_resuid != EXT4_DEF_RESUID ||
+	    le16_to_cpu(es->s_def_resuid) != EXT4_DEF_RESUID) {
+		seq_printf(seq, ",resuid=%u", sbi->s_resuid);
+	}
+	if (sbi->s_resgid != EXT4_DEF_RESGID ||
+	    le16_to_cpu(es->s_def_resgid) != EXT4_DEF_RESGID) {
+		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
+	}
+	if (test_opt(sb, ERRORS_CONT)) {
+		int def_errors = le16_to_cpu(es->s_errors);
+
+		if (def_errors == EXT4_ERRORS_PANIC ||
+		    def_errors == EXT4_ERRORS_RO) {
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
+#ifdef CONFIG_EXT4_FS_XATTR
+	if (test_opt(sb, XATTR_USER))
+		seq_puts(seq, ",user_xattr");
+	if (!test_opt(sb, XATTR_USER) &&
+	    (def_mount_opts & EXT4_DEFM_XATTR_USER)) {
+		seq_puts(seq, ",nouser_xattr");
+	}
+#endif
+#ifdef CONFIG_EXT4_FS_POSIX_ACL
+	if (test_opt(sb, POSIX_ACL))
+		seq_puts(seq, ",acl");
+	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
+		seq_puts(seq, ",noacl");
+#endif
+	if (!test_opt(sb, RESERVATION))
+		seq_puts(seq, ",noreservation");
+	if (sbi->s_commit_interval) {
+		seq_printf(seq, ",commit=%u",
+			   (unsigned) (sbi->s_commit_interval / HZ));
+	}
+	if (test_opt(sb, BARRIER))
+		seq_puts(seq, ",barrier=1");
+	if (test_opt(sb, NOBH))
+		seq_puts(seq, ",nobh");
+	if (!test_opt(sb, EXTENTS))
+		seq_puts(seq, ",noextents");
 
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 		seq_puts(seq, ",data=journal");
@@ -1486,6 +1557,7 @@ static int ext4_fill_super (struct super
 	sbi->s_mount_opt = 0;
 	sbi->s_resuid = EXT4_DEF_RESUID;
 	sbi->s_resgid = EXT4_DEF_RESGID;
+	sbi->s_sb_block = sb_block;
 
 	unlock_kernel();
 
diff -puN include/linux/ext4_fs_sb.h~ext4-show-all-mount-options include/linux/ext4_fs_sb.h
--- a/include/linux/ext4_fs_sb.h~ext4-show-all-mount-options
+++ a/include/linux/ext4_fs_sb.h
@@ -45,6 +45,7 @@ struct ext4_sb_info {
 	struct ext4_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
 	unsigned long  s_mount_opt;
+	ext4_fsblk_t s_sb_block;
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
