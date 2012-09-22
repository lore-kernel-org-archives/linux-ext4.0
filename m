From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 15/21 v5] tune2fs: add inline_data feature in tune2fs
Date: Sat, 22 Sep 2012 12:01:03 +0800
Message-ID: <1348286469-31690-16-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab2IVDv0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:26 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873873pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:26 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Inline_data feature can be set when ext_attr feature is enabled.  Now this
feature only can be enabled because we may be out of space when disabling
it.  If this feature is disabled, we need to allocate a block for every
file and directory, and it might exhaust all space.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/tune2fs.8.in |    5 +++++
 misc/tune2fs.c    |   17 ++++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 55c6dd9..b768fff 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -531,6 +531,11 @@ Setting the filesystem feature is equivalent to using the
 .B \-j
 option.
 .TP
+.B inline_data
+Allow data to be stored in inode.
+.B Tune2fs
+only supports setting this filesystem feature.
+.TP
 .B large_file
 Filesystem can contain files that are greater than 2GB.  (Modern kernels
 set this feature automatically when a file > 2GB is created.)
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index b290c46..e9a0e85 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -137,7 +137,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -992,6 +993,20 @@ mmp_error:
 		disable_uninit_bg(fs,
 				EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
+		       EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+		/* Inline_data feature cannot be enabled if ext_attr is
+		 * disabled.
+		 */
+		if (!(fs->super->s_feature_compat &
+		      EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+			fputs(_("The inline_data feature cannot "
+				"be set if ext_attr feature is disabled.\n"),
+				stderr);
+			return 1;
+		}
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 		/*
-- 
1.7.4.1

