From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC 13/13] ext4: Implement ext4 dcache hooks for custom charsets
Date: Fri, 12 Jan 2018 05:12:34 -0200
Message-ID: <20180112071234.29470-14-krisman@collabora.co.uk>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, bpm@sgi.com, olaf@sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43106 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754316AbeALHOY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2018 02:14:24 -0500
In-Reply-To: <20180112071234.29470-1-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/dir.c   | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h  |  2 ++
 fs/ext4/super.c |  5 +++++
 3 files changed, 70 insertions(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d5babc9f222b..8b73a68930d2 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -25,6 +25,7 @@
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
+#include <linux/charsets.h>
 #include "ext4.h"
 #include "xattr.h"
 
@@ -661,3 +662,65 @@ const struct file_operations ext4_dir_operations = {
 	.open		= ext4_dir_open,
 	.release	= ext4_release_dir,
 };
+
+static int ext4_d_hash(const struct dentry *dentry, struct qstr *q)
+{
+	unsigned long hash;
+	int i, len;
+	char *str;
+	const struct charset *charset = EXT4_SB(dentry->d_sb)->encoding;
+
+	len = charset_normalize(charset, q->name, q->len, &str);
+
+	hash = init_name_hash(dentry);
+	for (i = 0; i < len; i++)
+		hash = partial_name_hash(str[i], hash);
+	q->hash = end_name_hash(hash);
+
+	kfree(str);
+	return 0;
+}
+
+static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
+			  const char *str, const struct qstr *name)
+{
+	const struct charset *charset = EXT4_SB(dentry->d_sb)->encoding;
+
+	return charset_strncmp(charset, str, name->name, len);
+}
+
+const struct dentry_operations ext4_dentry_ops = {
+	.d_hash = ext4_d_hash,
+	.d_compare = ext4_d_compare,
+};
+
+static int ext4_d_ci_hash(const struct dentry *dentry, struct qstr *q)
+{
+	unsigned long hash;
+	int i, len;
+	char *str;
+	const struct charset *charset = EXT4_SB(dentry->d_sb)->encoding;
+
+	len = charset_casefold(charset, q->name, q->len, &str);
+
+	hash = init_name_hash(dentry);
+	for (i = 0; i < len; i++)
+		hash = partial_name_hash(str[i], hash);
+	q->hash = end_name_hash(hash);
+
+	kfree(str);
+	return 0;
+}
+
+static int ext4_d_ci_compare(const struct dentry *dentry, unsigned int len,
+			     const char *str, const struct qstr *name)
+{
+	const struct charset *charset = EXT4_SB(dentry->d_sb)->encoding;
+
+	return charset_strncasecmp(charset, str, name->name, len);
+}
+
+const struct dentry_operations ext4_ci_dentry_ops = {
+	.d_hash = ext4_d_ci_hash,
+	.d_compare = ext4_d_ci_compare,
+};
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6c8aaf2dd322..980968aeb1cf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2943,6 +2943,8 @@ static inline void ext4_unlock_group(struct super_block *sb,
 
 /* dir.c */
 extern const struct file_operations ext4_dir_operations;
+extern const struct dentry_operations ext4_dentry_ops;
+extern const struct dentry_operations ext4_ci_dentry_ops;
 
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 022bf5f274b2..877acb938453 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4358,6 +4358,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (es->s_error_count)
 		mod_timer(&sbi->s_err_report, jiffies + 300*HZ); /* 5 minutes */
 
+	if (test_opt2(sb, CASE_INSENSITIVE))
+		sb->s_d_op = &ext4_ci_dentry_ops;
+	else
+		sb->s_d_op = &ext4_dentry_ops;
+
 	/* Enable message ratelimiting. Default is 10 messages per 5 secs. */
 	ratelimit_state_init(&sbi->s_err_ratelimit_state, 5 * HZ, 10);
 	ratelimit_state_init(&sbi->s_warning_ratelimit_state, 5 * HZ, 10);
-- 
2.15.1
