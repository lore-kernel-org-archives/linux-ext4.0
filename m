From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] handle optional-arg mount options better
Date: Wed, 03 Feb 2010 15:13:30 -0600
Message-ID: <4B69E6FA.20901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634Ab0BCVNc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Feb 2010 16:13:32 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13LDWCh023234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 3 Feb 2010 16:13:32 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o13LDUnf028268
	for <linux-ext4@vger.kernel.org>; Wed, 3 Feb 2010 16:13:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have 2 mount options, "barrier" and "auto_da_alloc"
which may or may not take a 1/0 argument.  This is confusing
the parser, it seems, because if we pass it without an
arg, it still tries to match_int for the arg, which
is uninitialized, and match_number uses those uninit from/to
values to do a kmalloc, resulting in potentially noisy
failures.

I think just defining _arg variants of the tokens and
handling them separately is the simplest fix.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(I'll send one for ext3 as well if this looks good on review)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index da184f4..f7d4f06 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1096,7 +1096,8 @@ enum {
 	Opt_resgid, Opt_resuid, Opt_sb, Opt_err_cont, Opt_err_panic, Opt_err_ro,
 	Opt_nouid32, Opt_debug, Opt_oldalloc, Opt_orlov,
 	Opt_user_xattr, Opt_nouser_xattr, Opt_acl, Opt_noacl,
-	Opt_auto_da_alloc, Opt_noauto_da_alloc, Opt_noload, Opt_nobh, Opt_bh,
+	Opt_auto_da_alloc_arg, Opt_auto_da_alloc, Opt_noauto_da_alloc,
+	Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_min_batch_time, Opt_max_batch_time,
 	Opt_journal_update, Opt_journal_dev,
 	Opt_journal_checksum, Opt_journal_async_commit,
@@ -1104,8 +1105,8 @@ enum {
 	Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_jqfmt_vfsv1, Opt_quota,
-	Opt_noquota, Opt_ignore, Opt_barrier, Opt_nobarrier, Opt_err,
-	Opt_resize, Opt_usrquota, Opt_grpquota, Opt_i_version,
+	Opt_noquota, Opt_ignore, Opt_barrier_arg, Opt_barrier, Opt_nobarrier,
+	Opt_err, Opt_resize, Opt_usrquota, Opt_grpquota, Opt_i_version,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc,
 	Opt_block_validity, Opt_noblock_validity,
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
@@ -1161,7 +1162,7 @@ static const match_table_t tokens = {
 	{Opt_noquota, "noquota"},
 	{Opt_quota, "quota"},
 	{Opt_usrquota, "usrquota"},
-	{Opt_barrier, "barrier=%u"},
+	{Opt_barrier_arg, "barrier=%u"},
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_i_version, "i_version"},
@@ -1173,7 +1174,7 @@ static const match_table_t tokens = {
 	{Opt_noblock_validity, "noblock_validity"},
 	{Opt_inode_readahead_blks, "inode_readahead_blks=%u"},
 	{Opt_journal_ioprio, "journal_ioprio=%u"},
-	{Opt_auto_da_alloc, "auto_da_alloc=%u"},
+	{Opt_auto_da_alloc_arg, "auto_da_alloc=%u"},
 	{Opt_auto_da_alloc, "auto_da_alloc"},
 	{Opt_noauto_da_alloc, "noauto_da_alloc"},
 	{Opt_discard, "discard"},
@@ -1514,10 +1515,7 @@ set_qf_format:
 		case Opt_abort:
 			sbi->s_mount_flags |= EXT4_MF_FS_ABORTED;
 			break;
-		case Opt_nobarrier:
-			clear_opt(sbi->s_mount_opt, BARRIER);
-			break;
-		case Opt_barrier:
+		case Opt_barrier_arg:
 			if (match_int(&args[0], &option)) {
 				set_opt(sbi->s_mount_opt, BARRIER);
 				break;
@@ -1527,6 +1525,12 @@ set_qf_format:
 			else
 				clear_opt(sbi->s_mount_opt, BARRIER);
 			break;
+		case Opt_nobarrier:
+			clear_opt(sbi->s_mount_opt, BARRIER);
+			break;
+		case Opt_barrier:
+			set_opt(sbi->s_mount_opt, BARRIER);
+			break;
 		case Opt_ignore:
 			break;
 		case Opt_resize:
@@ -1590,10 +1594,7 @@ set_qf_format:
 			*journal_ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE,
 							    option);
 			break;
-		case Opt_noauto_da_alloc:
-			set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
-			break;
-		case Opt_auto_da_alloc:
+		case Opt_auto_da_alloc_arg:
 			if (match_int(&args[0], &option)) {
 				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
 				break;
@@ -1603,6 +1604,12 @@ set_qf_format:
 			else
 				set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
+		case Opt_noauto_da_alloc:
+			set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
+			break;
+		case Opt_auto_da_alloc:
+			clear_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
+			break;
 		case Opt_discard:
 			set_opt(sbi->s_mount_opt, DISCARD);
 			break;

