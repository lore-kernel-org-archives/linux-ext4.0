From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/6] ext4: get rid of didicated MOUNT_QUOTA option
Date: Sun,  2 Oct 2011 23:44:39 +0400
Message-ID: <1317584681-29967-4-git-send-email-dmonakhov@openvz.org>
References: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, viro@ZenIV.linux.org.uk,
	adityakali@google.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64605 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab1JBTlS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Oct 2011 15:41:18 -0400
In-Reply-To: <1317584681-29967-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently didicated quota option is used only for options parsing phase,
which is very inefficient. Also show_opts output are not obvious in case
of journaled quota.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/super.c |   16 +++++++---------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9eedecb..e92c51a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -904,9 +904,9 @@ struct ext4_inode_info {
 #define EXT4_MOUNT_POSIX_ACL		0x08000	/* POSIX Access Control Lists */
 #define EXT4_MOUNT_NO_AUTO_DA_ALLOC	0x10000	/* No auto delalloc mapping */
 #define EXT4_MOUNT_BARRIER		0x20000 /* Use block barriers */
-#define EXT4_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT4_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT4_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT4_MOUNT_QUOTA		0x300000 /* Some quota option set */
 #define EXT4_MOUNT_DIOREAD_NOLOCK	0x400000 /* Enable support for dio read nolocking */
 #define EXT4_MOUNT_JOURNAL_CHECKSUM	0x800000 /* Journal checksums */
 #define EXT4_MOUNT_JOURNAL_ASYNC_COMMIT	0x1000000 /* Journal Async Commit */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..74d2726 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1459,7 +1459,6 @@ static int set_qf_name(struct super_block *sb, int qtype, substring_t *args)
 		sbi->s_qf_names[qtype] = NULL;
 		return 0;
 	}
-	set_opt(sb, QUOTA);
 	return 1;
 }
 
@@ -1694,10 +1693,12 @@ static int parse_options(char *options, struct super_block *sb,
 		case Opt_offusrjquota:
 			if (!clear_qf_name(sb, USRQUOTA))
 				return 0;
+			clear_opt(sb, USRQUOTA);
 			break;
 		case Opt_offgrpjquota:
 			if (!clear_qf_name(sb, GRPQUOTA))
 				return 0;
+			clear_opt(sb, USRQUOTA);
 			break;
 
 		case Opt_jqfmt_vfsold:
@@ -1720,11 +1721,9 @@ set_qf_format:
 			break;
 		case Opt_quota:
 		case Opt_usrquota:
-			set_opt(sb, QUOTA);
 			set_opt(sb, USRQUOTA);
 			break;
 		case Opt_grpquota:
-			set_opt(sb, QUOTA);
 			set_opt(sb, GRPQUOTA);
 			break;
 		case Opt_noquota:
@@ -1734,8 +1733,6 @@ set_qf_format:
 				return 0;
 			}
 			clear_opt(sb, QUOTA);
-			clear_opt(sb, USRQUOTA);
-			clear_opt(sb, GRPQUOTA);
 			break;
 #else
 		case Opt_quota:
@@ -1894,23 +1891,24 @@ set_qf_format:
 	}
 #ifdef CONFIG_QUOTA
 	if (sbi->s_qf_names[USRQUOTA] || sbi->s_qf_names[GRPQUOTA]) {
+		int jquota = 0;
 		if (test_opt(sb, USRQUOTA) && sbi->s_qf_names[USRQUOTA])
-			clear_opt(sb, USRQUOTA);
+			jquota |= EXT4_MOUNT_USRQUOTA;
 
 		if (test_opt(sb, GRPQUOTA) && sbi->s_qf_names[GRPQUOTA])
-			clear_opt(sb, GRPQUOTA);
+			jquota |= EXT4_MOUNT_GRPQUOTA;
 
-		if (test_opt(sb, GRPQUOTA) || test_opt(sb, USRQUOTA)) {
+		if (test_opt(sb, QUOTA) != jquota) {
 			ext4_msg(sb, KERN_ERR, "old and new quota "
 					"format mixing");
 			return 0;
 		}
