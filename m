From: akpm@linux-foundation.org
Subject: - ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch removed from -mm tree
Date: Wed, 04 Jun 2008 22:36:41 -0700
Message-ID: <200806050536.m555afoJ027636@imap1.linux-foundation.org>
To: duaneg@dghda.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbYFEFgp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 01:36:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: don't inherit inappropriate inode flags from parent
has been removed from the -mm tree.  Its filename was
     ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: don't inherit inappropriate inode flags from parent
From: "Duane Griffin" <duaneg@dghda.com>

Fix the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

  Some file attributes have sticky behaviour in ext2/3 whereas I believe
  it should not.  Namely, a directory marked with chattr +T serves "to be
  the top of directory hierarchies for the purposes of the Orlov block
  allocator", as the manpage says.

  It seems wrong that subdirectories stickily inherit the +T flag: they
  are obviously not top-level!  Even files get the T attribute this way,
  even though the chattr manpages only documents it for directories.

Also prevent inheritance of other flags that Andreas Dilger identified as
inappropriate to inherit

At present INDEX is the only flag that new ext3 inodes do NOT inherit from
their parent. In addition prevent the flags DIRTY, ECOMPR, IMAGIC and
TOPDIR from being inherited.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/ialloc.c        |    2 +-
 include/linux/ext3_fs.h |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/ext3/ialloc.c~ext3-dont-inherit-inappropriate-inode-flags-from-parent fs/ext3/ialloc.c
--- a/fs/ext3/ialloc.c~ext3-dont-inherit-inappropriate-inode-flags-from-parent
+++ a/fs/ext3/ialloc.c
@@ -559,7 +559,7 @@ got:
 	ei->i_dir_start_lookup = 0;
 	ei->i_disksize = 0;
 
-	ei->i_flags = EXT3_I(dir)->i_flags & ~EXT3_INDEX_FL;
+	ei->i_flags = EXT3_I(dir)->i_flags & EXT3_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT3_IMMUTABLE_FL|EXT3_APPEND_FL);
 	/* dirsync only applies to directories */
diff -puN include/linux/ext3_fs.h~ext3-dont-inherit-inappropriate-inode-flags-from-parent include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~ext3-dont-inherit-inappropriate-inode-flags-from-parent
+++ a/include/linux/ext3_fs.h
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
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch
ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch

