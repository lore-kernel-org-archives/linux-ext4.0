Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45992 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbeKUKeJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 05:34:09 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH v2 2/8] mke2fs: Configure encoding during superblock initialization
Date: Tue, 20 Nov 2018 19:02:00 -0500
Message-Id: <20181121000206.15496-3-krisman@collabora.com>
In-Reply-To: <20181121000206.15496-1-krisman@collabora.com>
References: <20181121000206.15496-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

This patch implements two new extended options to mkefs, allowing the
user to specify an encoding for file name operations and encoding flags
during filesystem creation.  We provide default flags for each encoding,
which the user can overwrite by passing -E encoding-flags to mkfs.
---
 lib/ext2fs/initialize.c |  4 ++++
 misc/mke2fs.c           | 42 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 8c9e97fee831..30b1ae033340 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -186,6 +186,10 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_flags, 0);
 	assign_field(s_backup_bgs[0]);
 	assign_field(s_backup_bgs[1]);
+
+	assign_field(s_encoding);
+	assign_field(s_encoding_flags);
+
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index f05003fc30b9..df2f8b1cc26f 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -790,6 +790,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 	int	len;
 	int	r_usage = 0;
 	int	ret;
+	int	encoding = -1;
+	char 	*encoding_flags = NULL;
 
 	len = strlen(opts);
 	buf = malloc(len+1);
@@ -1056,6 +1058,26 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			}
 		} else if (!strcmp(token, "android_sparse")) {
 			android_sparse_file = 1;
+		} else if (!strcmp(token, "encoding")) {
+			if (!arg) {
+				r_usage++;
+				continue;
+			}
+
+			encoding = e2p_str2encoding(arg);
+			if (encoding < 0) {
+				fprintf(stderr, _("Invalid encoding: %s"), arg);
+				r_usage++;
+				continue;
+			}
+			param->s_encoding = encoding;
+			ext2fs_set_feature_fname_encoding(param);
+		} else if (!strcmp(token, "encoding-flags")) {
+			if (!arg) {
+				r_usage++;
+				continue;
+			}
+			encoding_flags = arg;
 		} else {
 			r_usage++;
 			badopt = token;
@@ -1080,6 +1102,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\ttest_fs\n"
 			"\tdiscard\n"
 			"\tnodiscard\n"
+			"\tencoding=<encoding>\n"
+			"\tencoding-flags=<flags>\n"
 			"\tquotatype=<quota type(s) to be enabled>\n\n"),
 			badopt ? badopt : "");
 		free(buf);
@@ -1091,6 +1115,23 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				  "multiple of stride %u.\n\n"),
 			param->s_raid_stripe_width, param->s_raid_stride);
 
+	if (ext2fs_has_feature_fname_encoding(param)) {
+		param->s_encoding_flags = e2p_get_encoding_flags(encoding);
+		if (encoding_flags &&
+		    e2p_str2encoding_flags(encoding, encoding_flags,
+					   &param->s_encoding_flags)) {
+			fprintf(stderr, _("error: Invalid encoding flag: %s\n"),
+				encoding_flags);
+			free(buf);
+			exit(1);
+		}
+	} else if (encoding_flags) {
+		fprintf(stderr, _("error: An encoding must be explicitely "
+				  "specified when passing encoding-flags\n"));
+		free(buf);
+		exit(1);
+	}
+
 	free(buf);
 }
 
@@ -1112,6 +1153,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_64BIT|
 		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
+		EXT4_FEATURE_INCOMPAT_FNAME_ENCODING |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
 		EXT4_FEATURE_INCOMPAT_LARGEDIR,
 	/* R/O compat */
-- 
2.19.1
