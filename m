From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 04/11] ext4: simplify handling of the errors=* mount options
Date: Sun,  4 Mar 2012 22:08:18 -0500
Message-ID: <1330916905-5976-4-git-send-email-tytso@mit.edu>
References: <1330916905-5976-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41869 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab2CEDI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2012 22:08:26 -0500
In-Reply-To: <1330916905-5976-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |    9 +++------
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index df93dc1..d70b981 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -924,6 +924,7 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_ERRORS_CONT		0x00010	/* Continue on errors */
 #define EXT4_MOUNT_ERRORS_RO		0x00020	/* Remount fs ro on errors */
 #define EXT4_MOUNT_ERRORS_PANIC		0x00040	/* Panic on errors */
+#define EXT4_MOUNT_ERRORS_MASK		0x00070
 #define EXT4_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
 #define EXT4_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
 #define EXT4_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6b27bc6..93cca1f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1565,18 +1565,15 @@ static int parse_options(char *options, struct super_block *sb,
 			/* *sb_block = match_int(&args[0]); */
 			break;
 		case Opt_err_panic:
-			clear_opt(sb, ERRORS_CONT);
-			clear_opt(sb, ERRORS_RO);
+			clear_opt(sb, ERRORS_MASK);
 			set_opt(sb, ERRORS_PANIC);
 			break;
 		case Opt_err_ro:
-			clear_opt(sb, ERRORS_CONT);
-			clear_opt(sb, ERRORS_PANIC);
+			clear_opt(sb, ERRORS_MASK);
 			set_opt(sb, ERRORS_RO);
 			break;
 		case Opt_err_cont:
-			clear_opt(sb, ERRORS_RO);
-			clear_opt(sb, ERRORS_PANIC);
+			clear_opt(sb, ERRORS_MASK);
 			set_opt(sb, ERRORS_CONT);
 			break;
 		case Opt_nouid32:
-- 
1.7.9.107.g97f9a

