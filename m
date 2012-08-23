From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 3/3] ext4: add tracepoint in punching hole
Date: Thu, 23 Aug 2012 12:25:41 +0800
Message-ID: <1345695941-15053-4-git-send-email-wenqing.lz@taobao.com>
References: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
Cc: Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42065 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2HWEP6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Aug 2012 00:15:58 -0400
In-Reply-To: <1345695941-15053-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This patch adds a tracepoint in ext4_punch_hole.

CC: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c             |    2 ++
 include/trace/events/ext4.h |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dde62e0..169eab3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3495,6 +3495,8 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
 
+	trace_ext4_punch_hole(inode, offset, length);
+
 	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
 		return ext4_ind_punch_hole(file, offset, length);
 
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 69d8a69..58bec84 100644
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
+		  (unsigned long) __entry->ino,
+		  __entry->offset, __entry->len)
+);
+
 TRACE_EVENT(ext4_unlink_enter,
 	TP_PROTO(struct inode *parent, struct dentry *dentry),
 
-- 
1.7.4.1

