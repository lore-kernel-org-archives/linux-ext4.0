From: Tony Breeds <tony@bakeyournoodle.com>
Subject: [PATCH 1/2] ext2fs.h: Chnage the way EXT2_LIB_FEATURE_INCOMPAT_SUPP deals with optional features.
Date: Tue, 26 Jun 2012 11:42:14 +1000
Message-ID: <1340674935-1503-1-git-send-email-tony@bakeyournoodle.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:35348 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757862Ab2FZBmW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 21:42:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently EXT2_LIB_FEATURE_INCOMPAT_SUPP is #defined twice once with
EXT2_FEATURE_INCOMPAT_COMPRESSION and once without depending on the
state of ENABLE_COMPRESSION

Change this to use an intermediate symbol so that the definition of
EXT2_LIB_FEATURE_INCOMPAT_SUPP doesn't change as other optional fetures
are added.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 lib/ext2fs/ext2fs.h |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ff088bb..7be148e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -554,17 +554,13 @@ typedef struct ext2_icount *ext2_icount_t;
    environment at configure time. */
  #warning "Compression support is experimental"
 #endif
-#define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
-					 EXT2_FEATURE_INCOMPAT_COMPRESSION|\
-					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
-					 EXT2_FEATURE_INCOMPAT_META_BG|\
-					 EXT3_FEATURE_INCOMPAT_RECOVER|\
-					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
-					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+#define EXT2_LIB_INCOMPAT_COMPRESSION	EXT2_FEATURE_INCOMPAT_COMPRESSION
 #else
+#define EXT2_LIB_INCOMPAT_COMPRESSION	(0)
+#endif
+
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
+					 EXT2_LIB_INCOMPAT_COMPRESSION|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
@@ -572,7 +568,6 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
-#endif
 #ifdef CONFIG_QUOTA
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
-- 
1.7.7.6

