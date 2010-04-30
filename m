From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext3: make barrier options consistent with ext4
Date: Fri, 30 Apr 2010 11:09:34 -0500
Message-ID: <4BDB00BE.7040600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933032Ab0D3RVU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 was updated to accept barrier/nobarrier mount options
in addition to the older barrier=0/1.  The barrier story
is complex enough, we should help people by making the options
the same at least, even if the defaults are different.

This patch allows the barrier/nobarrier mount options for ext3,
while keeping nobarrier the default.

It also unconditionally displays barrier status in show_options,
and prints a message at mount time if barriers are not enabled,
just as ext4 does.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 867c5b5..272f80d 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -59,8 +59,19 @@ commit=nrsec	(*)	Ext3 can be told to sync all its data and metadata
 			Setting it to very large values will improve
 			performance.
 
-barrier=1		This enables/disables barriers.  barrier=0 disables
-			it, barrier=1 enables it.
+barrier=<0(*)|1>	This enables/disables the use of write barriers in
+barrier			the jbd code.  barrier=0 disables, barrier=1 enables.
+nobarrier	(*)	This also requires an IO stack which can support
+			barriers, and if jbd gets an error on a barrier
+			write, it will disable again with a warning.
+			Write barriers enforce proper on-disk ordering
+			of journal commits, making volatile disk write caches
+			safe to use, at some performance penalty.  If
+			your disks are battery-backed in one way or another,
+			disabling barriers may safely improve performance.
+			The mount options "barrier" and "nobarrier" can
+			also be used to enable or disable barriers, for
+			consistency with other ext3 mount options.
 
 orlov		(*)	This enables the new Orlov block allocator. It is
 			enabled by default.
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 1bee604..5e7463d 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -653,8 +653,12 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_printf(seq, ",commit=%u",
 			   (unsigned) (sbi->s_commit_interval / HZ));
 	}
-	if (test_opt(sb, BARRIER))
-		seq_puts(seq, ",barrier=1");
+
+	/*
+	 * Always display barrier state so it's clear what the status is.
+	 */
+	seq_puts(seq, ",barrier=");
+	seq_puts(seq, test_opt(sb, BARRIER) ? "1" : "0");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
 
@@ -810,8 +814,8 @@ enum {
 	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
-	Opt_noquota, Opt_ignore, Opt_barrier, Opt_err, Opt_resize,
-	Opt_usrquota, Opt_grpquota
+	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
+	Opt_resize, Opt_usrquota, Opt_grpquota
 };
 
 static const match_table_t tokens = {
@@ -865,6 +869,8 @@ static const match_table_t tokens = {
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
+	{Opt_barrier, "barrier"},
+	{Opt_nobarrier, "nobarrier"},
 	{Opt_resize, "resize"},
 	{Opt_err, NULL},
 };
@@ -967,7 +973,11 @@ static int parse_options (char *options, struct super_block *sb,
 		int token;
 		if (!*p)
 			continue;
-
+		/*
+		 * Initialize args struct so we know whether arg was
+		 * found; some options take optional arguments.
+		 */
+		args[0].to = args[0].from = 0;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
@@ -1215,9 +1225,15 @@ set_qf_format:
 		case Opt_abort:
 			set_opt(sbi->s_mount_opt, ABORT);
 			break;
+		case Opt_nobarrier:
+			clear_opt(sbi->s_mount_opt, BARRIER);
+			break;
 		case Opt_barrier:
-			if (match_int(&args[0], &option))
-				return 0;
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				option = 1;	/* No argument, default to 1 */
 			if (option)
 				set_opt(sbi->s_mount_opt, BARRIER);
 			else
@@ -2278,6 +2294,9 @@ static int ext3_load_journal(struct super_block *sb,
 			return -EINVAL;
 	}
 
+	if (!(journal->j_flags & JFS_BARRIER))
+		printk(KERN_INFO "EXT3-fs: barriers not enabled\n");
+
 	if (!really_read_only && test_opt(sb, UPDATE_JOURNAL)) {
 		err = journal_update_format(journal);
 		if (err)  {

