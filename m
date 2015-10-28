From: Li Xi <pkuelelixi@gmail.com>
Subject: [v1 3/4] Add project feature
Date: Thu, 29 Oct 2015 00:42:12 +0900
Message-ID: <1446046933-26571-4-git-send-email-lixi@ddn.com>
References: <1446046933-26571-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35539 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966178AbbJ1Pm3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Oct 2015 11:42:29 -0400
Received: by pasz6 with SMTP id z6so10450905pas.2
        for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2015 08:42:29 -0700 (PDT)
In-Reply-To: <1446046933-26571-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch add project feature EXT4_FEATURE_RO_COMPAT_PROJECT.

Signed-off-by: Li Xi <lixi@ddn.com>
Change-Id: I14e2bcd23d538ae08677f14c9030a2d7f6612986
---
 lib/e2p/feature.c    |    2 ++
 lib/ext2fs/ext2_fs.h |    1 +
 lib/ext2fs/ext2fs.h  |    3 ++-
 misc/ext4.5.in       |    5 +++++
 misc/mke2fs.c        |    3 ++-
 misc/tune2fs.c       |    3 ++-
 6 files changed, 14 insertions(+), 3 deletions(-)

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
index a5f4124..036e6ad 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -795,6 +795,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 #define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
 #define EXT4_FEATURE_RO_COMPAT_READONLY		0x1000
+#define EXT4_FEATURE_RO_COMPAT_PROJECT		0x2000 /* Project quota */
 
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 86d860f..4af33fc 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -591,7 +591,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
 					 EXT4_FEATURE_RO_COMPAT_QUOTA|\
 					 EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_READONLY)
+					 EXT4_FEATURE_RO_COMPAT_READONLY|\
+					 EXT4_FEATURE_RO_COMPAT_PROJECT)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 9a77243..be8ad07 100644
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
index 97aa8c4..50be807 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1091,7 +1091,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
 		EXT4_FEATURE_RO_COMPAT_BIGALLOC|
 		EXT4_FEATURE_RO_COMPAT_QUOTA|
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
+		EXT4_FEATURE_RO_COMPAT_PROJECT
 };
 
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 94e962c..2c9d0db 100644
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

