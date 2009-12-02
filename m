From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] ext4: Support for 64-bit quota format
Date: Wed,  2 Dec 2009 21:52:11 +0100
Message-ID: <1259787131-6218-5-git-send-email-jack@suse.cz>
References: <1259787131-6218-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbZLBUxC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Dec 2009 15:53:02 -0500
In-Reply-To: <1259787131-6218-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add support for new 64-bit quota format. It is enough to add proper
mount options handling. The rest is done by the generic code.

CC: tytso@mit.edu
CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |   30 ++++++++++++++++++++++++------
 1 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d4ca92a..10483fa 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -765,9 +765,22 @@ static inline void ext4_show_quota_options(struct seq_file *seq,
 #if defined(CONFIG_QUOTA)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
-	if (sbi->s_jquota_fmt)
-		seq_printf(seq, ",jqfmt=%s",
-		(sbi->s_jquota_fmt == QFMT_VFS_OLD) ? "vfsold" : "vfsv0");
+	if (sbi->s_jquota_fmt) {
+		char *fmtname = "";
+
+		switch (sbi->s_jquota_fmt) {
+		case QFMT_VFS_OLD:
+			fmtname = "vfsold";
+			break;
+		case QFMT_VFS_V0:
+			fmtname = "vfsv0";
+			break;
+		case QFMT_VFS_V1:
+			fmtname = "vfsv1";
+			break;
+		}
+		seq_printf(seq, ",jqfmt=%s", fmtname);
+	}
 
 	if (sbi->s_qf_names[USRQUOTA])
 		seq_printf(seq, ",usrjquota=%s", sbi->s_qf_names[USRQUOTA]);
@@ -1074,9 +1087,9 @@ enum {
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
-	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
-	Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err, Opt_resize,
-	Opt_usrquota, Opt_grpquota, Opt_i_version,
+	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
+	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
+	Opt_resize, Opt_usrquota, Opt_grpquota, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc,
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio
@@ -1125,6 +1138,7 @@ static const match_table_t tokens = {
 	{Opt_grpjquota, "grpjquota=%s"},
 	{Opt_jqfmt_vfsold, "jqfmt=vfsold"},
 	{Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
+	{Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
 	{Opt_grpquota, "grpquota"},
 	{Opt_noquota, "noquota"},
 	{Opt_quota, "quota"},
@@ -1425,6 +1439,9 @@ clear_qf_name:
 			goto set_qf_format;
 		case Opt_jqfmt_vfsv0:
 			qfmt = QFMT_VFS_V0;
+			goto set_qf_format;
+		case Opt_jqfmt_vfsv1:
+			qfmt = QFMT_VFS_V1;
 set_qf_format:
 			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
@@ -1467,6 +1484,7 @@ set_qf_format:
 		case Opt_offgrpjquota:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
+		case Opt_jqfmt_vfsv1:
 			ext4_msg(sb, KERN_ERR,
 				"journaled quota options not supported");
 			break;
-- 
1.6.4.2

