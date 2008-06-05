From: akpm@linux-foundation.org
Subject: - ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch removed from -mm tree
Date: Wed, 04 Jun 2008 22:36:43 -0700
Message-ID: <200806050536.m555ah35027639@imap1.linux-foundation.org>
To: duaneg@dghda.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751808AbYFEFgr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 01:36:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: don't inherit inappropriate inode flags from parent
has been removed from the -mm tree.  Its filename was
     ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: don't inherit inappropriate inode flags from parent
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

At present INDEX and EXTENTS are the only flagis that new ext4 inodes do
NOT inherit from their parent. In addition prevent the flags DIRTY, ECOMPR,
IMAGIC, TOPDIR and HUGE_FILE from being inherited.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h   |    5 +++++
 fs/ext4/ialloc.c |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/ext4/ext4.h~ext4-dont-inherit-inappropriate-inode-flags-from-parent fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~ext4-dont-inherit-inappropriate-inode-flags-from-parent
+++ a/fs/ext4/ext4.h
@@ -249,6 +249,11 @@ struct flex_groups {
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT4_FL_INHERITED ~(EXT4_DIRTY_FL | EXT4_ECOMPR_FL | EXT4_INDEX_FL |\
+			    EXT4_IMAGIC_FL | EXT4_TOPDIR_FL |\
+			    EXT4_HUGE_FILE_FL | EXT4_EXTENTS_FL)
+
 /*
  * Inode dynamic state flags
  */
diff -puN fs/ext4/ialloc.c~ext4-dont-inherit-inappropriate-inode-flags-from-parent fs/ext4/ialloc.c
--- a/fs/ext4/ialloc.c~ext4-dont-inherit-inappropriate-inode-flags-from-parent
+++ a/fs/ext4/ialloc.c
@@ -798,7 +798,7 @@ got:
 	 * newly created directory and file only if -o extent mount option is
 	 * specified
 	 */
-	ei->i_flags = EXT4_I(dir)->i_flags & ~(EXT4_INDEX_FL|EXT4_EXTENTS_FL);
+	ei->i_flags = EXT4_I(dir)->i_flags & EXT4_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
 	/* dirsync only applies to directories */
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch

