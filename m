Return-Path: <SRS0=IALa=OK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:32960 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbeLALvL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 1 Dec 2018 06:51:11 -0500
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: tytso@mit.edu
Cc: kernel@collabora.com, linux-ext4@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v4 2/9] mke2fs: Configure encoding during superblock initialization
Date: Fri, 30 Nov 2018 19:39:03 -0500
Message-Id: <20181201003910.18982-3-krisman@collabora.com>
In-Reply-To: <20181201003910.18982-1-krisman@collabora.com>
References: <20181201003910.18982-1-krisman@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

This patch implements two new extended options to mkefs, allowing the
user to specify an encoding for file name operations and encoding flags
during filesystem creation.  We provide default flags for each encoding,
which the user can overwrite by passing -E fname_encoding-flags to mkfs.

If the user doesn't specify an encoding, the default value from
options.fname_encoding in mke2fs.conf.in file will be used.

Changes since v2:
  - Rename feature encoding -> fname_encoding
  - Add default encoding option to mke2fs.conf.in
  - Fix behavior on -O fname_encoding
  - Prevent use of encrypt and encoding simultaneously

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 lib/e2p/feature.c       |  2 +-
 lib/ext2fs/initialize.c |  4 ++
 misc/mke2fs.8.in        | 25 +++++++++++++
 misc/mke2fs.c           | 81 +++++++++++++++++++++++++++++++++++++++++
 misc/mke2fs.conf.5.in   |  4 ++
 misc/mke2fs.conf.in     |  3 ++
 6 files changed, 118 insertions(+), 1 deletion(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 294a56a40b52..ded87f5611dc 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -110,7 +110,7 @@ static struct feature feature_list[] = {
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_ENCRYPT,
 			"encrypt"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FNAME_ENCODING,
-			"encoding"},
+			"fname_encoding"},
 	{	0, 0, 0 },
 };
 
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
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 603e37e54a78..4a2aa8fd9672 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -280,6 +280,31 @@ option is still accepted for backwards compatibility, but is deprecated.
 The following extended options are supported:
 .RS 1.2i
 .TP
+.BI fname_encoding= encoding-name
+Enable the
+.I fname_encoding
+feature in the super block and set
+.I encoding-name
+as the encoding to be used.  If
+.I encoding-name
+is not specified, the encoding defined in
+.BR mke2fs.conf (5)
+is used.
+.TP
+.BI fname_encoding_flags= encoding-flags
+Define parameters for file name character encoding operations.  If a
+flag is not changed using this parameter, its default value is used.
+.I encoding-flags
+should be a comma-separated lists of flags to be enabled.  To disable a
+flag, add it to the list with the prefix "no".
+
+The only flag that can be set right now is
+.I strict
+which means that invalid strings should be rejected by the file system.
+In the default configuration, the
+.I strict
+flag is disabled.
+.TP
 .BI mmp_update_interval= interval
 Adjust the initial MMP update interval to
 .I interval
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index f05003fc30b9..41f2532bc84f 100644
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
@@ -1056,6 +1058,31 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			}
 		} else if (!strcmp(token, "android_sparse")) {
 			android_sparse_file = 1;
+		} else if (!strcmp(token, "fname_encoding")) {
+			if (!arg) {
+				profile_get_string(profile, "options",
+						   "fname_encoding", 0, 0,
+						   &arg);
+				if (!arg) {
+					r_usage++;
+					continue;
+				}
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
+		} else if (!strcmp(token, "fname_encoding_flags")) {
+			if (!arg) {
+				r_usage++;
+				continue;
+			}
+			encoding_flags = arg;
 		} else {
 			r_usage++;
 			badopt = token;
@@ -1080,6 +1107,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\ttest_fs\n"
 			"\tdiscard\n"
 			"\tnodiscard\n"
+			"\tfname_encoding=<encoding>\n"
+			"\tfname_encoding_flags=<flags>\n"
 			"\tquotatype=<quota type(s) to be enabled>\n\n"),
 			badopt ? badopt : "");
 		free(buf);
@@ -1091,6 +1120,25 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				  "multiple of stride %u.\n\n"),
 			param->s_raid_stripe_width, param->s_raid_stride);
 
+	if (ext2fs_has_feature_fname_encoding(param)) {
+		param->s_encoding_flags =
+			e2p_get_encoding_flags(param->s_encoding);
+
+		if (encoding_flags &&
+		    e2p_str2encoding_flags(param->s_encoding, encoding_flags,
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
 
@@ -1112,6 +1160,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_64BIT|
 		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
+		EXT4_FEATURE_INCOMPAT_FNAME_ENCODING |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
 		EXT4_FEATURE_INCOMPAT_LARGEDIR,
 	/* R/O compat */
@@ -1518,6 +1567,8 @@ static void PRS(int argc, char *argv[])
 	int		use_bsize;
 	char		*newpath;
 	int		pathlen = sizeof(PATH_SET) + 1;
+	char		*encoding_name = NULL;
+	int		encoding;
 
 	if (oldpath)
 		pathlen += strlen(oldpath);
@@ -2026,6 +2077,7 @@ profile_error:
 		ext2fs_clear_feature_huge_file(&fs_param);
 		ext2fs_clear_feature_metadata_csum(&fs_param);
 		ext2fs_clear_feature_ea_inode(&fs_param);
+		ext2fs_clear_feature_fname_encoding(&fs_param);
 	}
 	edit_feature(fs_features ? fs_features : tmp,
 		     &fs_param.s_feature_compat);
@@ -2341,6 +2393,26 @@ profile_error:
 	if (packed_meta_blocks)
 		journal_location = 0;
 
+	if (ext2fs_has_feature_fname_encoding(&fs_param)) {
+		profile_get_string(profile, "options", "fname_encoding",
+				   0, 0, &encoding_name);
+		if (!encoding_name) {
+			com_err(program_name, 0, "%s",
+				_("Filename encoding type must be specified\n"
+				  "Use -E fname_encoding=<name> instead"));
+			exit(1);
+		}
+		encoding = e2p_str2encoding(encoding_name);
+		if (encoding < 0) {
+			com_err(program_name, 0, "%s",
+				_("Unknown default filename encoding\n"
+				  "Use -E fname_encoding=<name> instead"));
+			exit(1);
+		}
+		fs_param.s_encoding = encoding;
+		fs_param.s_encoding_flags = e2p_get_encoding_flags(encoding);
+	}
+
 	/* Get options from profile */
 	for (cpp = fs_types; *cpp; cpp++) {
 		tmp = NULL;
@@ -2385,6 +2457,15 @@ profile_error:
 		}
 	}
 
+	if (ext2fs_has_feature_fname_encoding(&fs_param) &&
+	    ext2fs_has_feature_encrypt(&fs_param)) {
+		com_err(program_name, 0, "%s",
+			_("The encrypt and encoding features are not "
+			  "compatible.\nThey can not be both enabled "
+			  "simultaneously.\n"));
+		      exit (1);
+	}
+
 	/* Don't allow user to set both metadata_csum and uninit_bg bits. */
 	if (ext2fs_has_feature_metadata_csum(&fs_param) &&
 	    ext2fs_has_feature_gdt_csum(&fs_param))
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index c086b4113b50..ab93c7761a16 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -97,6 +97,10 @@ The following relations are defined in the
 .I [options]
 stanza.
 .TP
+.I fname_encoding
+This relation defines the file name encoding to be used by mke2fs, in
+case the user doesn't specify an encoding in the command line.
+.TP
 .I proceed_delay
 If this relation is set to a positive integer, then mke2fs will
 wait
diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
index 01e35cf83150..10819f18c332 100644
--- a/misc/mke2fs.conf.in
+++ b/misc/mke2fs.conf.in
@@ -45,3 +45,6 @@
 	     blocksize = 4096
 	     inode_size = 128
 	}
+
+[options]
+fname_encoding = utf8
-- 
2.20.0.rc1
