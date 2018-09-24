Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45600 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbeIYECu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2018 00:02:50 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RESEND v2 23/25] ext4: Implement encoding-aware dcache hooks
Date: Mon, 24 Sep 2018 17:56:53 -0400
Message-Id: <20180924215655.3676-24-krisman@collabora.co.uk>
In-Reply-To: <20180924215655.3676-1-krisman@collabora.co.uk>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch implements dcache hooks to improve the handling of
encoding-aware file names by the vfs dcache.

d_hash() is implemented as the hash of the normalized string, such that
have a well-known bucket for all the equivalencies of the same
string. d_compare uses the nls_strncmp() infrastructure, which should
handle the comparison of equivalent names as well.  If the filesystem's
normalization type is PLAIN, though, we can just reuse the VFS hash.

Changes since v1:
  - Use qstr->len instead of strlen.
  - Guard code with CONFIG_NLS.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/dir.c   | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h  |  3 +++
 fs/ext4/super.c |  6 ++++++
 3 files changed, 54 insertions(+)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index f93f9881ec18..37a36cdadaaf 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -26,6 +26,7 @@
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
 #include <linux/iversion.h>
+#include <linux/nls.h>
 #include "ext4.h"
 #include "xattr.h"
 
@@ -662,3 +663,47 @@ const struct file_operations ext4_dir_operations = {
 	.open		= ext4_dir_open,
 	.release	= ext4_release_dir,
 };
+
+#ifdef CONFIG_NLS
+static int ext4_d_compare(const struct dentry *dentry, unsigned int len,
+			  const char *str, const struct qstr *name)
+{
+	struct nls_table *charset = EXT4_SB(dentry->d_sb)->encoding;
+
+	return nls_strncmp(charset, str, len, name->name, name->len);
+}
+
+static int ext4_d_hash(const struct dentry *dentry, struct qstr *q)
+{
+	const struct nls_table *charset = EXT4_SB(dentry->d_sb)->encoding;
+	unsigned char *norm;
+	int len, ret = 0;
+
+	/* If normalization is TYPE_PLAIN, we can just reuse the vfs
+	 * hash. */
+	if (IS_NORMALIZATION_TYPE_ALL_PLAIN(charset))
+	    return 0;
+
+	norm = kmalloc(PATH_MAX, GFP_ATOMIC);
+	if (!norm)
+		return -ENOMEM;
+
+	len = nls_normalize(charset, q->name, q->len, norm, PATH_MAX);
+
+	if (len < 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	q->hash = full_name_hash(dentry, norm, len);
+
+out:
+	kfree (norm);
+	return ret;
+}
+
+const struct dentry_operations ext4_dentry_ops = {
+	.d_hash = ext4_d_hash,
+	.d_compare = ext4_d_compare,
+};
+#endif
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f7932d70b9fd..586e733c8915 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2979,6 +2979,9 @@ static inline void ext4_unlock_group(struct super_block *sb,
 
 /* dir.c */
 extern const struct file_operations ext4_dir_operations;
+#ifdef CONFIG_NLS
+extern const struct dentry_operations ext4_dentry_ops;
+#endif
 
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f70c947c9850..a9809a2d371c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4480,6 +4480,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		iput(root);
 		goto failed_mount4;
 	}
+
+#ifdef CONFIG_NLS
+	if (sbi->encoding)
+		sb->s_d_op = &ext4_dentry_ops;
+#endif
+
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root) {
 		ext4_msg(sb, KERN_ERR, "get root dentry failed");
-- 
2.19.0
