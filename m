From: akpm@linux-foundation.org
Subject: [patch 4/4] ext4: replace __FUNCTION__ occurrences
Date: Sat, 12 Jul 2008 23:26:21 -0700
Message-ID: <200807130626.m6D6QMvj007916@imap1.linux-foundation.org>
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, stoyboyker@gmail.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448AbYGMGby (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jul 2008 02:31:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: "Stoyan Gaydarov" <stoyboyker@gmail.com>

__FUNCTION__ is gcc-specific, use __func__ instead

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4.h      |    4 ++--
 fs/ext4/ext4_jbd2.h |   14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/ext4/ext4.h~ext4-replace-__function__-occurrences fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~ext4-replace-__function__-occurrences
+++ a/fs/ext4/ext4.h
@@ -45,7 +45,7 @@
 #define ext4_debug(f, a...)						\
 	do {								\
 		printk (KERN_DEBUG "EXT4-fs DEBUG (%s, %d): %s:",	\
-			__FILE__, __LINE__, __FUNCTION__);		\
+			__FILE__, __LINE__, __func__);			\
 		printk (KERN_DEBUG f, ## a);				\
 	} while (0)
 #else
@@ -1203,7 +1203,7 @@ static inline unsigned int ext4_flex_bg_
 #define ext4_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
-		__ext4_std_error((sb), __FUNCTION__, (errno));	\
+		__ext4_std_error((sb), __func__, (errno));	\
 } while (0)
 
 /*
diff -puN fs/ext4/ext4_jbd2.h~ext4-replace-__function__-occurrences fs/ext4/ext4_jbd2.h
--- a/fs/ext4/ext4_jbd2.h~ext4-replace-__function__-occurrences
+++ a/fs/ext4/ext4_jbd2.h
@@ -142,17 +142,17 @@ int __ext4_journal_dirty_metadata(const 
 				handle_t *handle, struct buffer_head *bh);
 
 #define ext4_journal_get_undo_access(handle, bh) \
-	__ext4_journal_get_undo_access(__FUNCTION__, (handle), (bh))
+	__ext4_journal_get_undo_access(__func__, (handle), (bh))
 #define ext4_journal_get_write_access(handle, bh) \
-	__ext4_journal_get_write_access(__FUNCTION__, (handle), (bh))
+	__ext4_journal_get_write_access(__func__, (handle), (bh))
 #define ext4_journal_revoke(handle, blocknr, bh) \
-	__ext4_journal_revoke(__FUNCTION__, (handle), (blocknr), (bh))
+	__ext4_journal_revoke(__func__, (handle), (blocknr), (bh))
 #define ext4_journal_get_create_access(handle, bh) \
-	__ext4_journal_get_create_access(__FUNCTION__, (handle), (bh))
+	__ext4_journal_get_create_access(__func__, (handle), (bh))
 #define ext4_journal_dirty_metadata(handle, bh) \
-	__ext4_journal_dirty_metadata(__FUNCTION__, (handle), (bh))
+	__ext4_journal_dirty_metadata(__func__, (handle), (bh))
 #define ext4_journal_forget(handle, bh) \
-	__ext4_journal_forget(__FUNCTION__, (handle), (bh))
+	__ext4_journal_forget(__func__, (handle), (bh))
 
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, handle_t *handle);
@@ -163,7 +163,7 @@ static inline handle_t *ext4_journal_sta
 }
 
 #define ext4_journal_stop(handle) \
-	__ext4_journal_stop(__FUNCTION__, (handle))
+	__ext4_journal_stop(__func__, (handle))
 
 static inline handle_t *ext4_journal_current_handle(void)
 {
_
