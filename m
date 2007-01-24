From: akpm@osdl.org
Subject: + fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls.patch added to -mm tree
Date: Tue, 23 Jan 2007 16:58:59 -0800
Message-ID: <200701240058.l0O0wxjh004404@shell0.pdx.osdl.net>
Cc: hugh@veritas.com, agruen@suse.de, linux-ext4@vger.kernel.org,
	tigran@aivazian.fsnet.co.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45605 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149AbXAXA7W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Jan 2007 19:59:22 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     fix umask when noACL kernel meets extN tuned for ACLs
has been added to the -mm tree.  Its filename is
     fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix umask when noACL kernel meets extN tuned for ACLs
From: Hugh Dickins <hugh@veritas.com>

Fix insecure default behaviour reported by Tigran Aivazian: if an ext2 or
ext3 or ext4 filesystem is tuned to mount with "acl", but mounted by a
kernel built without ACL support, then umask was ignored when creating
inodes - though root or user has umask 022, touch creates files as 0666,
and mkdir creates directories as 0777.

This appears to have worked right until 2.6.11, when a fix to the default
mode on symlinks (always 0777) assumed VFS applies umask: which it does,
unless the mount is marked for ACLs; but ext[234] set MS_POSIXACL in
s_flags according to s_mount_opt set according to def_mount_opts.

We could revert to the 2.6.10 ext[234]_init_acl (adding an S_ISLNK test);
but other filesystems only set MS_POSIXACL when ACLs are configured.  We
could fix this at another level; but it seems most robust to avoid setting
the s_mount_opt flag in the first place (at the expense of more ifdefs).

Likewise don't set the XATTR_USER flag when built without XATTR support.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Cc: <linux-ext4@vger.kernel.org>
Cc: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/super.c |    4 ++++
 fs/ext3/super.c |    4 ++++
 fs/ext4/super.c |    4 ++++
 3 files changed, 12 insertions(+)

diff -puN fs/ext2/super.c~fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls fs/ext2/super.c
--- a/fs/ext2/super.c~fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls
+++ a/fs/ext2/super.c
@@ -708,10 +708,14 @@ static int ext2_fill_super(struct super_
 		set_opt(sbi->s_mount_opt, GRPID);
 	if (def_mount_opts & EXT2_DEFM_UID16)
 		set_opt(sbi->s_mount_opt, NO_UID32);
+#ifdef CONFIG_EXT2_FS_XATTR
 	if (def_mount_opts & EXT2_DEFM_XATTR_USER)
 		set_opt(sbi->s_mount_opt, XATTR_USER);
+#endif
+#ifdef CONFIG_EXT2_FS_POSIX_ACL
 	if (def_mount_opts & EXT2_DEFM_ACL)
 		set_opt(sbi->s_mount_opt, POSIX_ACL);
+#endif
 	
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_PANIC)
 		set_opt(sbi->s_mount_opt, ERRORS_PANIC);
diff -puN fs/ext3/super.c~fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls fs/ext3/super.c
--- a/fs/ext3/super.c~fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls
+++ a/fs/ext3/super.c
@@ -1459,10 +1459,14 @@ static int ext3_fill_super (struct super
 		set_opt(sbi->s_mount_opt, GRPID);
 	if (def_mount_opts & EXT3_DEFM_UID16)
 		set_opt(sbi->s_mount_opt, NO_UID32);
+#ifdef CONFIG_EXT3_FS_XATTR
 	if (def_mount_opts & EXT3_DEFM_XATTR_USER)
 		set_opt(sbi->s_mount_opt, XATTR_USER);
+#endif
+#ifdef CONFIG_EXT3_FS_POSIX_ACL
 	if (def_mount_opts & EXT3_DEFM_ACL)
 		set_opt(sbi->s_mount_opt, POSIX_ACL);
+#endif
 	if ((def_mount_opts & EXT3_DEFM_JMODE) == EXT3_DEFM_JMODE_DATA)
 		sbi->s_mount_opt |= EXT3_MOUNT_JOURNAL_DATA;
 	else if ((def_mount_opts & EXT3_DEFM_JMODE) == EXT3_DEFM_JMODE_ORDERED)
diff -puN fs/ext4/super.c~fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls fs/ext4/super.c
--- a/fs/ext4/super.c~fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls
+++ a/fs/ext4/super.c
@@ -1518,10 +1518,14 @@ static int ext4_fill_super (struct super
 		set_opt(sbi->s_mount_opt, GRPID);
 	if (def_mount_opts & EXT4_DEFM_UID16)
 		set_opt(sbi->s_mount_opt, NO_UID32);
+#ifdef CONFIG_EXT4DEV_FS_XATTR
 	if (def_mount_opts & EXT4_DEFM_XATTR_USER)
 		set_opt(sbi->s_mount_opt, XATTR_USER);
+#endif
+#ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
 	if (def_mount_opts & EXT4_DEFM_ACL)
 		set_opt(sbi->s_mount_opt, POSIX_ACL);
+#endif
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
 		sbi->s_mount_opt |= EXT4_MOUNT_JOURNAL_DATA;
 	else if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_ORDERED)
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
slab-cache_grow-cleanup.patch
fix-umask-when-noacl-kernel-meets-extn-tuned-for-acls.patch
ext2-reservations.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
