From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 2/3] ext3: don't inherit inappropriate inode flags from parent
Date: Wed,  4 Jun 2008 13:46:27 +0100
Message-ID: <1212583588-5754-3-git-send-email-duaneg@dghda.com>
References: <1212583588-5754-1-git-send-email-duaneg@dghda.com>
 <1212583588-5754-2-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1384 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYFDMq6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2008 08:46:58 -0400
In-Reply-To: <1212583588-5754-2-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At present INDEX is the only flag that new ext3 inodes do NOT inherit from
their parent. In addition prevent the flags DIRTY, ECOMPR, IMAGIC and
TOPDIR from being inherited.

Signed-off-by: Duane Griffin <duaneg@dghda.com>

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 7712682..1d9fe3f 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -559,7 +559,7 @@ got:
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
 
-	ei->i_flags = EXT3_I(dir)->i_flags & ~EXT3_INDEX_FL;
+	ei->i_flags = EXT3_I(dir)->i_flags & EXT3_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT3_IMMUTABLE_FL|EXT3_APPEND_FL);
 	/* dirsync only applies to directories */
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 36c5403..4f7224a 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -178,6 +178,10 @@ struct ext3_group_desc
 #define EXT3_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
 #define EXT3_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT3_FL_INHERITED ~(EXT3_DIRTY_FL | EXT3_ECOMPR_FL | EXT3_INDEX_FL |\
+			    EXT3_IMAGIC_FL | EXT3_TOPDIR_FL)
+
 /*
  * Inode dynamic state flags
  */
-- 
1.5.3.7

