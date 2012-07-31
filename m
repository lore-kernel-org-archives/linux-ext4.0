From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 36/36 v4] tune2fs: set inline_data feature
Date: Tue, 31 Jul 2012 19:48:29 +0800
Message-ID: <1343735309-30579-37-git-send-email-wenqing.lz@taobao.com>
References: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53943 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2GaLkx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 07:40:53 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so11540999pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 04:40:53 -0700 (PDT)
In-Reply-To: <1343735309-30579-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now inline_data feature can be set when ext_attr feature enabled.  Currently we
cannot clear this feature in tune2fs because we need to allocate some blocks for
inode which contains inline data, and it may exhaust all of disk space.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/tune2fs.8.in |    5 +++++
 misc/tune2fs.c    |   15 ++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index e77dde7..c10696a 100644
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
index 6a48009..1ee6a65 100644
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
@@ -991,6 +992,18 @@ mmp_error:
 		disable_uninit_bg(fs,
 				EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
+			EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+		/* We cannot be enable inline_data when ext_attr disabled */
+		if (!(fs->super->s_feature_compat &
+		      EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+			fputs(_("The inline data feature can't "
+				"be set if the extend attribute feature "
+				"disabled.\n"), stderr);
+			return 1;
+		}
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
 		/*
-- 
1.7.4.1

