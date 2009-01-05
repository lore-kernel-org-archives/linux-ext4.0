From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Add mount option to set kjournald's I/O priority
Date: Mon,  5 Jan 2009 00:32:29 -0500
Message-ID: <1231133549-4037-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44160 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbZAEFcb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 00:32:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 Documentation/filesystems/ext4.txt |    7 +++++++
 fs/ext4/super.c                    |   29 +++++++++++++++++++++++++----
 fs/ioprio.c                        |    3 ++-
 include/linux/ioprio.h             |    2 ++
 4 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 3024f74..eb7b4ae 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -295,6 +295,13 @@ min_batch_time=usec	This parameter sets the commit time (as
 			multi-threaded, synchronous workloads on very
 			fast disks, at the cost of increasing latency.
 
+journal_ioprio=prio	The I/O priority (from 0 to 7, where 0 is the
+			highest priorty) which should be used for I/O
+			operations submitted by kjournald2 during a
+			commit operation.  This defaults to 3, which is
+			a slightly higher priority than the default I/O
+			priority.
+
 Data Mode
 =========
 There are 3 different data modes:
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d64d1c9..2650053 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1013,7 +1013,7 @@ enum {
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
 	Opt_grpquota, Opt_extents, Opt_noextents, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc,
-	Opt_inode_readahead_blks
+	Opt_inode_readahead_blks, Opt_journal_ioprio
 };
 
 static const match_table_t tokens = {
@@ -1074,6 +1074,7 @@ static const match_table_t tokens = {
 	{Opt_delalloc, "delalloc"},
 	{Opt_nodelalloc, "nodelalloc"},
 	{Opt_inode_readahead_blks, "inode_readahead_blks=%u"},
+	{Opt_journal_ioprio, "journal_ioprio=%u"},
 	{Opt_err, NULL},
 };
 
@@ -1098,8 +1099,11 @@ static ext4_fsblk_t get_sb_block(void **data)
 	return sb_block;
 }
 
+#define DEFAULT_JOURNAL_IOPRIO (IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 3))
+
 static int parse_options(char *options, struct super_block *sb,
 			 unsigned long *journal_devnum,
+			 unsigned int *journal_ioprio,
 			 ext4_fsblk_t *n_blocks_count, int is_remount)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1492,6 +1496,14 @@ set_qf_format:
 				return 0;
 			sbi->s_inode_readahead_blks = option;
 			break;
+		case Opt_journal_ioprio:
+			if (match_int(&args[0], &option))
+				return 0;
+			if (option < 0 || option > 7)
+				break;
+			*journal_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
+							    option);
+			break;
 		default:
 			printk(KERN_ERR
 			       "EXT4-fs: Unrecognized mount option \"%s\" "
@@ -1523,6 +1535,7 @@ set_qf_format:
 					"not specified.\n");
 			return 0;
 		}
+		set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 	} else {
 		if (sbi->s_jquota_fmt) {
 			printk(KERN_ERR "EXT4-fs: journaled quota format "
@@ -2035,6 +2048,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int features;
 	__u64 blocks_count;
 	int err;
+	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -2141,7 +2155,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	set_opt(sbi->s_mount_opt, DELALLOC);
 
 
-	if (!parse_options((char *) data, sb, &journal_devnum, NULL, 0))
+	if (!parse_options((char *) data, sb, &journal_devnum,
+			   &journal_ioprio, NULL, 0))
 		goto failed_mount;
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
@@ -3123,6 +3138,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	unsigned long old_sb_flags;
 	struct ext4_mount_options old_opts;
 	ext4_group_t g;
+	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	int err;
 #ifdef CONFIG_QUOTA
 	int i;
@@ -3141,11 +3157,14 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	for (i = 0; i < MAXQUOTAS; i++)
 		old_opts.s_qf_names[i] = sbi->s_qf_names[i];
 #endif
+	if (sbi->s_journal && sbi->s_journal->j_task->io_context)
+		journal_ioprio = sbi->s_journal->j_task->io_context->ioprio;
 
 	/*
 	 * Allow the "check" option to be passed as a remount option.
 	 */
-	if (!parse_options(data, sb, NULL, &n_blocks_count, 1)) {
+	if (!parse_options(data, sb, NULL, &journal_ioprio,
+			   &n_blocks_count, 1)) {
 		err = -EINVAL;
 		goto restore_opts;
 	}
@@ -3158,8 +3177,10 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 
 	es = sbi->s_es;
 
-	if (sbi->s_journal)
+	if (sbi->s_journal) {
 		ext4_init_journal_params(sb, sbi->s_journal);
+		set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
+	}
 
 	if ((*flags & MS_RDONLY) != (sb->s_flags & MS_RDONLY) ||
 		n_blocks_count > ext4_blocks_count(es)) {
diff --git a/fs/ioprio.c b/fs/ioprio.c
index da3cc46..3bd95dc 100644
--- a/fs/ioprio.c
+++ b/fs/ioprio.c
@@ -27,7 +27,7 @@
 #include <linux/security.h>
 #include <linux/pid_namespace.h>
 
-static int set_task_ioprio(struct task_struct *task, int ioprio)
+int set_task_ioprio(struct task_struct *task, int ioprio)
 {
 	int err;
 	struct io_context *ioc;
@@ -64,6 +64,7 @@ static int set_task_ioprio(struct task_struct *task, int ioprio)
 	task_unlock(task);
 	return err;
 }
+EXPORT_SYMBOL_GPL(set_task_ioprio);
 
 asmlinkage long sys_ioprio_set(int which, int who, int ioprio)
 {
diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index f98a656..76dad48 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -86,4 +86,6 @@ static inline int task_nice_ioclass(struct task_struct *task)
  */
 extern int ioprio_best(unsigned short aprio, unsigned short bprio);
 
+extern int set_task_ioprio(struct task_struct *task, int ioprio);
+
 #endif
-- 
1.6.0.4.8.g36f27.dirty

