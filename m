From: jmarchan@redhat.com
Subject: [PATCH RHEL6 3/4] ext3: Support for vfsv1 quota format
Date: Mon, 14 Dec 2009 15:11:26 +0100
Message-ID: <20091214141155.299784151@dhcp-0-151.brq.redhat.com>
References: <20091214141123.439793308@dhcp-0-151.brq.redhat.com>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: jmarchan@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbZLNOMA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 09:12:00 -0500
Content-Disposition: inline; filename=vfsv1_quota_format.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bugzilla:
https://bugzilla.redhat.com/show_bug.cgi?id=546311

Description:
We just have to add proper mount options handling. The rest is handled by
the generic quota code.

CC: linux-ext4@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

Index: rhel6/fs/ext3/super.c
===================================================================
--- rhel6.orig/fs/ext3/super.c
+++ rhel6/fs/ext3/super.c
@@ -525,9 +525,22 @@ static inline void ext3_show_quota_optio
 #if defined(CONFIG_QUOTA)
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 
-	if (sbi->s_jquota_fmt)
-		seq_printf(seq, ",jqfmt=%s",
-		(sbi->s_jquota_fmt == QFMT_VFS_OLD) ? "vfsold": "vfsv0");
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
@@ -785,9 +798,9 @@ enum {
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
 	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
-	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
-	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
+	Opt_noquota, Opt_ignore, Opt_barrier, Opt_err, Opt_resize,
+	Opt_usrquota, Opt_grpquota
 };
 
 static const match_table_t tokens = {
@@ -834,6 +847,7 @@ static const match_table_t tokens = {
 	{Opt_grpjquota, "grpjquota=%s"},
 	{Opt_jqfmt_vfsold, "jqfmt=vfsold"},
 	{Opt_jqfmt_vfsv0, "jqfmt=vfsv0"},
+	{Opt_jqfmt_vfsv1, "jqfmt=vfsv1"},
 	{Opt_grpquota, "grpquota"},
 	{Opt_noquota, "noquota"},
 	{Opt_quota, "quota"},
@@ -1119,6 +1133,9 @@ clear_qf_name:
 			goto set_qf_format;
 		case Opt_jqfmt_vfsv0:
 			qfmt = QFMT_VFS_V0;
+			goto set_qf_format;
+		case Opt_jqfmt_vfsv1:
+			qfmt = QFMT_VFS_V1;
 set_qf_format:
 			if (sb_any_quota_loaded(sb) &&
 			    sbi->s_jquota_fmt != qfmt) {
@@ -1161,6 +1178,7 @@ set_qf_format:
 		case Opt_offgrpjquota:
 		case Opt_jqfmt_vfsold:
 		case Opt_jqfmt_vfsv0:
+		case Opt_jqfmt_vfsv1:
 			printk(KERN_ERR
 				"EXT3-fs: journaled quota options not "
 				"supported.\n");

