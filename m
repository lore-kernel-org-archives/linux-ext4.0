From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v2 10/13] ext4: Include encoding information on the superblock
Date: Thu, 25 Jan 2018 00:53:46 -0200
Message-ID: <20180125025349.31494-11-krisman@collabora.co.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        alvaro.soliverez@collabora.co.uk, kernel@lists.collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, olaf@sgi.com,
        viro@zeniv.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52102 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933065AbeAYCzY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jan 2018 21:55:24 -0500
In-Reply-To: <20180125025349.31494-1-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 09fb2426c352..6c8aaf2dd322 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1369,6 +1369,7 @@ struct ext4_sb_info {
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
 	struct super_block *s_sb;
+	const struct charset *encoding;
 
 	/* Journaling */
 	struct journal_s *s_journal;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f737e90a3b4e..022bf5f274b2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -40,6 +40,7 @@
 #include <linux/dax.h>
 #include <linux/cleancache.h>
 #include <linux/uaccess.h>
+#include <linux/charsets.h>
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -1350,7 +1351,7 @@ enum {
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
 	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
-	Opt_ignore_case,
+	Opt_ignore_case, Opt_encoding,
 };
 
 static const match_table_t tokens = {
@@ -1434,6 +1435,7 @@ static const match_table_t tokens = {
 	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
 	{Opt_test_dummy_encryption, "test_dummy_encryption"},
 	{Opt_ignore_case, "ignorecase"},
+	{Opt_encoding, "encoding=%s"},
 	{Opt_nombcache, "nombcache"},
 	{Opt_nombcache, "no_mbcache"},	/* for backward compatibility */
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
@@ -1644,6 +1646,7 @@ static const struct mount_opts {
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
 	{Opt_test_dummy_encryption, 0, MOPT_GTE0},
 	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET},
+	{Opt_encoding, 0, MOPT_EXT4_ONLY | MOPT_STRING},
 	{Opt_err, 0, 0}
 };
 
@@ -1882,6 +1885,16 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		sbi->s_mount_opt |= m->mount_opt;
 	} else if (token == Opt_data_err_ignore) {
 		sbi->s_mount_opt &= ~m->mount_opt;
+	} else if (token == Opt_encoding) {
+		char *charset = match_strdup(&args[0]);
+
+		sbi->encoding = charset_load(charset);
+		if (!sbi->encoding) {
+			ext4_msg(sb, KERN_ERR, "Encoding %s not supported\n",
+				 charset);
+			return -1;
+		}
+		kfree(charset);
 	} else {
 		if (!args->from)
 			arg = 1;
@@ -1968,6 +1981,12 @@ static int parse_options(char *options, struct super_block *sb,
 			return 0;
 		}
 	}
+
+	if (test_opt2(sb, CASE_INSENSITIVE) && !sbi->encoding) {
+		ext4_msg(sb, KERN_WARNING, "Encoding not explicitly specified "
+			 "or identified on the superblock.  ASCII is assumed.");
+	}
+
 	return 1;
 }
 
@@ -3598,6 +3617,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			   &journal_ioprio, 0))
 		goto failed_mount;
 
+	if (!sbi->encoding) {
+		sbi->encoding = charset_load("ascii");
+		if (!sbi->encoding)
+			goto failed_mount;
+	}
+
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
 		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting "
 			    "with data=journal disables delayed "
-- 
2.15.1
