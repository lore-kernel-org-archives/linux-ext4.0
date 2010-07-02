From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/8] ext4: clean up ext4_abort() so __func__ is now implicit
Date: Fri,  2 Jul 2010 14:46:51 -0400
Message-ID: <1278096418-14184-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52311 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759611Ab0GBSrC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 14:47:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use a macro definition for ext4_abort() to clean up the .c files a wee
bit.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h      |    4 +++-
 fs/ext4/ext4_jbd2.c |    4 ++--
 fs/ext4/super.c     |   11 +++++------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3864a27..d8ec824 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1629,8 +1629,10 @@ extern void ext4_error_inode(const char *, struct inode *, const char *, ...)
 extern void ext4_error_file(const char *, struct file *, const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern void __ext4_std_error(struct super_block *, const char *, int);
-extern void ext4_abort(struct super_block *, const char *, const char *, ...)
+extern void __ext4_abort(struct super_block *, const char *, const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
+#define ext4_abort(sb, message...)	__ext4_abort(sb, __func__, \
+						     ## message)
 extern void __ext4_warning(struct super_block *, const char *,
 			  const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index cfd27b3..df26a01 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -93,8 +93,8 @@ int __ext4_forget(const char *where, handle_t *handle, int is_metadata,
 	err = jbd2_journal_revoke(handle, blocknr, bh);
 	if (err) {
 		ext4_journal_abort_handle(where, __func__, bh, handle, err);
-		ext4_abort(inode->i_sb, __func__,
-			   "error %d when attempting revoke", err);
+		__ext4_abort(inode->i_sb, where,
+			     "error %d when attempting revoke", err);
 	}
 	BUFFER_TRACE(bh, "exit");
 	return err;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 422a4ce..11441e4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -248,7 +248,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal) {
 		if (is_journal_aborted(journal)) {
-			ext4_abort(sb, __func__, "Detected aborted journal");
+			ext4_abort(sb, "Detected aborted journal");
 			return ERR_PTR(-EROFS);
 		}
 		return jbd2_journal_start(journal, nblocks);
@@ -464,8 +464,8 @@ void __ext4_std_error(struct super_block *sb, const char *function, int errno)
  * case we take the easy way out and panic immediately.
  */
 
-void ext4_abort(struct super_block *sb, const char *function,
-		const char *fmt, ...)
+void __ext4_abort(struct super_block *sb, const char *function,
+		  const char *fmt, ...)
 {
 	va_list args;
 
@@ -660,8 +660,7 @@ static void ext4_put_super(struct super_block *sb)
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
 		if (err < 0)
-			ext4_abort(sb, __func__,
-				   "Couldn't clean up the journal");
+			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
 	ext4_release_system_zone(sb);
@@ -3605,7 +3604,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	}
 
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
-		ext4_abort(sb, __func__, "Abort forced by user");
+		ext4_abort(sb, "Abort forced by user");
 
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		(test_opt(sb, POSIX_ACL) ? MS_POSIXACL : 0);
-- 
1.7.0.4

