From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/4] ext4: Move several mount options to standard handling loop
Date: Mon, 16 Apr 2012 14:25:31 +0200
Message-ID: <1334579134-19885-2-git-send-email-jack@suse.cz>
References: <1334579134-19885-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab2DPMZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Apr 2012 08:25:39 -0400
In-Reply-To: <1334579134-19885-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Several mount option (resuid, resgid, journal_dev, journal_ioprio) are
currently handled before we enter standard option handling loop. I don't
see a reason for this so move them to normal handling loop to make things
more regular.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   47 ++++++++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ceebaf8..30e26f1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1406,6 +1406,10 @@ static const struct mount_opts {
 	{Opt_inode_readahead_blks, 0, MOPT_GTE0},
 	{Opt_init_itable, 0, MOPT_GTE0},
 	{Opt_stripe, 0, MOPT_GTE0},
+	{Opt_resuid, 0, MOPT_GTE0},
+	{Opt_resgid, 0, MOPT_GTE0},
+	{Opt_journal_dev, 0, MOPT_GTE0},
+	{Opt_journal_ioprio, 0, MOPT_GTE0},
 	{Opt_data_journal, EXT4_MOUNT_JOURNAL_DATA, MOPT_DATAJ},
 	{Opt_data_ordered, EXT4_MOUNT_ORDERED_DATA, MOPT_DATAJ},
 	{Opt_data_writeback, EXT4_MOUNT_WRITEBACK_DATA, MOPT_DATAJ},
@@ -1450,8 +1454,6 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	const struct mount_opts *m;
 	int arg = 0;
 
-	if (args->from && match_int(args, &arg))
-		return -1;
 	switch (token) {
 	case Opt_noacl:
 	case Opt_nouser_xattr:
@@ -1463,36 +1465,19 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		ext4_msg(sb, KERN_WARNING,
 			 "Ignoring removed %s option", opt);
 		return 1;
-	case Opt_resuid:
-		sbi->s_resuid = arg;
-		return 1;
-	case Opt_resgid:
-		sbi->s_resgid = arg;
-		return 1;
 	case Opt_abort:
 		sbi->s_mount_flags |= EXT4_MF_FS_ABORTED;
 		return 1;
 	case Opt_i_version:
 		sb->s_flags |= MS_I_VERSION;
 		return 1;
-	case Opt_journal_dev:
-		if (is_remount) {
-			ext4_msg(sb, KERN_ERR,
-				 "Cannot specify journal on remount");
-			return -1;
-		}
-		*journal_devnum = arg;
-		return 1;
-	case Opt_journal_ioprio:
-		if (arg < 0 || arg > 7)
-			return -1;
-		*journal_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
-		return 1;
 	}
 
 	for (m = ext4_mount_opts; m->token != Opt_err; m++) {
 		if (token != m->token)
 			continue;
+		if (args->from && match_int(args, &arg))
+			return -1;
 		if (args->from && (m->flags & MOPT_GTE0) && (arg < 0))
 			return -1;
 		if (m->flags & MOPT_EXPLICIT)
@@ -1534,6 +1519,26 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			sbi->s_li_wait_mult = arg;
 		} else if (token == Opt_stripe) {
 			sbi->s_stripe = arg;
+		} else if (token == Opt_resuid) {
+			sbi->s_resuid = arg;
+		} else if (token == Opt_resgid) {
+			sbi->s_resgid = arg;
+		} else if (token == Opt_journal_dev) {
+			if (is_remount) {
+				ext4_msg(sb, KERN_ERR,
+					 "Cannot specify journal on remount");
+				return -1;
+			}
+			*journal_devnum = arg;
+		} else if (token == Opt_journal_ioprio) {
+			if (arg > 7) {
+				ext4_msg(sb, KERN_ERR,
+					 "Invalid journal IO priority"
+					 " (must be 0-7)");
+				return -1;
+			}
+			*journal_ioprio =
+				IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
 		} else if (m->flags & MOPT_DATAJ) {
 			if (is_remount) {
 				if (!sbi->s_journal)
-- 
1.7.1

