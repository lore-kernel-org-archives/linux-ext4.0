Return-Path: <SRS0=VTDm=MG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45592 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbeIYECp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2018 00:02:45 -0400
From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RESEND v2 21/25] ext4: Add encoding mount options
Date: Mon, 24 Sep 2018 17:56:51 -0400
Message-Id: <20180924215655.3676-22-krisman@collabora.co.uk>
In-Reply-To: <20180924215655.3676-1-krisman@collabora.co.uk>
References: <20180924215655.3676-1-krisman@collabora.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch implements two new mount options for ext4: encoding and
encoding_flags.

The encoding option receives a string that identifies the NLS encoding
to be used when mounting the filesystem.  The user can optionally ask
for a specific version by appending the version string after a dash.

The encoding_flags argument allows the user to specify how the NLS
charset must behave.  The exact behavior of the flags are defined at
ext4.h.

encoding_flags is ignored if the user didn't provide an encoding.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/super.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ccf4742fea3b..f70c947c9850 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1409,6 +1409,7 @@ enum {
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
 	Opt_max_dir_size_kb, Opt_nojournal_checksum, Opt_nombcache,
+	Opt_encoding, Opt_encoding_flags
 };
 
 static const match_table_t tokens = {
@@ -1493,6 +1494,8 @@ static const match_table_t tokens = {
 	{Opt_noinit_itable, "noinit_itable"},
 	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
 	{Opt_test_dummy_encryption, "test_dummy_encryption"},
+	{Opt_encoding, "encoding=%s"},
+	{Opt_encoding_flags, "encoding_flags=%u"},
 	{Opt_nombcache, "nombcache"},
 	{Opt_nombcache, "no_mbcache"},	/* for backward compatibility */
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
@@ -1705,6 +1708,8 @@ static const struct mount_opts {
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
 	{Opt_test_dummy_encryption, 0, MOPT_GTE0},
 	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET},
+	{Opt_encoding, 0, MOPT_EXT4_ONLY | MOPT_STRING},
+	{Opt_encoding_flags, 0, MOPT_EXT4_ONLY},
 	{Opt_err, 0, 0}
 };
 
@@ -1731,6 +1736,27 @@ ext4_sb_read_encoding(const struct ext4_super_block *es,
 
 	return 0;
 }
+
+static struct ext4_sb_encodings *ext4_parse_encoding_opt(char *arg)
+{
+	char *split;
+	struct ext4_sb_encodings *info;
+	ssize_t len = strlen(arg) + 1;
+
+	info = kzalloc(sizeof(struct ext4_sb_encodings) + len, GFP_KERNEL);
+	if (!info)
+		return NULL;
+
+	info->name = ((char*) &info[1]);
+	strncpy(info->name, arg, len);
+
+	split = strchr(info->name, '-');
+	if (split && *(split+1)) {
+		*split = '\0';
+		info->version = split+1;
+	}
+	return info;
+}
 #endif
 
 static int handle_mount_opt(struct super_block *sb, char *opt, int token,
@@ -1965,6 +1991,42 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		sbi->s_mount_opt |= m->mount_opt;
 	} else if (token == Opt_data_err_ignore) {
 		sbi->s_mount_opt &= ~m->mount_opt;
+	} else if (token == Opt_encoding) {
+		int ret = -1;
+#ifdef CONFIG_NLS
+		char *encoding = match_strdup(&args[0]);
+
+		if (!encoding)
+			return -ENOMEM;
+
+		if (ext4_has_feature_encrypt(sb)) {
+			ext4_msg(sb, KERN_ERR,
+				 "Can't mount with both encoding and encryption");
+			goto encoding_out;
+		}
+
+		sbi->encoding_info = ext4_parse_encoding_opt(encoding);
+		if (!sbi->encoding_info) {
+			ext4_msg(sb, KERN_ERR,
+				 "Encoding %s not supported by ext4", encoding);
+			goto encoding_out;
+		}
+
+		ret = 0;
+encoding_out:
+		kfree(encoding);
+#else
+		ext4_msg(sb, KERN_INFO, "encoding option not supported");
+#endif
+		return ret;
+	} else if (token == Opt_encoding_flags) {
+#ifdef CONFIG_NLS
+		sbi->encoding_flags = arg;
+		return 0;
+#else
+		ext4_msg(sb, KERN_INFO, "encoding flags option not supported");
+		return -1;
+#endif
 	} else {
 		if (!args->from)
 			arg = 1;
@@ -2051,6 +2113,35 @@ static int parse_options(char *options, struct super_block *sb,
 			return 0;
 		}
 	}
+
+#ifdef CONFIG_NLS
+	if (sbi->encoding_info) {
+		sbi->encoding = load_nls_version(sbi->encoding_info->name,
+						 sbi->encoding_info->version,
+						 sbi->encoding_flags);
+		if (IS_ERR(sbi->encoding)) {
+			ext4_msg(sb, KERN_ERR,
+				 "Cannot load encoding: %s %s with flags 0x%hx",
+				 sbi->encoding_info->name,
+				 sbi->encoding_info->version?:"\b",
+				 sbi->encoding_flags & EXT4_ENC_NLS_FL_MASK);
+
+			sbi->encoding = NULL;
+			sbi->encoding_flags = 0;
+			kfree(sbi->encoding_info);
+
+			return 0;
+		}
+		ext4_msg(sb, KERN_INFO,"Using encoding defined by mount option: "
+			 "%s %s with flags 0x%hx", sbi->encoding_info->name,
+			 sbi->encoding_info->version?:"\b", sbi->encoding_flags);
+	} else {
+		/* Make sure the flags are zeroed if the the user didn't
+		   provide the encoding name. */
+		sbi->encoding_flags = 0;
+	}
+
+#endif
 	return 1;
 }
 
-- 
2.19.0
