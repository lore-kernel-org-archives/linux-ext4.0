From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v5 3/5] vfs: add lazytime tracepoints for better debugging
Date: Fri, 28 Nov 2014 01:00:09 -0500
Message-ID: <1417154411-5367-5-git-send-email-tytso@mit.edu>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56306 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaK1GAW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Nov 2014 01:00:22 -0500
In-Reply-To: <1417154411-5367-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/fs-writeback.c         |  1 +
 fs/inode.c                |  5 +++++
 include/trace/events/fs.h | 56 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)
 create mode 100644 include/trace/events/fs.h

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 15dec84..9facc18 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/tracepoint.h>
 #include <linux/device.h>
+#include <trace/events/fs.h>
 #include "internal.h"
 
 /*
diff --git a/fs/inode.c b/fs/inode.c
index 84a5a3d..e062640 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -20,6 +20,9 @@
 #include <linux/list_lru.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/fs.h>
+
 /*
  * Inode locking rules:
  *
@@ -1440,6 +1443,7 @@ retry:
 			inode->i_state &= ~I_DIRTY_TIME;
 			spin_unlock(&inode->i_lock);
 			mark_inode_dirty_sync(inode);
+			trace_fs_lazytime_iput(inode);
 			goto retry;
 		}
 		iput_final(inode);
@@ -1556,6 +1560,7 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
 		inode->i_ts_dirty_day = days_since_boot;
 		spin_unlock(&inode->i_lock);
 		inode_requeue_dirtytime(inode);
+		trace_fs_lazytime_defer(inode);
 		return 0;
 	}
 force_dirty:
diff --git a/include/trace/events/fs.h b/include/trace/events/fs.h
new file mode 100644
index 0000000..fa32295
--- /dev/null
+++ b/include/trace/events/fs.h
@@ -0,0 +1,56 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM fs
+
+#if !defined(_TRACE_FS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FS_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(fs__inode,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	uid_t,	uid			)
+		__field(	gid_t,	gid			)
+		__field(	__u16, mode			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->uid	= i_uid_read(inode);
+		__entry->gid	= i_gid_read(inode);
+		__entry->mode	= inode->i_mode;
+	),
+
+	TP_printk("dev %d,%d ino %lu mode 0%o uid %u gid %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->mode,
+		  __entry->uid, __entry->gid)
+);
+
+DEFINE_EVENT(fs__inode, fs_lazytime_defer,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(fs__inode, fs_lazytime_iput,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(fs__inode, fs_lazytime_flush,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+#endif /* _TRACE_FS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.1.0

