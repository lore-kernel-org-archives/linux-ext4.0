From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Fix handling of journalled quota options
Date: Mon, 16 Apr 2012 14:25:33 +0200
Message-ID: <1334579134-19885-4-git-send-email-jack@suse.cz>
References: <1334579134-19885-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab2DPMZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Apr 2012 08:25:39 -0400
In-Reply-To: <1334579134-19885-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 26092bf5 broke handling of journalled quota mount options by trying
to parse argument of every mount option as a number. Add a mount option flag
indicating whether an argument should be a number and use it where appropriate.
We also print appropriate error message when argument parsing fails (as
otherwise it's hard to find out why the mount failed).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   40 +++++++++++++++++++++++++---------------
 1 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 167aaac..f1acaa6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1357,7 +1357,8 @@ static int clear_qf_name(struct super_block *sb, int qtype)
 #define MOPT_NOSUPPORT	0x0004
 #define MOPT_EXPLICIT	0x0008
 #define MOPT_CLEAR_ERR	0x0010
-#define MOPT_GTE0	0x0020
+#define MOPT_NUM_ARG	0x0020	/* Option may have numeric argument */
+#define MOPT_GTE0	0x0040	/* Numeric argument must be >= 0 */
 #ifdef CONFIG_QUOTA
 #define MOPT_Q		0
 #define MOPT_QFMT	0x0040
@@ -1400,16 +1401,16 @@ static const struct mount_opts {
 	{Opt_noauto_da_alloc, EXT4_MOUNT_NO_AUTO_DA_ALLOC, MOPT_SET},
 	{Opt_auto_da_alloc, EXT4_MOUNT_NO_AUTO_DA_ALLOC, MOPT_CLEAR},
 	{Opt_noinit_itable, EXT4_MOUNT_INIT_INODE_TABLE, MOPT_CLEAR},
-	{Opt_commit, 0, MOPT_GTE0},
-	{Opt_max_batch_time, 0, MOPT_GTE0},
-	{Opt_min_batch_time, 0, MOPT_GTE0},
-	{Opt_inode_readahead_blks, 0, MOPT_GTE0},
-	{Opt_init_itable, 0, MOPT_GTE0},
-	{Opt_stripe, 0, MOPT_GTE0},
-	{Opt_resuid, 0, MOPT_GTE0},
-	{Opt_resgid, 0, MOPT_GTE0},
-	{Opt_journal_dev, 0, MOPT_GTE0},
-	{Opt_journal_ioprio, 0, MOPT_GTE0},
+	{Opt_commit, 0, MOPT_NUM_ARG | MOPT_GTE0},
+	{Opt_max_batch_time, 0, MOPT_NUM_ARG | MOPT_GTE0},
+	{Opt_min_batch_time, 0, MOPT_NUM_ARG | MOPT_GTE0},
+	{Opt_inode_readahead_blks, 0, MOPT_NUM_ARG | MOPT_GTE0},
+	{Opt_init_itable, 0, MOPT_NUM_ARG | MOPT_GTE0},
+	{Opt_stripe, 0, MOPT_NUM_ARG | MOPT_GTE0},
+	{Opt_resuid, 0, MOPT_NUM_ARG | MOPT_GTE0},
+	{Opt_resgid, 0, MOPT_NUM_ARG | MOPT_GTE0},
+	{Opt_journal_dev, 0, MOPT_NUM_ARG | MOPT_GTE0},
+	{Opt_journal_ioprio, 0, MOPT_NUM_ARG | MOPT_GTE0},
 	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_DATAJ},
 	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_DATAJ},
 	{Opt_data_writeback, EXT4_MOUNT_WRITEBACK_DATA, MOPT_DATAJ},
@@ -1481,10 +1482,19 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		return -1;
 	}
 	
-	if (args->from && match_int(args, &arg))
-		return -1;
-	if (args->from && (m->flags & MOPT_GTE0) && (arg < 0))
-		return -1;
+	if (args->from && (m->flags & MOPT_NUM_ARG)) {
+		if (match_int(args, &arg)) {
+			ext4_msg(sb, KERN_ERR, "Cannot parse argument for mount"
+				 "option \"%s\"", opt);
+			return -1;
+		}
+		if ((m->flags & MOPT_GTE0) && (arg < 0)) {
+			ext4_msg(sb, KERN_ERR, "Argument for mount option "
+				 "\"%s\" must be >= 0", opt);
+			return -1;
+		}
+	}
+	
 	if (m->flags & MOPT_EXPLICIT)
 		set_opt2(sb, EXPLICIT_DELALLOC);
 	if (m->flags & MOPT_CLEAR_ERR)
-- 
1.7.1

