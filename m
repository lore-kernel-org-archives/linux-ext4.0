From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 21/30] mke2fs: add inline_data support in mke2fs
Date: Fri,  6 Dec 2013 17:58:08 +0800
Message-ID: <1386323897-2354-22-git-send-email-wenqing.lz@taobao.com>
References: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45852 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab3LFJ4O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Dec 2013 04:56:14 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so747497pdj.18
        for <linux-ext4@vger.kernel.org>; Fri, 06 Dec 2013 01:56:14 -0800 (PST)
In-Reply-To: <1386323897-2354-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Now inline_data doesn't depend on ext_attr.  Hence we don't need to do
this sanity check.  But if the inode size is too small (128 bytes),
inline_data will be useless because we couldn't save data in ibody
extented attribute.  So we need to report this error.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 misc/mke2fs.8.in |    3 +++
 misc/mke2fs.c    |   18 ++++++++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 7b89296..7b40d31 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -587,6 +587,9 @@ option).
 @JDEV@must be created with the same
 @JDEV@block size as the filesystems that will be using it.
 .TP
+.B inline_data
+Allow data to be stored in the inode and extended attribute area
+.TP
 .B large_file
 Filesystem can contain files that are greater than 2GB.  (Modern kernels
 set this feature automatically when a file > 2GB is created.)
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 67c9225..fbe1d03 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -929,7 +929,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
 		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_64BIT,
+		EXT4_FEATURE_INCOMPAT_64BIT|
+		EXT4_FEATURE_INCOMPAT_INLINE_DATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -2069,7 +2070,8 @@ profile_error:
 				  "See https://ext4.wiki.kernel.org/"
 				  "index.php/Quota for more information\n\n"));
 
-	/* Since sparse_super is the default, we would only have a problem
+	/*
+	 * Since sparse_super is the default, we would only have a problem
 	 * here if it was explicitly disabled.
 	 */
 	if ((fs_param.s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
@@ -2125,6 +2127,18 @@ profile_error:
 				blocksize);
 			exit(1);
 		}
+		/*
+		 * If inode size is 128 and inline data is enabled, we need
+		 * to notify users that inline data will never be useful.
+		 */
+		if ((fs_param.s_feature_incompat &
+		     EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+		    inode_size == EXT2_GOOD_OLD_INODE_SIZE) {
+			com_err(program_name, 0,
+				_("inode size is %d, inline data is useless"),
+				inode_size);
+			exit(1);
+		}
 		fs_param.s_inode_size = inode_size;
 	}
 
-- 
1.7.9.7

