From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 14/21 v5] mke2fs: add inline_data support in mke2fs
Date: Sat, 22 Sep 2012 12:01:02 +0800
Message-ID: <1348286469-31690-15-git-send-email-wenqing.lz@taobao.com>
References: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45480 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2IVDvY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Sep 2012 23:51:24 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3873835pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 21 Sep 2012 20:51:24 -0700 (PDT)
In-Reply-To: <1348286469-31690-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Ext_attr feature not enabled, inline_data feature doesn't be specified.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.8.in |    3 +++
 misc/mke2fs.c    |   14 +++++++++++++-
 2 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 6d443a2..bfe6c94 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -551,6 +551,9 @@ option).
 @JDEV@must be created with the same
 @JDEV@block size as the filesystems that will be using it.
 .TP
+.B inline_data
+Allow data to be stored in inode
+.TP
 .B large_file
 Filesystem can contain files that are greater than 2GB.  (Modern kernels
 set this feature automatically when a file > 2GB is created.)
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 072e656..19c23c1 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -883,7 +883,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
 		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_64BIT,
+		EXT4_FEATURE_INCOMPAT_64BIT|
+		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -1956,6 +1957,17 @@ profile_error:
 		exit(1);
 	}
 
+	/* Since inline_data depends on ext_attr, we would ask it to be
+	 * enabled.
+	 */
+	if ((fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+	    !(fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+		com_err(program_name, 0,
+			_("Ext_attr feature not enabled, so inline_data "
+			  "feature doesn't be specified"));
+		exit(1);
+	}
+
 	if (fs_param.s_blocks_per_group) {
 		if (fs_param.s_blocks_per_group < 256 ||
 		    fs_param.s_blocks_per_group > 8 * (unsigned) blocksize) {
-- 
1.7.4.1

