From: akpm@linux-foundation.org
Subject: + ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch added to -mm tree
Date: Wed, 04 Jun 2008 21:37:52 -0700
Message-ID: <200806050437.m554bqsc025546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: don't inherit inappropriate inode flags from parent
has been added to the -mm tree.  Its filename is
     ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: don't inherit inappropriate inode flags from parent
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

At present BTREE is the only flag that new ext2 inodes do NOT inherit from
their parent.  In addition prevent the flags DIRTY, ECOMPR, INDEX, IMAGIC
and TOPDIR from being inherited.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ialloc.c        |    2 +-
 include/linux/ext2_fs.h |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

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
@@ -194,6 +194,10 @@ struct ext2_group_desc
 #define EXT2_FL_USER_VISIBLE		FS_FL_USER_VISIBLE	/* User visible flags */
 #define EXT2_FL_USER_MODIFIABLE		FS_FL_USER_MODIFIABLE	/* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT2_FL_INHERITED ~(EXT2_DIRTY_FL | EXT2_ECOMPR_FL | EXT2_BTREE_FL |\
+			    EXT2_INDEX_FL | EXT2_IMAGIC_FL | EXT2_TOPDIR_FL)
+
 /*
  * ioctl commands
  */
_

Patches currently in -mm which might be from duaneg@dghda.com are

jbd-replace-potentially-false-assertion-with-if-block.patch
jbd-eliminate-duplicated-code-in-revocation-table-init-destroy-functions.patch
jbd-tidy-up-revoke-cache-initialisation-and-destruction.patch
ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch

