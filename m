From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 3/3] mke2fs: Add extended option to select quota type
Date: Thu,  3 Nov 2011 17:18:33 -0700
Message-ID: <1320365913-25857-3-git-send-email-adityakali@google.com>
References: <1320365913-25857-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: adilger@dilger.ca, tytso.mit.edu@google.com, niu@whamcloud.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:43147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab1KDASt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2011 20:18:49 -0400
In-Reply-To: <1320365913-25857-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mke2fs was creating both user and group quota inodes on enabling
the quota feature. This patch adds the extended option 'quotatype'
that can be used to exclusively specify the quota type that the
user wants to initialize.

 # Ex: Default behavior without extended option creates both
 # user and group quota inodes:
 $ mke2fs -t ext4 -O quota /dev/ram1

 # To enable only user quotas:
 $ mke2fs -t ext4 -O quota -E quotatype=usr /dev/ram1
 # To enable only group quotas:
 $ mke2fs -t ext4 -O quota -E quotatype=grp /dev/ram1

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 misc/mke2fs.8.in |    7 +++++++
 misc/mke2fs.c    |   24 +++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index e249c6b..8e78249 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -266,6 +266,13 @@ as default.
 .TP
 .BI nodiscard
 Do not attempt to discard blocks at mkfs time.
+.TP
+.BI quotatype
+Specify which quota type ('usr' or 'grp') is to be initialized. This
+option has any effect only if
+.B quota
+feature is set. Without this extended option, the default behavior is to
+initialize both user and group quotas.
 .RE
 .TP
 .BI \-f " fragment-size"
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 04b0189..a96c6d5 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -95,6 +95,7 @@ int	journal_flags;
 int	lazy_itable_init;
 char	*bad_blocks_filename;
 __u32	fs_stride;
+int	quotatype = -1;  /* Initialize both user and group quotas by default */
 
 struct ext2_super_block fs_param;
 char *fs_uuid = NULL;
@@ -793,6 +794,23 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			discard = 1;
 		} else if (!strcmp(token, "nodiscard")) {
 			discard = 0;
+		} else if (!strcmp(token, "quotatype")) {
+			if (!arg) {
+				r_usage++;
+				badopt = token;
+				continue;
+			}
+			if (!strncmp(arg, "usr", 3)) {
+				quotatype = 0;
+			} else if (!strncmp(arg, "grp", 3)) {
+				quotatype = 1;
+			} else {
+				fprintf(stderr,
+					_("Invalid quotatype parameter: %s\n"),
+					arg);
+				r_usage++;
+				continue;
+			}
 		} else {
 			r_usage++;
 			badopt = token;
@@ -811,7 +829,8 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\tlazy_journal_init=<0 to disable, 1 to enable>\n"
 			"\ttest_fs\n"
 			"\tdiscard\n"
-			"\tnodiscard\n\n"),
+			"\tnodiscard\n"
+			"\tquotatype=<usr OR grp>\n\n"),
 			badopt ? badopt : "");
 		free(buf);
 		exit(1);
@@ -2183,8 +2202,7 @@ static int create_quota_inodes(ext2_filsys fs)
 
 	quota_init_context(&qctx, fs, -1);
 	quota_compute_usage(qctx);
-	quota_write_inode(qctx, USRQUOTA);
-	quota_write_inode(qctx, GRPQUOTA);
+	quota_write_inode(qctx, quotatype);
 	quota_release_context(&qctx);
 
 	return 0;
-- 
1.7.3.1

