From: akpm@osdl.org
Subject: [patch 192/354] ext3: uninline large functions
Date: Wed, 06 Dec 2006 20:37:14 -0800
Message-ID: <200612070437.kB74bFbI029628@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, acme@mandriva.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46897 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968745AbWLGEhU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:37:20 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

Saves nearly 4kbytes on x86.

Cc: Arnaldo Carvalho de Melo <acme@mandriva.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/Makefile         |    2 
 fs/ext3/ext3_jbd.c       |   59 ++++++++++++++++++++++++++++
 include/linux/ext3_jbd.h |   76 ++++++++-----------------------------
 3 files changed, 77 insertions(+), 60 deletions(-)

diff -puN fs/ext3/Makefile~ext3-uninline-large-functions fs/ext3/Makefile
--- a/fs/ext3/Makefile~ext3-uninline-large-functions
+++ a/fs/ext3/Makefile
@@ -5,7 +5,7 @@
 obj-$(CONFIG_EXT3_FS) += ext3.o
 
 ext3-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
-	   ioctl.o namei.o super.o symlink.o hash.o resize.o
+	   ioctl.o namei.o super.o symlink.o hash.o resize.o ext3_jbd.o
 
 ext3-$(CONFIG_EXT3_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
 ext3-$(CONFIG_EXT3_FS_POSIX_ACL) += acl.o
diff -puN /dev/null fs/ext3/ext3_jbd.c
--- /dev/null
+++ a/fs/ext3/ext3_jbd.c
@@ -0,0 +1,59 @@
+/*
+ * Interface between ext3 and JBD
+ */
+
+#include <linux/ext3_jbd.h>
+
+int __ext3_journal_get_undo_access(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = journal_get_undo_access(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_get_write_access(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = journal_get_write_access(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_forget(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	int err = journal_forget(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_revoke(const char *where, handle_t *handle,
+				unsigned long blocknr, struct buffer_head *bh)
+{
+	int err = journal_revoke(handle, blocknr, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_get_create_access(const char *where,
+				handle_t *handle, struct buffer_head *bh)
+{
+	int err = journal_get_create_access(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
+
+int __ext3_journal_dirty_metadata(const char *where,
+				handle_t *handle, struct buffer_head *bh)
+{
+	int err = journal_dirty_metadata(handle, bh);
+	if (err)
+		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
+	return err;
+}
diff -puN include/linux/ext3_jbd.h~ext3-uninline-large-functions include/linux/ext3_jbd.h
--- a/include/linux/ext3_jbd.h~ext3-uninline-large-functions
+++ a/include/linux/ext3_jbd.h
@@ -109,74 +109,32 @@ int ext3_mark_inode_dirty(handle_t *hand
  * been done yet.
  */
 
-void ext3_journal_abort_handle(const char *caller, const char *err_fn,
-		struct buffer_head *bh, handle_t *handle, int err);
-
-static inline int
-__ext3_journal_get_undo_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
+static inline void ext3_journal_release_buffer(handle_t *handle,
+						struct buffer_head *bh)
 {
-	int err = journal_get_undo_access(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
+	journal_release_buffer(handle, bh);
 }
 
-static inline int
-__ext3_journal_get_write_access(const char *where, handle_t *handle,
-				struct buffer_head *bh)
-{
-	int err = journal_get_write_access(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+void ext3_journal_abort_handle(const char *caller, const char *err_fn,
+		struct buffer_head *bh, handle_t *handle, int err);
 
-static inline void
-ext3_journal_release_buffer(handle_t *handle, struct buffer_head *bh)
-{
-	journal_release_buffer(handle, bh);
-}
+int __ext3_journal_get_undo_access(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext3_journal_forget(const char *where, handle_t *handle, struct buffer_head *bh)
-{
-	int err = journal_forget(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext3_journal_get_write_access(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext3_journal_revoke(const char *where, handle_t *handle,
-		      unsigned long blocknr, struct buffer_head *bh)
-{
-	int err = journal_revoke(handle, blocknr, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext3_journal_forget(const char *where, handle_t *handle,
+				struct buffer_head *bh);
 
-static inline int
-__ext3_journal_get_create_access(const char *where,
-				 handle_t *handle, struct buffer_head *bh)
-{
-	int err = journal_get_create_access(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext3_journal_revoke(const char *where, handle_t *handle,
+				unsigned long blocknr, struct buffer_head *bh);
 
-static inline int
-__ext3_journal_dirty_metadata(const char *where,
-			      handle_t *handle, struct buffer_head *bh)
-{
-	int err = journal_dirty_metadata(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(where, __FUNCTION__, bh, handle,err);
-	return err;
-}
+int __ext3_journal_get_create_access(const char *where,
+				handle_t *handle, struct buffer_head *bh);
 
+int __ext3_journal_dirty_metadata(const char *where,
+				handle_t *handle, struct buffer_head *bh);
 
 #define ext3_journal_get_undo_access(handle, bh) \
 	__ext3_journal_get_undo_access(__FUNCTION__, (handle), (bh))
_
