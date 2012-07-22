From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 10/10 v1] ext4: add two tracepoints in punching hole
Date: Sun, 22 Jul 2012 15:46:07 +0800
Message-ID: <1342943167-12153-11-git-send-email-wenqing.lz@taobao.com>
References: <1342943167-12153-1-git-send-email-wenqing.lz@taobao.com>
Cc: xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36677 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab2GVHi3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Jul 2012 03:38:29 -0400
In-Reply-To: <1342943167-12153-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This patch adds two tracepoints in ext4_ext_punch_hole.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c           |    3 ++
 include/trace/events/ext4.h |   53 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2a526b4..0fb4ff5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4529,6 +4529,8 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t first_page_offset, last_page_offset;
 	int credits, err = 0;
 
+	trace_ext4_ext_punch_hole_enter(inode, offset, length);
+
 	mutex_lock(&inode->i_mutex);
 
 	/* No need to punch hole beyond i_size */
@@ -4663,6 +4665,7 @@ out:
 	ext4_journal_stop(handle);
 error:
 	mutex_unlock(&inode->i_mutex);
+	trace_ext4_ext_punch_hole_exit(inode, offset, length, err);
 	return err;
 }
 int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 5c17592..583f066 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1312,6 +1312,59 @@ TRACE_EVENT(ext4_fallocate_exit,
 		  __entry->ret)
 );
 
+TRACE_EVENT(ext4_ext_punch_hole_enter,
+	TP_PROTO(struct inode *inode, loff_t offset, loff_t len),
+
+	TP_ARGS(inode, offset, len),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	loff_t,	offset			)
+		__field(	loff_t, len			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->offset	= offset;
+		__entry->len	= len;
+	),
+
+	TP_printk("dev %d,%d ino %lu offset %lld len %lld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->offset, __entry->len)
+);
+
+TRACE_EVENT(ext4_ext_punch_hole_exit,
+	TP_PROTO(struct inode *inode, loff_t offset,
+		 loff_t len, int err),
+
+	TP_ARGS(inode, offset, len, err),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	loff_t,	offset			)
+		__field(	loff_t,	len			)
+		__field(	int,	err			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->offset	= offset;
+		__entry->len	= len;
+		__entry->err	= err;
+	),
+
+	TP_printk("dev %d,%d ino %lu offset %lld len %lld err %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->offset, __entry->len, __entry->err)
+);
+
 TRACE_EVENT(ext4_unlink_enter,
 	TP_PROTO(struct inode *parent, struct dentry *dentry),
 
-- 
1.7.4.1

