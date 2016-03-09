From: Ales Novak <alnovak@suse.cz>
Subject: [PATCH] fix: print ext4 mountopt data_err=abort correctly
Date: Wed,  9 Mar 2016 14:09:39 +0100
Message-ID: <1457528979-25737-1-git-send-email-alnovak@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ales Novak <alnovak@suse.cz>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If data_err=abort option is specified for an ext3/ext4 mount,
/proc/mounts does show it as "(null)". This is caused by token2str()
returning NULL for Opt_data_err_abort (due to its pattern containing
'=').

This could be solved by many ways, this one is the conservative and
former ext3 way resembling.

Signed-off-by: Ales Novak <alnovak@suse.cz>
---
 fs/ext4/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ed01ec..58c203a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1860,7 +1860,8 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 	for (m = ext4_mount_opts; m->token != Opt_err; m++) {
 		int want_set = m->flags & MOPT_SET;
 		if (((m->flags & (MOPT_SET|MOPT_CLEAR)) == 0) ||
-		    (m->flags & MOPT_CLEAR_ERR))
+		    (m->flags & MOPT_CLEAR_ERR) ||
+		    (m->mount_opt & EXT4_MOUNT_DATA_ERR_ABORT))
 			continue;
 		if (!(m->mount_opt & (sbi->s_mount_opt ^ def_mount_opt)))
 			continue; /* skip if same as the default */
@@ -1914,6 +1915,8 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 		SEQ_OPTS_PRINT("init_itable=%u", sbi->s_li_wait_mult);
 	if (nodefs || sbi->s_max_dir_size_kb)
 		SEQ_OPTS_PRINT("max_dir_size_kb=%u", sbi->s_max_dir_size_kb);
+	if (test_opt(sb, DATA_ERR_ABORT))
+		SEQ_OPTS_PUTS("data_err=abort");
 
 	ext4_show_quota_options(seq, sb);
 	return 0;
-- 
2.7.0
