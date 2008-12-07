From: akpm@linux-foundation.org
Subject: + ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch added to -mm tree
Date: Sat, 06 Dec 2008 22:18:20 -0800
Message-ID: <200812070618.mB76IKge017086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: duaneg@dghda.com, adilger@sun.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: don't inherit inappropriate inode flags from parent
has been added to the -mm tree.  Its filename is
     ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch

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
Subject: ext4: don't inherit inappropriate inode flags from parent
From: "Duane Griffin" <duaneg@dghda.com>

At present INDEX and EXTENTS are the only flags that new ext4 inodes do
NOT inherit from their parent.  In addition prevent the flags DIRTY,
ECOMPR, IMAGIC, TOPDIR, HUGE_FILE and EXT_MIGRATE from being inherited. 
List inheritable flags explicitly to prevent future flags from
accidentally being inherited.

This fixes the TOPDIR flag inheritance bug reported at
http://bugzilla.kernel.org/show_bug.cgi?id=9866.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Acked-by: Andreas Dilger <adilger@sun.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h   |    8 ++++++++
 fs/ext4/ialloc.c |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/ext4/ext4.h~ext4-dont-inherit-inappropriate-inode-flags-from-parent fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~ext4-dont-inherit-inappropriate-inode-flags-from-parent
+++ a/fs/ext4/ext4.h
@@ -247,6 +247,14 @@ struct flex_groups {
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000B80FF /* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
+			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
+			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
+			   EXT4_COMPRBLK_FL | EXT4_NOCOMPR_FL |\
+			   EXT4_JOURNAL_DATA_FL | EXT4_NOTAIL_FL|\
+			   EXT4_DIRSYNC_FL)
+
 /*
  * Inode dynamic state flags
  */
diff -puN fs/ext4/ialloc.c~ext4-dont-inherit-inappropriate-inode-flags-from-parent fs/ext4/ialloc.c
--- a/fs/ext4/ialloc.c~ext4-dont-inherit-inappropriate-inode-flags-from-parent
+++ a/fs/ext4/ialloc.c
@@ -813,7 +813,7 @@ got:
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

ext2-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext3-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext4-dont-inherit-inappropriate-inode-flags-from-parent.patch
ext2-tighten-restrictions-on-inode-flags.patch
ext3-tighten-restrictions-on-inode-flags.patch
ext4-tighten-restrictions-on-inode-flags.patch

