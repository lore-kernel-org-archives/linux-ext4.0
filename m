From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 2/3] ext3: show all mount options
Date: Tue, 24 Jul 2007 22:16:13 +0200
Message-ID: <E1IDQnl-00010g-00@dorka.pomaz.szeredi.hu>
References: <E1IDQmw-00010C-00@dorka.pomaz.szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:57697 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763646AbXGXUQZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 16:16:25 -0400
In-reply-to: <E1IDQmw-00010C-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Tue, 24 Jul 2007 22:15:22 +0200)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c	2007-07-20 12:22:35.000000000 +0200
+++ linux-2.6/fs/ext3/super.c	2007-07-23 18:03:46.000000000 +0200
@@ -545,9 +545,78 @@ static inline void ext3_show_quota_optio
 #endif
 }
 
+/*
+ * Show an option if
+ *  - it's set to a non-default value OR
+ *  - if the per-sb default is different from the global default
+ */
 static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 {
 	struct super_block *sb = vfs->mnt_sb;
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	struct ext3_super_block *es = sbi->s_es;
+	unsigned long def_mount_opts;
+
+	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
+
+	if (sbi->s_sb_block != 1)
+		seq_printf(seq, ",sb=%lu", sbi->s_sb_block);
+	if (test_opt(sb, MINIX_DF))
+		seq_puts(seq, ",minixdf");
+	if (test_opt(sb, GRPID))
+		seq_puts(seq, ",grpid");
+	if (!test_opt(sb, GRPID) && (def_mount_opts & EXT3_DEFM_BSDGROUPS))
+		seq_puts(seq, ",nogrpid");
+	if (sbi->s_resuid != EXT3_DEF_RESUID ||
+	    le16_to_cpu(es->s_def_resuid) != EXT3_DEF_RESUID) {
+		seq_printf(seq, ",resuid=%u", sbi->s_resuid);
+	}
+	if (sbi->s_resgid != EXT3_DEF_RESGID ||
+	    le16_to_cpu(es->s_def_resgid) != EXT3_DEF_RESGID) {
+		seq_printf(seq, ",resgid=%u", sbi->s_resgid);
+	}
+	if (test_opt(sb, ERRORS_CONT)) {
+		int def_errors = le16_to_cpu(es->s_errors);
+
+		if (def_errors == EXT3_ERRORS_PANIC ||
+		    def_errors == EXT3_ERRORS_RO) {
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
+#ifdef CONFIG_EXT3_FS_XATTR
+	if (test_opt(sb, XATTR_USER))
+		seq_puts(seq, ",user_xattr");
+	if (!test_opt(sb, XATTR_USER) &&
+	    (def_mount_opts & EXT3_DEFM_XATTR_USER)) {
+		seq_puts(seq, ",nouser_xattr");
+	}
+#endif
+#ifdef CONFIG_EXT3_FS_POSIX_ACL
+	if (test_opt(sb, POSIX_ACL))
+		seq_puts(seq, ",acl");
+	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT3_DEFM_ACL))
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
 
 	if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA)
 		seq_puts(seq, ",data=journal");
@@ -1424,6 +1493,7 @@ static int ext3_fill_super (struct super
 	sbi->s_mount_opt = 0;
 	sbi->s_resuid = EXT3_DEF_RESUID;
 	sbi->s_resgid = EXT3_DEF_RESGID;
+	sbi->s_sb_block = sb_block;
 
 	unlock_kernel();
 
Index: linux-2.6/include/linux/ext3_fs_sb.h
===================================================================
--- linux-2.6.orig/include/linux/ext3_fs_sb.h	2007-07-20 12:22:40.000000000 +0200
+++ linux-2.6/include/linux/ext3_fs_sb.h	2007-07-23 18:05:24.000000000 +0200
@@ -44,6 +44,7 @@ struct ext3_sb_info {
 	struct ext3_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
 	unsigned long  s_mount_opt;
+	ext3_fsblk_t s_sb_block;
 	uid_t s_resuid;
 	gid_t s_resgid;
 	unsigned short s_mount_state;
