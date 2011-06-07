From: amir73il@users.sourceforge.net
Subject: [PATCH v1 26/36] ext4: snapshot journaled - trace COW/buffer credits
Date: Tue,  7 Jun 2011 18:07:53 +0300
Message-ID: <1307459283-22130-27-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1FGPKI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:08 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:08 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Extra debug prints to trace snapshot usage of buffer credits.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4_jbd2.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4_jbd2.h |   26 ++++++++++++++++
 fs/ext4/super.c     |    2 +
 3 files changed, 108 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index e8287f4..eb88564 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -23,6 +23,7 @@ int __ext4_handle_get_bitmap_access(const char *where, unsigned int line,
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
+		ext4_journal_trace(SNAP_DEBUG, where, handle, 1);
 	}
 	return err;
 }
@@ -40,6 +41,7 @@ int __ext4_journal_get_write_access_inode(const char *where, unsigned int line,
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
+	ext4_journal_trace(SNAP_DEBUG, where, handle, 1);
 	}
 	return err;
 }
@@ -91,6 +93,7 @@ int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
 			if (err)
 				ext4_journal_abort_handle(where, line, __func__,
 							  bh, handle, err);
+			ext4_journal_trace(SNAP_DEBUG, where, handle, 1);
 			return err;
 		}
 		return 0;
@@ -108,6 +111,7 @@ int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
 			   "error %d when attempting revoke", err);
 	}
 	BUFFER_TRACE(bh, "exit");
+	ext4_journal_trace(SNAP_DEBUG, where, handle, 1);
 	return err;
 }
 
@@ -123,6 +127,7 @@ int __ext4_journal_get_create_access(const char *where, unsigned int line,
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__,
 						  bh, handle, err);
+		ext4_journal_trace(SNAP_DEBUG, where, handle, -1);
 	}
 	return err;
 }
@@ -198,6 +203,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 			}
 			jbd_unlock_bh_state(bh);
 		}
+		ext4_journal_trace(SNAP_DEBUG, where, handle, -1);
 	} else {
 		if (inode)
 			mark_buffer_dirty_inode(bh, inode);
@@ -236,3 +242,77 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 		sb->s_dirt = 1;
 	return err;
 }
+
+#ifdef CONFIG_JBD2_DEBUG
+static void ext4_journal_cow_stats(int n, handle_t *handle)
+{
+	snapshot_debug(n, "COW stats: moved/copied=%d/%d, "
+			 "mapped/bitmap/cached=%d/%d/%d, "
+			 "bitmaps/cleared=%d/%d\n", handle->h_cow_moved,
+			 handle->h_cow_copied, handle->h_cow_ok_mapped,
+			 handle->h_cow_ok_bitmap, handle->h_cow_ok_jh,
+			 handle->h_cow_bitmaps, handle->h_cow_excluded);
+}
+#else
+#define ext4_journal_cow_stats(n, handle)
+#endif
+
+#ifdef CONFIG_EXT4_DEBUG
+void __ext4_journal_trace(int n, const char *fn, const char *caller,
+			  handle_t *handle, int nblocks)
+{
+	int active_snapshot;
+	int upper;
+	int lower;
+	int final;
+	struct super_block *sb;
+
+	sb = handle->h_transaction->t_journal->j_private;
+	if (!EXT4_SNAPSHOTS(sb))
+		return;
+
+	active_snapshot = ext4_snapshot_active(EXT4_SB(sb));
+	upper = EXT4_SNAPSHOT_START_TRANS_BLOCKS(handle->h_base_credits);
+	lower = EXT4_SNAPSHOT_TRANS_BLOCKS(handle->h_user_credits);
+	final = (nblocks == 0 && handle->h_ref == 1 &&
+		     !IS_COWING(handle));
+
+	switch (snapshot_enable_debug) {
+	case SNAP_INFO:
+		/* trace final journal_stop if any credits have been used */
+		if (final && (handle->h_buffer_credits < upper ||
+			      handle->h_user_credits < handle->h_base_credits))
+			break;
+	case SNAP_WARN:
+		/*
+		 * trace if buffer credits are too low - lower limit is only
+		 * valid if there is an active snapshot and not during COW
+		 */
+		if (handle->h_buffer_credits < lower &&
+		    active_snapshot && !IS_COWING(handle))
+			break;
+	case SNAP_ERR:
+		/* trace if user credits are too low */
+		if (handle->h_user_credits < 0)
+			break;
+	case 0:
+		/* no trace */
+		return;
+
+	case SNAP_DEBUG:
+	default:
+		/* trace all calls */
+		break;
+	}
+
+	snapshot_debug_l(n, IS_COWING(handle), "%s(%d): credits=%d,"
+			" limit=%d/%d, user=%d/%d, ref=%d, caller=%s\n",
+			 fn, nblocks, handle->h_buffer_credits, lower, upper,
+			 handle->h_user_credits, handle->h_base_credits,
+			 handle->h_ref, caller);
+	if (!final)
+		return;
+
+	ext4_journal_cow_stats(n, handle);
+}
+#endif
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index cee6f2a..41951da 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -229,10 +229,36 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 #define ext4_handle_dirty_super(handle, sb) \
 	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))
 
+/*
+ * macros for ext4 to update transaction COW statistics.
+ * if the kernel was compiled without CONFIG_JBD2_DEBUG
+ * then the h_cow_* fields are not allocated in handle objects.
+ */
+#ifdef CONFIG_JBD2_DEBUG
+#define trace_cow_add(handle, name, num)	\
+	(handle)->h_cow_##name += (num)
+#define trace_cow_inc(handle, name)		\
+	(handle)->h_cow_##name++;
+
+#else
 #define trace_cow_add(handle, name, num)
 #define trace_cow_inc(handle, name)
 
+#endif
+#ifdef CONFIG_EXT4_DEBUG
+void __ext4_journal_trace(int debug, const char *fn, const char *caller,
+		handle_t *handle, int nblocks);
+
+#define ext4_journal_trace(n, caller, handle, nblocks)			\
+	do {								\
+		if ((n) <= snapshot_enable_debug)			\
+			__ext4_journal_trace((n), __func__, (caller),	\
+						(handle), (nblocks));	\
+	} while (0)
+
+#else
 #define ext4_journal_trace(n, caller, handle, nblocks)
+#endif
 
 handle_t *__ext4_journal_start(const char *where,
 		struct super_block *sb, int nblocks);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0d996be..fc8bfda 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -324,6 +324,8 @@ int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle)
 	int err;
 	int rc;
 
+	ext4_journal_trace(SNAP_WARN, where, handle, 0);
+
 	if (!ext4_handle_valid(handle)) {
 		ext4_put_nojournal(handle);
 		return 0;
-- 
1.7.4.1

