From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH 1/6] ext2: don't inherit inappropriate inode flags from parent
Date: Wed, 11 Jun 2008 01:04:04 +0100
Message-ID: <1213142649-32685-2-git-send-email-duaneg@dghda.com>
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:3316 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755676AbYFKAEO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jun 2008 20:04:14 -0400
In-Reply-To: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At present BTREE/INDEX is the only flag that new ext2 inodes do NOT
inherit from their parent. In addition prevent the flags DIRTY, ECOMPR,
INDEX, IMAGIC and TOPDIR from being inherited. List inheritable flags
explicitly to prevent future flags from accidentally being inherited.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
--

This is v2 with inheritable flags now explicitly specified, as per Andreas'
request. The BTREE flag has also been removed as it is just an alias for
INDEX, as also pointed out by Andreas.

---
 fs/ext2/ialloc.c        |    2 +-
 include/linux/ext2_fs.h |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index f597413..a51d4ca 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -565,7 +565,7 @@ got:
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	memset(ei->i_data, 0, sizeof(ei->i_data));
-	ei->i_flags = EXT2_I(dir)->i_flags & ~EXT2_BTREE_FL;
+	ei->i_flags = EXT2_I(dir)->i_flags & EXT2_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT2_IMMUTABLE_FL|EXT2_APPEND_FL);
 	/* dirsync is only applied to directories */
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 84cec2a..7ead7eb 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -194,6 +194,13 @@ struct ext2_group_desc
 #define EXT2_FL_USER_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
 #define EXT2_FL_USER_MODIFIABLE		FS_FL_USER_MODIFIABLE	/* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT2_FL_INHERITED (EXT2_SECRM_FL | EXT2_UNRM_FL | EXT2_COMPR_FL |\
+			   EXT2_SYNC_FL | EXT2_IMMUTABLE_FL | EXT2_APPEND_FL |\
+			   EXT2_NODUMP_FL | EXT2_NOATIME_FL | EXT2_COMPRBLK_FL|\
+			   EXT2_NOCOMP_FL | EXT2_JOURNAL_DATA_FL |\
+			   EXT2_NOTAIL_FL | EXT2_DIRSYNC_FL)
+
 /*
  * ioctl commands
  */
-- 
1.5.3.7

