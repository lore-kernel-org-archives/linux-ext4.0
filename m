From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 1/3] ext2: show all mount options
Date: Mon, 23 Jul 2007 22:12:54 +0200
Message-ID: <E1ID4H0-00065Q-00@dorka.pomaz.szeredi.hu>
Cc: akpm@linux-foundation.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:36149 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139AbXGWUSd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jul 2007 16:18:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux-2.6/fs/ext2/super.c
===================================================================
--- linux-2.6.orig/fs/ext2/super.c	2007-07-23 17:41:29.000000000 +0200
+++ linux-2.6/fs/ext2/super.c	2007-07-23 18:02:38.000000000 +0200
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
@@ -658,6 +714,7 @@ static int ext2_fill_super(struct super_
 	if (!sbi)
 		return -ENOMEM;
 	sb->s_fs_info = sbi;
+	sbi->s_sb_block = sb_block;
 
 	/*
 	 * See what the current blocksize for the device is, and
Index: linux-2.6/include/linux/ext2_fs_sb.h
===================================================================
--- linux-2.6.orig/include/linux/ext2_fs_sb.h	2007-07-23 17:41:29.000000000 +0200
+++ linux-2.6/include/linux/ext2_fs_sb.h	2007-07-23 18:01:40.000000000 +0200
@@ -39,6 +39,7 @@ struct ext2_sb_info {
 	struct ext2_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
 	unsigned long  s_mount_opt;
+	unsigned long s_sb_block;
 	uid_t s_resuid;
 	gid_t s_resgid;
 	unsigned short s_mount_state;
