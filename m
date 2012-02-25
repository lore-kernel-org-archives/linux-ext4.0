From: Tom Gundersen <teg@jklm.no>
Subject: [PATCH] ext4: ignore ext3/ext2 only mount options
Date: Sat, 25 Feb 2012 14:37:01 +0100
Message-ID: <1330177021-1189-1-git-send-email-teg@jklm.no>
Mime-Version: 1.0
Cc: Tom Gundersen <teg@jklm.no>,
	Thomas Baechler <thomas@archlinux.org>,
	Tobias Powalowski <tobias.powalowski@googlemail.com>,
	Dave Reisner <d@falconindy.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:55176 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab2BYNiV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Feb 2012 08:38:21 -0500
Received: by werb13 with SMTP id b13so1976722wer.19
        for <linux-ext4@vger.kernel.org>; Sat, 25 Feb 2012 05:38:20 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is a regression when using the ext4 module to mount
ext2 or ext3 filesystems: When mountoptions are used that are
supported by ext2 or ext3, but not by ext4 the mount fails.

This patch changes the failure into a warning. The case when
the ext4 module is not used for ext2/3 support is unchanged.

Report: https://bbs.archlinux.org/profile.php?id=33804
Signed-off-by: Tom Gundersen <teg@jklm.no>
Cc: Thomas Baechler <thomas@archlinux.org>
Cc: Tobias Powalowski <tobias.powalowski@googlemail.com>
Cc: Dave Reisner <d@falconindy.com>
---
 fs/ext4/super.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 502c61f..30de9cd 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1333,6 +1333,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
+	Opt_nocheck, Opt_reservation, Opt_noreservation, Opt_journal_inum,
 };
 
 static const match_table_t tokens = {
@@ -1408,6 +1409,10 @@ static const match_table_t tokens = {
 	{Opt_init_itable, "init_itable=%u"},
 	{Opt_init_itable, "init_itable"},
 	{Opt_noinit_itable, "noinit_itable"},
+	{Opt_nocheck, "nocheck"},
+	{Opt_reservation, "reservation"},
+	{Opt_noreservation, "noreservation"},
+	{Opt_journal_inum, "journal=%u"},
 	{Opt_err, NULL},
 };
 
@@ -1904,6 +1909,16 @@ set_qf_format:
 		case Opt_noinit_itable:
 			clear_opt(sb, INIT_INODE_TABLE);
 			break;
+#ifdef CONFIG_EXT4_USE_FOR_EXT23
+		case Opt_nocheck:
+		case Opt_reservation:
+		case Opt_noreservation:
+		case Opt_journal_inum:
+			ext4_msg(sb, KERN_WARNING,
+			       "ext3 mount option \"%s\" ignored "
+			       "by ext4 module", p);
+			break;
+#endif
 		default:
 			ext4_msg(sb, KERN_ERR,
 			       "Unrecognized mount option \"%s\" "
-- 
1.7.9.2

