Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46984 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbeLDVQO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 16:16:14 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, kernel@collabora.com,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH] e2p: Print encoding information in superblock dump
Date: Tue,  4 Dec 2018 16:16:09 -0500
Message-Id: <20181204211609.27477-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Display encoding related fields when printing superblock in places like
dumpe2fs or debugfs.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 lib/e2p/e2p.h      |  1 +
 lib/e2p/encoding.c | 10 ++++++++++
 lib/e2p/ls.c       | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/lib/e2p/e2p.h b/lib/e2p/e2p.h
index cc2dbf39bfeb..f4cf2d611f2c 100644
--- a/lib/e2p/e2p.h
+++ b/lib/e2p/e2p.h
@@ -84,3 +84,4 @@ int e2p_string2encmode(char *string);
 int e2p_str2encoding(const char *string);
 int e2p_get_encoding_flags(int encoding);
 int e2p_str2encoding_flags(int encoding, char *param, __u16 *flags);
+char *e2p_encoding2string(int encoding);
diff --git a/lib/e2p/encoding.c b/lib/e2p/encoding.c
index 88433310a1dd..6edc41a78964 100644
--- a/lib/e2p/encoding.c
+++ b/lib/e2p/encoding.c
@@ -61,6 +61,16 @@ int e2p_str2encoding(const char *string)
 	return -EINVAL;
 }
 
+char *e2p_encoding2string(int encoding)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ext4_encoding_map); i++)
+		if (ext4_encoding_map[i].encoding_magic == encoding)
+			return ext4_encoding_map[i].name;
+	return NULL;
+}
+
 int e2p_get_encoding_flags(int encoding)
 {
 	int i;
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index a7586e094da1..bb1fc8aa94da 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -142,6 +142,36 @@ static void print_mntopts(struct ext2_super_block * s, FILE *f)
 #endif
 }
 
+static void print_encoding_flags(int encoding, __u16 flags, FILE *f)
+{
+	int flags_found = 0;
+
+	fputs("Filename encoding flags: ", f);
+	if (flags & EXT4_ENC_STRICT_MODE_FL) {
+		fputs(" strict", f);
+		flags_found++;
+	}
+
+	if (encoding == EXT4_ENC_UTF8_11_0) {
+		if (flags & EXT4_UTF8_NORMALIZATION_TYPE_NFKD)
+			fputs(" NFKD", f);
+		else
+			fputs(" Unnormalized", f);
+		flags_found++;
+
+		if (flags & EXT4_UTF8_CASEFOLD_TYPE_NFKDCF)
+			fputs(" NFKDCF", f);
+		else
+			fputs(" toUpper", f);
+		flags_found++;
+	}
+
+	if (flags_found)
+		fputs("\n", f);
+	else
+		fputs(" (none)\n", f);
+}
+
 static void print_super_flags(struct ext2_super_block * s, FILE *f)
 {
 	int	flags_found = 0;
@@ -457,6 +487,20 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 				*quota_sb_inump(sb, qtype));
 	}
 
+	if (ext2fs_has_feature_fname_encoding(sb)) {
+		str = e2p_encoding2string(sb->s_encoding);
+		if (str) {
+			fprintf(f, "Filename encoding:        %s\n", str);
+			print_encoding_flags(sb->s_encoding,
+					     sb->s_encoding_flags, f);
+		} else {
+			fprintf(f, "Filename encoding:        Unknown (%hu)\n",
+				sb->s_encoding);
+			fprintf(f, "Filename encoding flags:  0x%hX\n",
+				sb->s_encoding_flags);
+		}
+	}
+
 	if (ext2fs_has_feature_metadata_csum(sb)) {
 		fprintf(f, "Checksum type:            %s\n",
 			checksum_type(sb->s_checksum_type));
-- 
2.20.0.rc2
