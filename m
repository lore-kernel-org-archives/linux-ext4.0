Return-Path: <SRS0=NyoO=QE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207ACC282C8
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:32:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E487821738
	for <linux-ext4@archiver.kernel.org>; Mon, 28 Jan 2019 21:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfA1Vc4 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:32:56 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58218 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfA1Vc4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2019 16:32:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id B12C727FB81
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     tytso@mit.edu
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        sfrench@samba.org, darrick.wong@oracle.com,
        samba-technical@lists.samba.org, jlayton@kernel.org,
        bfields@fieldses.org, paulus@samba.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v5 08/11] ext4: Include encoding information in the superblock
Date:   Mon, 28 Jan 2019 16:32:20 -0500
Message-Id: <20190128213223.31512-9-krisman@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190128213223.31512-1-krisman@collabora.com>
References: <20190128213223.31512-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

Support for encoding is considered an incompatible feature, since it has
potential to create collisions of file names in existing filesystems.
If the feature flag is not enabled, the entire filesystem will operate
on opaque byte sequences, respecting the original behavior.

The s_encoding field stores a magic number indicating the encoding
format and version used globally by file and directory names in the
filesystem.  The s_encoding_flags defines policies for using the charset
encoding, like how to handle invalid sequences.  The magic number is
mapped to the exact charset table, but the mapping is specific to ext4.
Since we don't have any commitment to support old encodings, the only
encoding I am supporting right now is utf8-11.0.

The current implementation prevents the user from enabling encoding and
per-directory encryption on the same filesystem at the same time.  The
incompatibility between these features lies in how we do efficient
directory searches when we cannot be sure the encryption of the user
provided fname will match the actual hash stored in the disk without
decrypting every directory entry, because of normalization cases.  My
quickest solution is to simply block the concurrent use of these
features for now, and enable it later, once we have a better solution.

Changes since v4:
  - Move from fs/nls to fs/unicode

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
 fs/ext4/ext4.h  | 21 +++++++++++-
 fs/ext4/super.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3f89d0ab08fc..683fa2fe4b38 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1311,7 +1311,9 @@ struct ext4_super_block {
 	__u8	s_first_error_time_hi;
 	__u8	s_last_error_time_hi;
 	__u8	s_pad[2];
-	__le32	s_reserved[96];		/* Padding to the end of the block */
+	__le16  s_encoding;		/* Filename charset encoding */
+	__le16  s_encoding_flags;	/* Filename charset encoding flags */
+	__le32	s_reserved[95];		/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1336,6 +1338,16 @@ struct ext4_super_block {
 /* Number of quota types we support */
 #define EXT4_MAXQUOTAS 3
 
+#define EXT4_ENC_UTF8_11_0	1
+
+/*
+ * Flags for ext4_sb_info.s_encoding_flags.
+ */
+#define EXT4_ENC_STRICT_MODE_FL	(1 << 0)
+
+#define ext4_has_strict_mode(sbi) \
+	(sbi->s_encoding_flags & EXT4_ENC_STRICT_MODE_FL)
+
 /*
  * fourth extended-fs super-block data in memory
  */
@@ -1385,6 +1397,10 @@ struct ext4_sb_info {
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
 	struct super_block *s_sb;
+#ifdef CONFIG_UNICODE
+	struct unicode_map *s_encoding;
+	__u16 s_encoding_flags;
+#endif
 
 	/* Journaling */
 	struct journal_s *s_journal;
@@ -1661,6 +1677,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
+#define EXT4_FEATURE_INCOMPAT_FNAME_ENCODING	0x20000
 
 #define EXT4_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline bool ext4_has_feature_##name(struct super_block *sb) \
@@ -1749,6 +1766,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(csum_seed,		CSUM_SEED)
 EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		LARGEDIR)
 EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	INLINE_DATA)
 EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
+EXT4_FEATURE_INCOMPAT_FUNCS(fname_encoding,	FNAME_ENCODING)
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
@@ -1776,6 +1794,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		ENCRYPT)
 					 EXT4_FEATURE_INCOMPAT_MMP | \
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
+					 EXT4_FEATURE_INCOMPAT_FNAME_ENCODING | \
 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED | \
 					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 53ff6c2a26ed..bcc2bc192403 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -42,6 +42,7 @@
 #include <linux/cleancache.h>
 #include <linux/uaccess.h>
 #include <linux/iversion.h>
+#include <linux/unicode.h>
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -1022,6 +1023,9 @@ static void ext4_put_super(struct super_block *sb)
 		crypto_free_shash(sbi->s_chksum_driver);
 	kfree(sbi->s_blockgroup_lock);
 	fs_put_dax(sbi->s_daxdev);
+#ifdef CONFIG_UNICODE
+	utf8_unload(sbi->s_encoding);
+#endif
 	kfree(sbi);
 }
 
@@ -1716,6 +1720,36 @@ static const struct mount_opts {
 	{Opt_err, 0, 0}
 };
 
+#ifdef CONFIG_UNICODE
+static const struct ext4_sb_encodings {
+	__u16 magic;
+	char *name;
+	char *version;
+} ext4_sb_encoding_map[] = {
+	{EXT4_ENC_UTF8_11_0, "utf8", "11.0.0"},
+};
+
+static int ext4_sb_read_encoding(const struct ext4_super_block *es,
+				 const struct ext4_sb_encodings **encoding,
+				 __u16 *flags)
+{
+	__u16 magic = le16_to_cpu(es->s_encoding);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ext4_sb_encoding_map); i++)
+		if (magic == ext4_sb_encoding_map[i].magic)
+			break;
+
+	if (i >= ARRAY_SIZE(ext4_sb_encoding_map))
+		return -EINVAL;
+
+	*encoding = &ext4_sb_encoding_map[i];
+	*flags = le16_to_cpu(es->s_encoding_flags);
+
+	return 0;
+}
+#endif
+
 static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			    substring_t *args, unsigned long *journal_devnum,
 			    unsigned int *journal_ioprio, int is_remount)
@@ -2847,6 +2881,15 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 		return 0;
 	}
 
+#ifndef CONFIG_UNICODE
+	if (ext4_has_feature_fname_encoding(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Filesystem with fname_encoding feature cannot be "
+			 "mounted without CONFIG_UNICODE");
+		return 0;
+	}
+#endif
+
 	if (readonly)
 		return 1;
 
@@ -3706,6 +3749,43 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			   &journal_ioprio, 0))
 		goto failed_mount;
 
+#ifdef CONFIG_UNICODE
+	if (ext4_has_feature_fname_encoding(sb) && !sbi->s_encoding) {
+		const struct ext4_sb_encodings *encoding_info;
+		struct unicode_map *encoding;
+		__u16 encoding_flags;
+
+		if (ext4_has_feature_encrypt(sb)) {
+			ext4_msg(sb, KERN_ERR,
+				 "Can't mount with encoding and encryption");
+			goto failed_mount;
+		}
+
+		if (ext4_sb_read_encoding(es, &encoding_info,
+					  &encoding_flags)) {
+			ext4_msg(sb, KERN_ERR,
+				 "Encoding requested by superblock is unknown");
+			goto failed_mount;
+		}
+
+		encoding = utf8_load(encoding_info->version);
+		if (IS_ERR(encoding)) {
+			ext4_msg(sb, KERN_ERR,
+				 "can't mount with superblock charset: %s-%s "
+				 "not supported by the kernel. flags: 0x%x.",
+				 encoding_info->name, encoding_info->version,
+				 encoding_flags);
+			goto failed_mount;
+		}
+		ext4_msg(sb, KERN_INFO,"Using encoding defined by superblock: "
+			 "%s-%s with flags 0x%hx", encoding_info->name,
+			 encoding_info->version?:"\b", encoding_flags);
+
+		sbi->s_encoding = encoding;
+		sbi->s_encoding_flags = encoding_flags;
+	}
+#endif
+
 	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
 		printk_once(KERN_WARNING "EXT4-fs: Warning: mounting "
 			    "with data=journal disables delayed "
@@ -4547,6 +4627,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 failed_mount:
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
+
+#ifdef CONFIG_UNICODE
+	utf8_unload(sbi->s_encoding);
+#endif
+
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(sbi->s_qf_names[i]);
-- 
2.20.1

