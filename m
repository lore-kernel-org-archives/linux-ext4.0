From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] ext4: Make mount option parsing loop more logical
Date: Mon, 16 Apr 2012 14:25:32 +0200
Message-ID: <1334579134-19885-3-git-send-email-jack@suse.cz>
References: <1334579134-19885-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48691 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab2DPMZk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Apr 2012 08:25:40 -0400
In-Reply-To: <1334579134-19885-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The loop looking for correct mount option entry is more logical if it is
written rewritten as an empty loop looking for correct option entry and then
code handling the option. It also saves one level of indentation for a lot of
code so we can join a couple of split lines.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |  224 +++++++++++++++++++++++++++----------------------------
 1 files changed, 111 insertions(+), 113 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 30e26f1..167aaac 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1473,130 +1473,128 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		return 1;
 	}
 
-	for (m = ext4_mount_opts; m->token != Opt_err; m++) {
-		if (token != m->token)
-			continue;
-		if (args->from && match_int(args, &arg))
+	for (m = ext4_mount_opts; m->token != Opt_err && token != m->token;
+	     m++);
+	if (m->token == Opt_err) {
+		ext4_msg(sb, KERN_ERR, "Unrecognized mount option \"%s\" "
+			 "or missing value", opt);
+		return -1;
+	}
+	
+	if (args->from && match_int(args, &arg))
+		return -1;
+	if (args->from && (m->flags & MOPT_GTE0) && (arg < 0))
+		return -1;
+	if (m->flags & MOPT_EXPLICIT)
+		set_opt2(sb, EXPLICIT_DELALLOC);
+	if (m->flags & MOPT_CLEAR_ERR)
+		clear_opt(sb, ERRORS_MASK);
+	if (token == Opt_noquota && sb_any_quota_loaded(sb)) {
+		ext4_msg(sb, KERN_ERR, "Cannot change quota "
+			 "options when quota turned on");
+		return -1;
+	}
+
+	if (m->flags & MOPT_NOSUPPORT) {
+		ext4_msg(sb, KERN_ERR, "%s option not supported", opt);
+	} else if (token == Opt_commit) {
+		if (arg == 0)
+			arg = JBD2_DEFAULT_MAX_COMMIT_AGE;
+		sbi->s_commit_interval = HZ * arg;
+	} else if (token == Opt_max_batch_time) {
+		if (arg == 0)
+			arg = EXT4_DEF_MAX_BATCH_TIME;
+		sbi->s_max_batch_time = arg;
+	} else if (token == Opt_min_batch_time) {
+		sbi->s_min_batch_time = arg;
+	} else if (token == Opt_inode_readahead_blks) {
+		if (arg > (1 << 30))
 			return -1;
-		if (args->from && (m->flags & MOPT_GTE0) && (arg < 0))
+		if (arg && !is_power_of_2(arg)) {
+			ext4_msg(sb, KERN_ERR,
+				 "EXT4-fs: inode_readahead_blks"
+				 " must be a power of 2");
 			return -1;
-		if (m->flags & MOPT_EXPLICIT)
-			set_opt2(sb, EXPLICIT_DELALLOC);
-		if (m->flags & MOPT_CLEAR_ERR)
-			clear_opt(sb, ERRORS_MASK);
-		if (token == Opt_noquota && sb_any_quota_loaded(sb)) {
-			ext4_msg(sb, KERN_ERR, "Cannot change quota "
-				 "options when quota turned on");
+		}
+		sbi->s_inode_readahead_blks = arg;
+	} else if (token == Opt_init_itable) {
+		set_opt(sb, INIT_INODE_TABLE);
+		if (!args->from)
+			arg = EXT4_DEF_LI_WAIT_MULT;
+		sbi->s_li_wait_mult = arg;
+	} else if (token == Opt_stripe) {
+		sbi->s_stripe = arg;
+	} else if (token == Opt_resuid) {
+		sbi->s_resuid = arg;
+	} else if (token == Opt_resgid) {
+		sbi->s_resgid = arg;
+	} else if (token == Opt_journal_dev) {
+		if (is_remount) {
+			ext4_msg(sb, KERN_ERR,
+				 "Cannot specify journal on remount");
 			return -1;
 		}
-
-		if (m->flags & MOPT_NOSUPPORT) {
-			ext4_msg(sb, KERN_ERR, "%s option not supported", opt);
-		} else if (token == Opt_commit) {
-			if (arg == 0)
-				arg = JBD2_DEFAULT_MAX_COMMIT_AGE;
-			sbi->s_commit_interval = HZ * arg;
-		} else if (token == Opt_max_batch_time) {
-			if (arg == 0)
-				arg = EXT4_DEF_MAX_BATCH_TIME;
-			sbi->s_max_batch_time = arg;
-		} else if (token == Opt_min_batch_time) {
-			sbi->s_min_batch_time = arg;
-		} else if (token == Opt_inode_readahead_blks) {
-			if (arg > (1 << 30))
-				return -1;
-			if (arg && !is_power_of_2(arg)) {
-				ext4_msg(sb, KERN_ERR,
-					 "EXT4-fs: inode_readahead_blks"
-					 " must be a power of 2");
-				return -1;
-			}
-			sbi->s_inode_readahead_blks = arg;
-		} else if (token == Opt_init_itable) {
-			set_opt(sb, INIT_INODE_TABLE);
-			if (!args->from)
-				arg = EXT4_DEF_LI_WAIT_MULT;
-			sbi->s_li_wait_mult = arg;
-		} else if (token == Opt_stripe) {
-			sbi->s_stripe = arg;
-		} else if (token == Opt_resuid) {
-			sbi->s_resuid = arg;
-		} else if (token == Opt_resgid) {
-			sbi->s_resgid = arg;
-		} else if (token == Opt_journal_dev) {
-			if (is_remount) {
-				ext4_msg(sb, KERN_ERR,
-					 "Cannot specify journal on remount");
-				return -1;
-			}
-			*journal_devnum = arg;
-		} else if (token == Opt_journal_ioprio) {
-			if (arg > 7) {
+		*journal_devnum = arg;
+	} else if (token == Opt_journal_ioprio) {
+		if (arg > 7) {
+			ext4_msg(sb, KERN_ERR,
+				 "Invalid journal IO priority (must be 0-7)");
+			return -1;
+		}
+		*journal_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
+	} else if (m->flags & MOPT_DATAJ) {
+		if (is_remount) {
+			if (!sbi->s_journal)
+				ext4_msg(sb, KERN_WARNING, "Remounting file system with no journal so ignoring journalled data option");
+			else if (test_opt(sb, DATA_FLAGS) != m->mount_opt) {
 				ext4_msg(sb, KERN_ERR,
-					 "Invalid journal IO priority"
-					 " (must be 0-7)");
+				 "Cannot change data mode on remount");
 				return -1;
 			}
-			*journal_ioprio =
-				IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, arg);
-		} else if (m->flags & MOPT_DATAJ) {
-			if (is_remount) {
-				if (!sbi->s_journal)
-					ext4_msg(sb, KERN_WARNING, "Remounting file system with no journal so ignoring journalled data option");
-				else if (test_opt(sb, DATA_FLAGS) !=
-					 m->mount_opt) {
-					ext4_msg(sb, KERN_ERR,
-					 "Cannot change data mode on remount");
-					return -1;
-				}
-			} else {
-				clear_opt(sb, DATA_FLAGS);
-				sbi->s_mount_opt |= m->mount_opt;
-			}
+		} else {
+			clear_opt(sb, DATA_FLAGS);
+			sbi->s_mount_opt |= m->mount_opt;
+		}
 #ifdef CONFIG_QUOTA
-		} else if (token == Opt_usrjquota) {
-			if (!set_qf_name(sb, USRQUOTA, &args[0]))
-				return -1;
-		} else if (token == Opt_grpjquota) {
-			if (!set_qf_name(sb, GRPQUOTA, &args[0]))
-				return -1;
-		} else if (token == Opt_offusrjquota) {
-			if (!clear_qf_name(sb, USRQUOTA))
-				return -1;
-		} else if (token == Opt_offgrpjquota) {
-			if (!clear_qf_name(sb, GRPQUOTA))
-				return -1;
-		} else if (m->flags & MOPT_QFMT) {
-			if (sb_any_quota_loaded(sb) &&
-			    sbi->s_jquota_fmt != m->mount_opt) {
-				ext4_msg(sb, KERN_ERR, "Cannot "
-					 "change journaled quota options "
-					 "when quota turned on");
-				return -1;
-			}
-			sbi->s_jquota_fmt = m->mount_opt;
+	} else if (token == Opt_usrjquota) {
+		if (!set_qf_name(sb, USRQUOTA, &args[0]))
+			return -1;
+	} else if (token == Opt_grpjquota) {
+		if (!set_qf_name(sb, GRPQUOTA, &args[0]))
+			return -1;
+	} else if (token == Opt_offusrjquota) {
+		if (!clear_qf_name(sb, USRQUOTA))
+			return -1;
+	} else if (token == Opt_offgrpjquota) {
+		if (!clear_qf_name(sb, GRPQUOTA))
+			return -1;
+	} else if (m->flags & MOPT_QFMT) {
+		if (sb_any_quota_loaded(sb) &&
+		    sbi->s_jquota_fmt != m->mount_opt) {
+			ext4_msg(sb, KERN_ERR, "Cannot "
+				 "change journaled quota options "
+				 "when quota turned on");
+			return -1;
+		}
+		sbi->s_jquota_fmt = m->mount_opt;
 #endif
-		} else {
-			if (!args->from)
-				arg = 1;
-			if (m->flags & MOPT_CLEAR)
-				arg = !arg;
-			else if (unlikely(!(m->flags & MOPT_SET))) {
-				ext4_msg(sb, KERN_WARNING,
-					 "buggy handling of option %s", opt);
-				WARN_ON(1);
-				return -1;
-			}
-			if (arg != 0)
-				sbi->s_mount_opt |= m->mount_opt;
-			else
-				sbi->s_mount_opt &= ~m->mount_opt;
+	} else {
+		if (!args->from)
+			arg = 1;
+		if (m->flags & MOPT_CLEAR)
+			arg = !arg;
+		else if (unlikely(!(m->flags & MOPT_SET))) {
+			ext4_msg(sb, KERN_WARNING,
+				 "buggy handling of option %s", opt);
+			WARN_ON(1);
+			return -1;
 		}
-		return 1;
+		if (arg != 0)
+			sbi->s_mount_opt |= m->mount_opt;
+		else
+			sbi->s_mount_opt &= ~m->mount_opt;
 	}
-	ext4_msg(sb, KERN_ERR, "Unrecognized mount option \"%s\" "
-		 "or missing value", opt);
-	return -1;
+	return 1;
 }
 
 static int parse_options(char *options, struct super_block *sb,
-- 
1.7.1

