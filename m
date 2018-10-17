Return-Path: <SRS0=48F3=M5=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50186 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbeJREyN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2018 00:54:13 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v3 20/23] ext4: Include encoding information in the superblock
Date: Wed, 17 Oct 2018 16:55:21 -0400
Message-Id: <20181017205524.23360-21-krisman@collabora.co.uk>
In-Reply-To: <20181017205524.23360-1-krisman@collabora.co.uk>
References: <20181017205524.23360-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Support for encoding is considered an incompatible feature, since it has
potential to create collisions of file names in existing filesystems.
If the feature flag is not enabled, the entire filesystem will operate
on opaque byte sequences, respecting the original behavior.

The charset data is encoded in a new field in the superblock using a
magic number specific to ext4.  This is the easiest way I found to avoid
writing the name of the charset in the superblock.  The magic number is
mapped to the exact NLS table, but the mapping is specific to ext4.
Since we don't have any commitment to support old encodings, the only
encodings I am supporting right now is utf8n-10.0.0 and ascii, both
using the NLS abstraction.

The current implementation prevents the user from enabling encoding and
per-directory encryption on the same filesystem at the same time.  The
incompatibility between these features lies in how we do efficient
directory searches when we cannot be sure the encryption of the user
provided fname will match the actual hash stored in the disk without
decrypting every directory entry, because of normalization cases.  My
quickest solution is to simply block the concurrent use of these
features for now, and enable it later, once we have a better solution.

Changes since v2:
  - Split superblock bitfield reservation into another patch.
  - Rename s_ioencoding -> s_encoding
  - Remove encoding_info from in-memory superblock.

Changes since v1:
  - Guard code with CONFIG_NLS.
  - Use 16 bits for s_ioencoding.
  - Split mount option from this patch

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/ext4.h  |  4 +++
 fs/ext4/super.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 358ccf06fade..9fa952c6ba4d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1396,6 +1396,10 @@ struct ext4_sb_info {
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
 	struct super_block *s_sb;
+#ifdef CONFIG_NLS
+	struct nls_table *s_encoding;
+	__u16 s_encoding_flags;
+#endif
 
 	/* Journaling */
 	struct journal_s *s_journal;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5d78b0c8225f..a09a72e7ee58 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -42,6 +42,7 @@
 #include <linux/cleancache.h>
 #include <linux/uaccess.h>
 #include <linux/iversion.h>
+#include <linux/nls.h>
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -1022,6 +1023,9 @@ static void ext4_put_super(struct super_block *sb)
 		crypto_free_shash(sbi->s_chksum_driver);
 	kfree(sbi->s_blockgroup_lock);
 	fs_put_dax(sbi->s_daxdev);
+#ifdef CONFIG_NLS
+	unload_nls(sbi->s_encoding);
+#endif
 	kfree(sbi);
 }
 
@@ -1716,6 +1720,31 @@ static const struct mount_opts {
 	{Opt_err, 0, 0}
 };
 
+#ifdef CONFIG_NLS
+static const struct ext4_sb_encodings {
+	char *name;
+	char *version;
+} ext4_sb_encoding_map[] = {
+	/* 0x0 */	{"ascii", NULL},
+	/* 0x1 */	{"utf8", "10.0.0"},
+};
+
+static int
+ext4_sb_read_encoding(const struct ext4_super_block *es,
+		      const struct ext4_sb_encodings **encoding, __u16 *flags)
+{
+	__u16 magic = le16_to_cpu(es->s_encoding);
+
+	if (magic >= ARRAY_SIZE(ext4_sb_encoding_map))
+		return -EINVAL;
+
+	*encoding = &ext4_sb_encoding_map[magic];
+	*flags = le16_to_cpu(es->s_encoding_flags);
+
+	return 0;
+}
+#endif
+
 static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			    substring_t *args, unsigned long *journal_devnum,
 			    unsigned int *journal_ioprio, int is_remount)
@@ -3534,6 +3563,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err = 0;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
+#ifdef CONFIG_NLS
+	struct nls_table *encoding;
+	const struct ext4_sb_encodings *encoding_info;
+	__u16 nls_flags;
+#endif
 
 	if ((data && !orig_data) || !sbi)
 		goto out_free_base;
@@ -3706,6 +3740,38 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			   &journal_ioprio, 0))
 		goto failed_mount;
 
+#ifdef CONFIG_NLS
+	if (ext4_has_feature_fname_encoding(sb) && !sbi->s_encoding) {
+		if (ext4_has_feature_encrypt(sb)) {
+			ext4_msg(sb, KERN_ERR,
+				 "Can't mount with both encoding and encryption");
+			goto failed_mount;
+		}
+
+		if (ext4_sb_read_encoding(es, &encoding_info, &nls_flags)) {
+			ext4_msg(sb, KERN_ERR,
+				 "Encoding requested by superblock is unknown");
+			goto failed_mount;
+		}
+
+		encoding = load_nls_version(encoding_info->name,
+					    encoding_info->version, nls_flags);
+		if (IS_ERR(encoding)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with superblock charset: "
+				 "%s-%s not supported by the kernel. flags: 0x%x",
+				 encoding_info->name, encoding_info->version,
+				 nls_flags);
+			goto failed_mount;
+		}
+		ext4_msg(sb, KERN_INFO,"Using encoding defined by superblock: "
+			 "%s-%s with flags 0x%hx", encoding_info->name,
+			 encoding_info->version?:"\b", nls_flags);
+
+		sbi->s_encoding = encoding;
+		sbi->s_encoding_flags = nls_flags;
+	}
+#endif
+
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
 		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting "
 			    "with data=journal disables delayed "
@@ -4546,6 +4612,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 failed_mount:
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
+
+#ifdef CONFIG_NLS
+	unload_nls(sbi->s_encoding);
+#endif
+
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(sbi->s_qf_names[i]);
-- 
2.19.1
