From: Ales Novak <alnovak@suse.cz>
Subject: [PATCH] fix: print ext4 mountopt data_err=abort correctly
Date: Wed,  9 Mar 2016 19:30:40 +0100
Message-ID: <1457548240-30948-2-git-send-email-alnovak@suse.cz>
References: <1457528979-25737-1-git-send-email-alnovak@suse.cz>
 <1457548240-30948-1-git-send-email-alnovak@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ales Novak <alnovak@suse.cz>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933836AbcCISbD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Mar 2016 13:31:03 -0500
In-Reply-To: <1457548240-30948-1-git-send-email-alnovak@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If data_err=abort option is specified for an ext3/ext4 mount,
/proc/mounts does show it as "(null)". This is caused by token2str()
returning NULL for Opt_data_err_abort (due to its pattern containing
'=').

This is perhaps more logical solution than the previously submitted,
handling these 'data_err=' options in other way than MOPT_SET.

Signed-off-by: Ales Novak <alnovak@suse.cz>
---
 fs/ext4/super.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ed01ec..19e589c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1425,9 +1425,9 @@ static const struct mount_opts {
 	{Opt_err_ro, EXT4_MOUNT_ERRORS_RO, MOPT_SET | MOPT_CLEAR_ERR},
 	{Opt_err_cont, EXT4_MOUNT_ERRORS_CONT, MOPT_SET | MOPT_CLEAR_ERR},
 	{Opt_data_err_abort, EXT4_MOUNT_DATA_ERR_ABORT,
-	 MOPT_NO_EXT2 | MOPT_SET},
+	 MOPT_NO_EXT2},
 	{Opt_data_err_ignore, EXT4_MOUNT_DATA_ERR_ABORT,
-	 MOPT_NO_EXT2 | MOPT_CLEAR},
+	 MOPT_NO_EXT2},
 	{Opt_barrier, EXT4_MOUNT_BARRIER, MOPT_SET},
 	{Opt_nobarrier, EXT4_MOUNT_BARRIER, MOPT_CLEAR},
 	{Opt_noauto_da_alloc, EXT4_MOUNT_NO_AUTO_DA_ALLOC, MOPT_SET},
@@ -1705,6 +1705,10 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		ext4_msg(sb, KERN_INFO, "dax option not supported");
 		return -1;
 #endif
+	} else if (token == Opt_data_err_abort) {
+		sbi->s_mount_opt |= m->mount_opt;
+	} else if (token == Opt_data_err_ignore) {
+		sbi->s_mount_opt &= ~m->mount_opt;
 	} else {
 		if (!args->from)
 			arg = 1;
@@ -1914,6 +1918,8 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 		SEQ_OPTS_PRINT("init_itable=%u", sbi->s_li_wait_mult);
 	if (nodefs || sbi->s_max_dir_size_kb)
 		SEQ_OPTS_PRINT("max_dir_size_kb=%u", sbi->s_max_dir_size_kb);
+	if (test_opt(sb, DATA_ERR_ABORT))
+		SEQ_OPTS_PUTS("data_err=abort");
 
 	ext4_show_quota_options(seq, sb);
 	return 0;
-- 
2.7.0

