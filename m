From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/3 v2] ext4: add tracepoint for punching hole
Date: Mon, 19 Nov 2012 20:55:18 +0800
Message-ID: <1353329718-2075-4-git-send-email-wenqing.lz@taobao.com>
References: <1353329718-2075-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40976 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab2KSMmx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 07:42:53 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so430130pad.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 04:42:53 -0800 (PST)
In-Reply-To: <1353329718-2075-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This patch adds a tracepoint in ext4_punch_hole.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c             |  2 ++
 include/trace/events/ext4.h | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 733ed5b..f850ea6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3478,6 +3478,8 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
 
+	trace_ext4_punch_hole(inode, offset, length);
+
 	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return ext4_ind_punch_hole(file, offset, length);
 
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index d49b285..476c7d3 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1311,6 +1311,31 @@ TRACE_EVENT(ext4_fallocate_exit,
 		  __entry->ret)
 );
 
+TRACE_EVENT(ext4_punch_hole,
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
+		  (unsigned long)__entry->ino,
+		  __entry->offset, __entry->len)
+);
+
 TRACE_EVENT(ext4_unlink_enter,
 	TP_PROTO(struct inode *parent, struct dentry *dentry),
 
-- 
1.7.12.rc2.18.g61b472e

