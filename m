From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] ext4: move several mount options to standard handling loop
Date: Sat,  2 Feb 2013 23:44:03 -0500
Message-ID: <1359866646-29876-2-git-send-email-tytso@mit.edu>
References: <1359866646-29876-1-git-send-email-tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46686 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab3BCEoK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Feb 2013 23:44:10 -0500
In-Reply-To: <1359866646-29876-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Several mount option (resuid, resgid, journal_dev, journal_ioprio) are
currently handled before we enter standard option handling loop. I don't
see a reason for this so move them to normal handling loop to make things
more regular.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c | 69 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dc20e4d..78c9336 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1447,6 +1447,10 @@ static const struct mount_opts {
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
@@ -1499,8 +1503,6 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 	else if (token == Opt_offgrpjquota)
 		return clear_qf_name(sb, GRPQUOTA);
 #endif
-	if (args->from && match_int(args, &arg))
-		return -1;
 	switch (token) {
 	case Opt_noacl:
 	case Opt_nouser_xattr:
@@ -1512,46 +1514,19 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		ext4_msg(sb, KERN_WARNING,
 			 "Ignoring removed %s option", opt);
 		return 1;
-	case Opt_resuid:
-		uid = make_kuid(current_user_ns(), arg);
-		if (!uid_valid(uid)) {
-			ext4_msg(sb, KERN_ERR, "Invalid uid value %d", arg);
-			return -1;
-		}
-		sbi->s_resuid = uid;
-		return 1;
-	case Opt_resgid:
-		gid = make_kgid(current_user_ns(), arg);
-		if (!gid_valid(gid)) {
-			ext4_msg(sb, KERN_ERR, "Invalid gid value %d", arg);
-			return -1;
-		}
-		sbi->s_resgid = gid;
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
@@ -1595,6 +1570,38 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			sbi->s_max_dir_size_kb = arg;
 		} else if (token == Opt_stripe) {
 			sbi->s_stripe = arg;
+		} else if (token == Opt_resuid) {
+			uid = make_kuid(current_user_ns(), arg);
+			if (!uid_valid(uid)) {
+				ext4_msg(sb, KERN_ERR,
+					 "Invalid uid value %d", arg);
+				return -1;
+			}
+			sbi->s_resuid = uid;
+		} else if (token == Opt_resgid) {
+			gid = make_kgid(current_user_ns(), arg);
+			if (!gid_valid(gid)) {
+				ext4_msg(sb, KERN_ERR,
+					 "Invalid gid value %d", arg);
+				return -1;
+			}
+			sbi->s_resgid = gid;
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
1.7.12.rc0.22.gcdd159b

