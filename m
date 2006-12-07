From: akpm@osdl.org
Subject: [patch 193/354] ext4: uninline large functions
Date: Wed, 06 Dec 2006 20:37:15 -0800
Message-ID: <200612070437.kB74bF01029634@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, acme@mandriva.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968744AbWLGEhV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:37:21 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

Saves nearly 4kbytes on x86.

Cc: Arnaldo Carvalho de Melo <acme@mandriva.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/Makefile          |    3 -
 fs/ext4/ext4_jbd2.c       |   59 +++++++++++++++++++++++++++
 include/linux/ext4_jbd2.h |   76 ++++++++----------------------------
 3 files changed, 78 insertions(+), 60 deletions(-)

diff -puN fs/ext4/Makefile~ext4-uninline-large-functions fs/ext4/Makefile
--- a/fs/ext4/Makefile~ext4-uninline-large-functions
+++ a/fs/ext4/Makefile
@@ -5,7 +5,8 @@
 obj-$(CONFIG_EXT4DEV_FS) += ext4dev.o
 
 ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
-	   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o
+		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
+		   ext4_jbd2.o
 
 ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
diff -puN /dev/null fs/ext4/ext4_jbd2.c
--- /dev/null
+++ a/fs/ext4/ext4_jbd2.c
@@ -0,0 +1,59 @@
+/*
+ * Interface between ext4 and JBD
+ */
+
+#include <linux/ext4_jbd2.h>
+
+int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = jbd2_journal_get_undo_access(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_get_write_access(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = jbd2_journal_get_write_access(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_forget(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = jbd2_journal_forget(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_revoke(const char *where, handle_t *handle,
+				ext4_fsblk_t blocknr, struct buffer_head *bh)
+{
+	int err = jbd2_journal_revoke(handle, blocknr, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_get_create_access(const char *where,
+				handle_t *handle, struct buffer_head *bh)
+{
+	int err = jbd2_journal_get_create_access(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext4_journal_dirty_metadata(const char *where,
+				handle_t *handle, struct buffer_head *bh)
+{
+	int err = jbd2_journal_dirty_metadata(handle, bh);
+	if (err)
+		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
diff -puN include/linux/ext4_jbd2.h~ext4-uninline-large-functions include/linux/ext4_jbd2.h
--- a/include/linux/ext4_jbd2.h~ext4-uninline-large-functions
+++ a/include/linux/ext4_jbd2.h
@@ -114,74 +114,32 @@ int ext4_mark_inode_dirty(handle_t *hand
  * been done yet.
  */
 
-void ext4_journal_abort_handle(const char *caller, const char *err_fn,
-		struct buffer_head *bh, handle_t *handle, int err);
-
-static inline int
-__ext4_journal_get_undo_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
+static inline void ext4_journal_release_buffer(handle_t *handle,
+						struct buffer_head *bh)
 {
-	int err = jbd2_journal_get_undo_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
+	jbd2_journal_release_buffer(handle, bh);
 }
 
-static inline int
-__ext4_journal_get_write_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
-{
-	int err = jbd2_journal_get_write_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+void ext4_journal_abort_handle(const char *caller, const char *err_fn,
+		struct buffer_head *bh, handle_t *handle, int err);
 
-static inline void
-ext4_journal_release_buffer(handle_t *handle, struct buffer_head *bh)
-{
-	jbd2_journal_release_buffer(handle, bh);
-}
+int __ext4_journal_get_undo_access(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext4_journal_forget(const char *where, handle_t *handle, struct buffer_head *bh)
-{
-	int err = jbd2_journal_forget(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext4_journal_get_write_access(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext4_journal_revoke(const char *where, handle_t *handle,
-		      ext4_fsblk_t blocknr, struct buffer_head *bh)
-{
-	int err = jbd2_journal_revoke(handle, blocknr, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext4_journal_forget(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext4_journal_get_create_access(const char *where,
-				 handle_t *handle, struct buffer_head *bh)
-{
-	int err = jbd2_journal_get_create_access(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext4_journal_revoke(const char *where, handle_t *handle,
+				ext4_fsblk_t blocknr, struct buffer_head *bh);
 
-static inline int
-__ext4_journal_dirty_metadata(const char *where,
-			      handle_t *handle, struct buffer_head *bh)
-{
-	int err = jbd2_journal_dirty_metadata(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext4_journal_get_create_access(const char *where,
+				handle_t *handle, struct buffer_head *bh);
 
+int __ext4_journal_dirty_metadata(const char *where,
+				handle_t *handle, struct buffer_head *bh);
 
 #define ext4_journal_get_undo_access(handle, bh) \
 	__ext4_journal_get_undo_access(__FUNCTION__, (handle), (bh))
_
