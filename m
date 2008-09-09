From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 1/2][RESEND] ext3: add an option to control error handling on
    file data
Date: Tue, 09 Sep 2008 17:49:18 +0900
Message-ID: <48C6388E.4010402@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
	snitzer@gmail.com, yumiko.sugita.yf@hitachi.com,
	satoshi.oshima.fk@hitachi.com
To: akpm@linux-foundation.org, sct@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47532 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbYIIIt3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 04:49:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew,

I posted these patches previously and revised to follow comments,
but they haven't been merged yet.  So I resend them.

The previous post:
http://kerneltrap.org/mailarchive/linux-kernel/2008/7/30/2742434

Thanks,

Subject: [PATCH 1/2] ext3: add an option to control error handling on file data

If the journal doesn't abort when it gets an IO error in file data
blocks, the file data corruption will spread silently.  Because
most of applications and commands do buffered writes without fsync(),
they don't notice the IO error.  It's scary for mission critical
systems.  On the other hand, if the journal aborts whenever it gets
an IO error in file data blocks, the system will easily become
inoperable.  So this patch introduces a filesystem option to
determine whether it aborts the journal or just call printk() when
it gets an IO error in file data.

If you mount a ext3 fs with data_err=abort option, it aborts on file
data write error.  If you mount it with data_err=ignore, it doesn't
abort, just call printk().  data_err=ignore is the default.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 Documentation/filesystems/ext3.txt |    5 +++++
 fs/ext3/super.c                    |   16 ++++++++++++++++
 fs/jbd/commit.c                    |    2 ++
 include/linux/ext3_fs.h            |    2 ++
 include/linux/jbd.h                |    3 +++
 5 files changed, 28 insertions(+)

Index: linux-2.6.27-rc5/Documentation/filesystems/ext3.txt
===================================================================
--- linux-2.6.27-rc5.orig/Documentation/filesystems/ext3.txt
+++ linux-2.6.27-rc5/Documentation/filesystems/ext3.txt
@@ -96,6 +96,11 @@ errors=remount-ro(*)	Remount the filesys
 errors=continue		Keep going on a filesystem error.
 errors=panic		Panic and halt the machine if an error occurs.
 
+data_err=ignore(*)	Just print an error message if an error occurs
+			in a file data buffer in ordered mode.
+data_err=abort		Abort the journal if an error occurs in a file
+			data buffer in ordered mode.
+
 grpid			Give objects the same group ID as their creator.
 bsdgroups
 
Index: linux-2.6.27-rc5/fs/ext3/super.c
===================================================================
--- linux-2.6.27-rc5.orig/fs/ext3/super.c
+++ linux-2.6.27-rc5/fs/ext3/super.c
@@ -625,6 +625,9 @@ static int ext3_show_options(struct seq_
 	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)
 		seq_puts(seq, ",data=writeback");
 
+	if (test_opt(sb, DATA_ERR_ABORT))
+		seq_puts(seq, ",data_err=abort");
+
 	ext3_show_quota_options(seq, sb);
 
 	return 0;
@@ -754,6 +757,7 @@ enum {
 	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
+	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
@@ -796,6 +800,8 @@ static match_table_t tokens = {
 	{Opt_data_journal, "data=journal"},
 	{Opt_data_ordered, "data=ordered"},
 	{Opt_data_writeback, "data=writeback"},
+	{Opt_data_err_abort, "data_err=abort"},
+	{Opt_data_err_ignore, "data_err=ignore"},
 	{Opt_offusrjquota, "usrjquota="},
 	{Opt_usrjquota, "usrjquota=%s"},
 	{Opt_offgrpjquota, "grpjquota="},
@@ -1011,6 +1017,12 @@ static int parse_options (char *options,
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
@@ -1986,6 +1998,10 @@ static void ext3_init_journal_params(str
 		journal->j_flags |= JFS_BARRIER;
 	else
 		journal->j_flags &= ~JFS_BARRIER;
+	if (test_opt(sb, DATA_ERR_ABORT))
+		journal->j_flags |= JFS_ABORT_ON_SYNCDATA_ERR;
+	else
+		journal->j_flags &= ~JFS_ABORT_ON_SYNCDATA_ERR;
 	spin_unlock(&journal->j_state_lock);
 }
 
Index: linux-2.6.27-rc5/include/linux/ext3_fs.h
===================================================================
--- linux-2.6.27-rc5.orig/include/linux/ext3_fs.h
+++ linux-2.6.27-rc5/include/linux/ext3_fs.h
@@ -380,6 +380,8 @@ struct ext3_inode {
 #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT3_MOUNT_DATA_ERR_ABORT	0x400000 /* Abort on file data write
+						  * error in ordered mode */
 
 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
Index: linux-2.6.27-rc5/include/linux/jbd.h
===================================================================
--- linux-2.6.27-rc5.orig/include/linux/jbd.h
+++ linux-2.6.27-rc5/include/linux/jbd.h
@@ -816,6 +816,9 @@ struct journal_s
 #define JFS_FLUSHED	0x008	/* The journal superblock has been flushed */
 #define JFS_LOADED	0x010	/* The journal superblock has been loaded */
 #define JFS_BARRIER	0x020	/* Use IDE barriers */
+#define JFS_ABORT_ON_SYNCDATA_ERR	0x040  /* Abort the journal on file
+						* data write error in ordered
+						* mode */
 
 /*
  * Function declarations for the journaling transaction and buffer
Index: linux-2.6.27-rc5/fs/jbd/commit.c
===================================================================
--- linux-2.6.27-rc5.orig/fs/jbd/commit.c
+++ linux-2.6.27-rc5/fs/jbd/commit.c
@@ -482,6 +482,8 @@ void journal_commit_transaction(journal_
 		printk(KERN_WARNING
 			"JBD: Detected IO errors while flushing file data "
 			"on %s\n", bdevname(journal->j_fs_dev, b));
+		if (journal->j_flags & JFS_ABORT_ON_SYNCDATA_ERR)
+			journal_abort(journal, err);
 		err = 0;
 	}
 



