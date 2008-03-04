From: Josef Bacik <jbacik@redhat.com>
Subject: [RFC PATCH 2/2] add a mount option for ext3 to support the unclean jbd option
Date: Tue, 4 Mar 2008 13:41:41 -0500
Message-ID: <200803041341.41798.jbacik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764619AbYCDSyB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Mar 2008 13:54:01 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I'm just now realizing i sent the previous patch with 1/1 instead of 1/2 in the 
subject :(.  This just lets me use "unclean_journal" as a mount option to flip 
the appropriate flag for the journal in order to make it not reset the journal 
when we unmount the fs.  Thanks much,

Josef

Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c
+++ linux-2.6/fs/ext3/super.c
@@ -625,6 +625,9 @@ static int ext3_show_options(struct seq_
 	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)
 		seq_puts(seq, ",data=writeback");
 
+	if (test_opt(sb, UNCLEAN_JOURNAL))
+		seq_puts(seq, ",unclean_journal");
+
 	ext3_show_quota_options(seq, sb);
 
 	return 0;
@@ -756,7 +759,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_grpquota, Opt_unclean_journal,
 };
 
 static match_table_t tokens = {
@@ -807,6 +810,7 @@ static match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_resize, "resize"},
+	{Opt_unclean_journal, "unclean_journal"},
 	{Opt_err, NULL},
 };
 
@@ -1138,6 +1142,9 @@ clear_qf_name:
 		case Opt_bh:
 			clear_opt(sbi->s_mount_opt, NOBH);
 			break;
+		case Opt_unclean_journal:
+			set_opt(sbi->s_mount_opt, UNCLEAN_JOURNAL);
+			break;
 		default:
 			printk (KERN_ERR
 				"EXT3-fs: Unrecognized mount option \"%s\" "
@@ -1968,6 +1975,12 @@ static void ext3_init_journal_params(str
 		journal->j_flags |= JFS_BARRIER;
 	else
 		journal->j_flags &= ~JFS_BARRIER;
+
+	if (test_opt(sb, UNCLEAN_JOURNAL))
+		journal->j_flags |= JFS_UNCLEAN;
+	else
+		journal->j_flags &= ~JFS_UNCLEAN;
+
 	spin_unlock(&journal->j_state_lock);
 }
 
Index: linux-2.6/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.orig/include/linux/ext3_fs.h
+++ linux-2.6/include/linux/ext3_fs.h
@@ -380,6 +380,7 @@ struct ext3_inode {
 #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT3_MOUNT_UNCLEAN_JOURNAL	0x400000 /* Leave an unclean journal */
 
 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
