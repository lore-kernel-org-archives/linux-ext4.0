From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,STABLE 2.6.29 01/18] ext4: don't inherit inappropriate inode flags from parent
Date: Tue,  2 Jun 2009 08:07:42 -0400
Message-ID: <1243944479-20574-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Duane Griffin <duaneg@dghda.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33527 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbZFBMIK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2009 08:08:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Duane Griffin <duaneg@dghda.com>

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
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
(cherry picked from commit 8fa43a81b97853fc69417bb6054182e78f95cbeb)
---
 fs/ext4/ext4.h   |    7 +++++++
 fs/ext4/ialloc.c |    2 +-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 90909f9..45af699 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -248,6 +248,13 @@ struct flex_groups {
 #define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x000B80FF /* User modifiable flags */
 
+/* Flags that should be inherited by new inodes from their parent. */
+#define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
+			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
+			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
+			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
+			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
+
 /*
  * Inode dynamic state flags
  */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2d2b358..6f09543 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -889,7 +889,7 @@ got:
 	 * newly created directory and file only if -o extent mount option is
 	 * specified
 	 */
-	ei->i_flags = EXT4_I(dir)->i_flags & ~(EXT4_INDEX_FL|EXT4_EXTENTS_FL);
+	ei->i_flags = EXT4_I(dir)->i_flags & EXT4_FL_INHERITED;
 	if (S_ISLNK(mode))
 		ei->i_flags &= ~(EXT4_IMMUTABLE_FL|EXT4_APPEND_FL);
 	/* dirsync only applies to directories */
-- 
1.6.3.1.1.g75fc.dirty

