From: Li Xi <pkuelelixi@gmail.com>
Subject: [v4 3/6] Add project feature flag EXT4_FEATURE_RO_COMPAT_PROJECT
Date: Sun,  6 Mar 2016 13:14:53 +0900
Message-ID: <1457237696-13770-4-git-send-email-lixi@ddn.com>
References: <1457237696-13770-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35203 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbcCFEPL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 23:15:11 -0500
Received: by mail-pf0-f177.google.com with SMTP id x188so35455505pfb.2
        for <linux-ext4@vger.kernel.org>; Sat, 05 Mar 2016 20:15:11 -0800 (PST)
In-Reply-To: <1457237696-13770-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add project feature flag EXT4_FEATURE_RO_COMPAT_PROJECT.
Project feature is a read-only compat feature. Thus, an ext4 file
system with project feature enabled could only be read by ext4
kernel module without project feature support.

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 lib/e2p/feature.c    |    2 ++
 lib/ext2fs/ext2_fs.h |    2 ++
 lib/ext2fs/ext2fs.h  |    3 ++-
 misc/ext4.5.in       |    5 +++++
 misc/mke2fs.c        |    3 ++-
 misc/tune2fs.c       |    3 ++-
 6 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 737b0b9..17d2ad0 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -70,6 +70,8 @@ static struct feature feature_list[] = {
 			"replica" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_READONLY,
 			"read-only" },
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_PROJECT,
+			"project"},
 
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 1f62c58..4221a6a 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -791,6 +791,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 #define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
 #define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
+#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x2000 /* Project quota */
 
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
@@ -882,6 +883,7 @@ EXT4_FEATURE_RO_COMPAT_FUNCS(bigalloc,		4, BIGALLOC)
 EXT4_FEATURE_RO_COMPAT_FUNCS(metadata_csum,	4, METADATA_CSUM)
 EXT4_FEATURE_RO_COMPAT_FUNCS(replica,		4, REPLICA)
 EXT4_FEATURE_RO_COMPAT_FUNCS(readonly,		4, READONLY)
+EXT4_FEATURE_RO_COMPAT_FUNCS(project,		4, PROJECT)
 
 EXT4_FEATURE_INCOMPAT_FUNCS(compression,	2, COMPRESSION)
 EXT4_FEATURE_INCOMPAT_FUNCS(filetype,		2, FILETYPE)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 30e913c..f6fed2c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -591,7 +591,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
 					 EXT4_FEATURE_RO_COMPAT_QUOTA|\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_READONLY)
+					 EXT4_FEATURE_RO_COMPAT_READONLY |\
+					 EXT4_FEATURE_RO_COMPAT_PROJECT)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index dbd6dde..e892743 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -214,6 +214,11 @@ Causes the quota files (i.e., user.quota and
 group.quota which existed
 in the older quota design) to be hidden inodes.
 .TP
+.B project
+.br
+This ext4 feature provides project quota support. With this feature,
+the project ID of inode will be managed when the filesystem is mounted.
+.TP
 .B resize_inode
 .br
 This file system feature indicates that space has been reserved so
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index d34f625..48f15a5 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1096,7 +1096,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
 		EXT4_FEATURE_RO_COMPAT_BIGALLOC|
 		EXT4_FEATURE_RO_COMPAT_QUOTA|
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
+		EXT4_FEATURE_RO_COMPAT_PROJECT
 };
 
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 3e03797..2fbdf33 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -159,7 +159,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |
 		EXT4_FEATURE_RO_COMPAT_QUOTA |
 		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM |
-		EXT4_FEATURE_RO_COMPAT_READONLY
+		EXT4_FEATURE_RO_COMPAT_READONLY |
+		EXT4_FEATURE_RO_COMPAT_PROJECT
 };
 
 static __u32 clear_ok_features[3] = {
-- 
1.7.1

