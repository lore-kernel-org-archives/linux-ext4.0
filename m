From: akpm@linux-foundation.org
Subject: + ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch added to -mm tree
Date: Sat, 06 Dec 2008 22:18:18 -0800
Message-ID: <200812070618.mB76IIlW017010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: don't inherit inappropriate inode flags from parent
has been added to the -mm tree.  Its filename is
     ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: don't inherit inappropriate inode flags from parent
From: "Duane Griffin" <duaneg@dghda.com>

At present INDEX is the only flag that new ext3 inodes do NOT inherit from
their parent.  In addition prevent the flags DIRTY, ECOMPR, IMAGIC and
TOPDIR from being inherited.  List inheritable flags explicitly to prevent
future flags from accidentally being inherited.

This fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/ialloc.c        |    2 +-
 include/linux/ext3_fs.h |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

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
@@ -178,6 +178,13 @@ struct ext3_group_desc
 #define EXT3_FL_USER_VISIBLE		0x0003DFFF /* User visible flags */
 #define EXT3_FL_USER_MODIFIABLE		0x000380FF /* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT3_FL_INHERITED (EXT3_SECRM_FL | EXT3_UNRM_FL | EXT3_COMPR_FL |\
+			   EXT3_SYNC_FL | EXT3_IMMUTABLE_FL | EXT3_APPEND_FL |\
+			   EXT3_NODUMP_FL | EXT3_NOATIME_FL | EXT3_COMPRBLK_FL|\
+			   EXT3_NOCOMPR_FL | EXT3_JOURNAL_DATA_FL |\
+			   EXT3_NOTAIL_FL | EXT3_DIRSYNC_FL)
+
 /*
  * Inode dynamic state flags
  */
_

Patches currently in -mm which might be from duaneg@dghda.com are

ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext2-tighten-restrictions-on-inode-flags.patch
ext3-tighten-restrictions-on-inode-flags.patch
ext4-tighten-restrictions-on-inode-flags.patch

