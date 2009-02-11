From: akpm@linux-foundation.org
Subject: [patch 2/3] ext4: don't inherit inappropriate inode flags from parent
Date: Wed, 11 Feb 2009 13:28:27 -0800
Message-ID: <200902112128.n1BLSR9r000811@imap1.linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
	duaneg@dghda.com, adilger@sun.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759033AbZBKV3o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 16:29:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
@@ -239,6 +239,14 @@ struct flex_groups {
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
@@ -878,7 +878,7 @@ got:
 	 * newly created directory and file only if -o extent mount option is
 	 * specified
 	 */
-	ei->i_flags = EXT4_I(dir)->i_flags & ~(EXT4_INDEX_FL|EXT4_EXTENTS_FL);
+	ei->i_flags = EXT4_I(dir)->i_flags & EXT4_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
 	/* dirsync only applies to directories */
_
