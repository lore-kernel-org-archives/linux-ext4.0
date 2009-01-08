From: akpm@linux-foundation.org
Subject: - ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:46:55 -0800
Message-ID: <200901082246.n08Mkt1E026429@imap1.linux-foundation.org>
To: duaneg@dghda.com, adilger@sun.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbZAHWrb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jan 2009 17:47:31 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext2: don't inherit inappropriate inode flags from parent
has been removed from the -mm tree.  Its filename was
     ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: don't inherit inappropriate inode flags from parent
From: "Duane Griffin" <duaneg@dghda.com>

At present BTREE/INDEX is the only flag that new ext2 inodes do NOT
inherit from their parent.  In addition prevent the flags DIRTY, ECOMPR,
INDEX, IMAGIC and TOPDIR from being inherited.  List inheritable flags
explicitly to prevent future flags from accidentally being inherited.

This fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ialloc.c        |    2 +-
 include/linux/ext2_fs.h |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/ext2/ialloc.c~ext2-dont-inherit-inappropriate-inode-flags-from-parent fs/ext2/ialloc.c
--- a/fs/ext2/ialloc.c~ext2-dont-inherit-inappropriate-inode-flags-from-parent
+++ a/fs/ext2/ialloc.c
@@ -565,7 +565,7 @@ got:
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	memset(ei->i_data, 0, sizeof(ei->i_data));
-	ei->i_flags = EXT2_I(dir)->i_flags & ~EXT2_BTREE_FL;
+	ei->i_flags = EXT2_I(dir)->i_flags & EXT2_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT2_IMMUTABLE_FL|EXT2_APPEND_FL);
 	/* dirsync is only applied to directories */
diff -puN include/linux/ext2_fs.h~ext2-dont-inherit-inappropriate-inode-flags-from-parent include/linux/ext2_fs.h
--- a/include/linux/ext2_fs.h~ext2-dont-inherit-inappropriate-inode-flags-from-parent
+++ a/include/linux/ext2_fs.h
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
_

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-tighten-restrictions-on-inode-flags.patch

