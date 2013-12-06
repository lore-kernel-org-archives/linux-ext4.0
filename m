From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 09/30] libext2fs: check inline_data in ext2fs_xattrs_read/write
Date: Fri,  6 Dec 2013 17:57:56 +0800
Message-ID: <1386323897-2354-10-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39230 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab3LFJzo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:55:44 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so746933pdj.18
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:55:44 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now on kernel side we can enable inline data even without ext_attr.  So
we need to adjust sanity check on ext2fs_xattrs_read/write to let we
access extended attribute when filesystem is create with '-O ^ext_attr,
inline_data'.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 lib/ext2fs/ext_attr.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 09e13b2..e5e0fa9 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -469,9 +469,17 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	unsigned int i;
 	errcode_t err;
 
-	if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
-				     EXT2_FEATURE_COMPAT_EXT_ATTR))
-		return 0;
+	/*
+	 * If inline_data is enabled, we don't check ext_attr because
+	 * inline_data needs to read/write extended attribute even
+	 * without ext_attr.
+	 */
+	if (!EXT2_HAS_INCOMPAT_FEATURE(handle->fs->super,
+				       EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+		if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
+					     EXT2_FEATURE_COMPAT_EXT_ATTR))
+			return 0;
+	}
 
 	i = EXT2_INODE_SIZE(handle->fs->super);
 	if (i < sizeof(*inode))
@@ -684,9 +692,17 @@ errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
 	int i;
 	errcode_t err;
 
-	if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
-				     EXT2_FEATURE_COMPAT_EXT_ATTR))
-		return 0;
+	/*
+	 * If inline_data is enabled, we don't check ext_attr because
+	 * inline_data needs to read/write extended attribute even
+	 * without ext_attr.
+	 */
+	if (!EXT2_HAS_INCOMPAT_FEATURE(handle->fs->super,
+				       EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+		if (!EXT2_HAS_COMPAT_FEATURE(handle->fs->super,
+					     EXT2_FEATURE_COMPAT_EXT_ATTR))
+			return 0;
+	}
 
 	i = EXT2_INODE_SIZE(handle->fs->super);
 	if (i < sizeof(*inode))
-- 
1.7.9.7

