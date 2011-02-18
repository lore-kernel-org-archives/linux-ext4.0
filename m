From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: enable acls and user_xattr by default
Date: Fri, 18 Feb 2011 14:31:01 -0600
Message-ID: <4D5ED705.7010902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757582Ab1BRUbF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Feb 2011 15:31:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There's no good reason to require the extra step of providing
a mount option for acl or user_xattr once the feature is configured
on; no other filesystem that I know of requires this.

Userspace patches have set these options in default mount options,
and this patch makes them default in the kernel.  At some point
we can start to deprecate the options, perhaps.

For now I've removed default mount option checks in show_options()
to be explicit about what's set, since it's changing the default,
but I'm open to alternatives if desired.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. I've got ext2 & ext3 patches too - Jan, is this ok with
you for ext2/3 as well?


index 48ce561..77dec05 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -995,13 +995,10 @@ static int ext4_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (test_opt(sb, OLDALLOC))
 		seq_puts(seq, ",oldalloc");
 #ifdef CONFIG_EXT4_FS_XATTR
-	if (test_opt(sb, XATTR_USER) &&
-		!(def_mount_opts & EXT4_DEFM_XATTR_USER))
+	if (test_opt(sb, XATTR_USER))
 		seq_puts(seq, ",user_xattr");
-	if (!test_opt(sb, XATTR_USER) &&
-	    (def_mount_opts & EXT4_DEFM_XATTR_USER)) {
+	if (!test_opt(sb, XATTR_USER))
 		seq_puts(seq, ",nouser_xattr");
-	}
 #endif
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 	if (test_opt(sb, POSIX_ACL) && !(def_mount_opts & EXT4_DEFM_ACL))
@@ -3093,13 +3090,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	if (def_mount_opts & EXT4_DEFM_UID16)
 		set_opt(sb, NO_UID32);
+	/* xattr user namespace & acls are now defaulted on */
 #ifdef CONFIG_EXT4_FS_XATTR
-	if (def_mount_opts & EXT4_DEFM_XATTR_USER)
-		set_opt(sb, XATTR_USER);
+	set_opt(sb, XATTR_USER);
 #endif
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
-	if (def_mount_opts & EXT4_DEFM_ACL)
-		set_opt(sb, POSIX_ACL);
+	set_opt(sb, POSIX_ACL);
 #endif
 	if ((def_mount_opts & EXT4_DEFM_JMODE) == EXT4_DEFM_JMODE_DATA)
 		set_opt(sb, JOURNAL_DATA);
