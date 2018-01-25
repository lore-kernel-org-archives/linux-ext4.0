From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v2 13/13] ext4: Implement ext4 dcache hooks for custom charsets
Date: Thu, 25 Jan 2018 00:53:49 -0200
Message-ID: <20180125025349.31494-14-krisman@collabora.co.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        alvaro.soliverez@collabora.co.uk, kernel@lists.collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, olaf@sgi.com,
        viro@zeniv.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180125025349.31494-1-krisman@collabora.co.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Changes from RFC v1:
  - Handle errors from charset_normalize/casefold (Olaf Weber)
  - Send length of both strings to comparison functions.
  - Cast length type to size_t

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/dir.c   | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h  |  2 ++
 fs/ext4/super.c |  5 ++++
 3 files changed, 80 insertions(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d5babc9f222b..1c75aff87098 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -25,6 +25,7 @@
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
+#include <linux/charsets.h>
 #include "ext4.h"
 #include "xattr.h"
 
@@ -661,3 +662,75 @@ const struct file_operations ext4_dir_operations = {
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
+	if (len < 0) {
+		kfree(str);
+		return -EINVAL;
+	}
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
+	return charset_strncmp(charset, str, len, name->name, strlen(name->name));
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
+	if (len < 0) {
+		kfree(str);
+		return -EINVAL;
+	}
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
+	return charset_strncasecmp(charset, str, len, name->name, strlen(name->name));
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
