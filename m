From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH] ext4: add an option to control error handling on file data
Date: Fri, 10 Oct 2008 18:04:09 +0900
Message-ID: <48EF1A89.1080300@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, jack@suse.cz
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34027 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbYJJJER (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 05:04:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the journal doesn't abort when it gets an IO error in file data
blocks, the file data corruption will spread silently.  Because
most of applications and commands do buffered writes without fsync(),
they don't notice the IO error.  It's scary for mission critical
systems.  On the other hand, if the journal aborts whenever it gets
an IO error in file data blocks, the system will easily become
inoperable.  So this patch introduces a filesystem option to
determine whether it aborts the journal or just call printk() when
it gets an IO error in file data.

If you mount an ext4 fs with data_err=abort option, it aborts on file
data write error.  If you mount it with data_err=ignore, it doesn't
abort, just call printk().  data_err=ignore is the default.

Here is the corresponding patch of the ext3 version:
http://kerneltrap.org/mailarchive/linux-kernel/2008/9/9/3239374

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 Documentation/filesystems/ext4.txt |    5 +++++
 fs/ext4/ext4.h                     |    3 +++
 fs/ext4/super.c                    |   16 ++++++++++++++++
 fs/jbd2/commit.c                   |    2 ++
 include/linux/jbd2.h               |    3 +++
 5 files changed, 29 insertions(+)

Index: linux-2.6.27-rc9-ex4-1/Documentation/filesystems/ext4.txt
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/Documentation/filesystems/ext4.txt
+++ linux-2.6.27-rc9-ex4-1/Documentation/filesystems/ext4.txt
@@ -218,6 +218,11 @@ errors=remount-ro(*)	Remount the filesys
 errors=continue		Keep going on a filesystem error.
 errors=panic		Panic and halt the machine if an error occurs.
 
+data_err=ignore(*)	Just print an error message if an error occurs
+			in a file data buffer in ordered mode.
+data_err=abort		Abort the journal if an error occurs in a file
+			data buffer in ordered mode.
+
 grpid			Give objects the same group ID as their creator.
 bsdgroups
 
Index: linux-2.6.27-rc9-ex4-1/fs/ext4/ext4.h
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/ext4/ext4.h
+++ linux-2.6.27-rc9-ex4-1/fs/ext4/ext4.h
@@ -556,6 +556,9 @@ do {									       \
 #define EXT4_MOUNT_I_VERSION            0x2000000 /* i_version support */
 #define EXT4_MOUNT_DELALLOC		0x8000000 /* Delalloc support */
 #define EXT4_MOUNT_AKPM_LOCK_HACK	0x10000000 /* akpm lock hack */
+#define EXT4_MOUNT_DATA_ERR_ABORT	0x20000000 /* Abort on file data write
+						    * error in ordered mode */
+
 /* Compatibility, for having both ext2_fs.h and ext4_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
 #define clear_opt(o, opt)		o &= ~EXT4_MOUNT_##opt
Index: linux-2.6.27-rc9-ex4-1/fs/ext4/super.c
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/ext4/super.c
+++ linux-2.6.27-rc9-ex4-1/fs/ext4/super.c
@@ -779,6 +779,9 @@ static int ext4_show_options(struct seq_
 		seq_printf(seq, ",inode_readahead_blks=%u",
 			   sbi->s_inode_readahead_blks);
 
+	if (test_opt(sb, DATA_ERR_ABORT))
+		seq_puts(seq, ",data_err=abort");
+
 	ext4_show_quota_options(seq, sb);
 	return 0;
 }
@@ -908,6 +911,7 @@ enum {
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
 	Opt_journal_checksum, Opt_journal_async_commit,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
+	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
@@ -954,6 +958,8 @@ static match_table_t tokens = {
 	{Opt_data_journal, "data=journal"},
 	{Opt_data_ordered, "data=ordered"},
 	{Opt_data_writeback, "data=writeback"},
+	{Opt_data_err_abort, "data_err=abort"},
+	{Opt_data_err_ignore, "data_err=ignore"},
 	{Opt_offusrjquota, "usrjquota="},
 	{Opt_usrjquota, "usrjquota=%s"},
 	{Opt_offgrpjquota, "grpjquota="},
@@ -1189,6 +1195,12 @@ static int parse_options(char *options, 
 				sbi->s_mount_opt |= data_opt;
 			}
 			break;
+		case Opt_data_err_abort:
+			set_opt(sbi->s_mount_opt, DATA_ERR_ABORT);
+			break;
+		case Opt_data_err_ignore:
+			clear_opt(sbi->s_mount_opt, DATA_ERR_ABORT);
+			break;
 #ifdef CONFIG_QUOTA
 		case Opt_usrjquota:
 			qtype = USRQUOTA;
@@ -2544,6 +2556,10 @@ static void ext4_init_journal_params(str
 		journal->j_flags |= JBD2_LOCK_HACK;
 	else
 		journal->j_flags &= ~JBD2_LOCK_HACK;
+	if (test_opt(sb, DATA_ERR_ABORT))
+		journal->j_flags |= JBD2_ABORT_ON_SYNCDATA_ERR;
+	else
+		journal->j_flags &= ~JBD2_ABORT_ON_SYNCDATA_ERR;
 	spin_unlock(&journal->j_state_lock);
 }
 
Index: linux-2.6.27-rc9-ex4-1/fs/jbd2/commit.c
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/jbd2/commit.c
+++ linux-2.6.27-rc9-ex4-1/fs/jbd2/commit.c
@@ -683,6 +683,8 @@ start_journal_io:
 		printk(KERN_WARNING
 			"JBD2: Detected IO errors while flushing file data "
 		       "on %s\n", journal->j_devname);
+		if (journal->j_flags & JBD2_ABORT_ON_SYNCDATA_ERR)
+			jbd2_journal_abort(journal, err);
 		err = 0;
 	}
 
Index: linux-2.6.27-rc9-ex4-1/include/linux/jbd2.h
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/include/linux/jbd2.h
+++ linux-2.6.27-rc9-ex4-1/include/linux/jbd2.h
@@ -968,6 +968,9 @@ struct journal_s
 #define JBD2_LOADED	0x010	/* The journal superblock has been loaded */
 #define JBD2_BARRIER	0x020	/* Use IDE barriers */
 #define JBD2_LOCK_HACK	0x040	/* akpm's locking hack */
+#define JBD2_ABORT_ON_SYNCDATA_ERR	0x080	/* Abort the journal on file
+						 * data write error in ordered
+						 * mode */
 
 /*
  * Function declarations for the journaling transaction and buffer



