From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 1/3] ext4: split ext4_file_write into buffered IO and direct IO
Date: Sat, 28 Apr 2012 11:39:04 +0800
Message-ID: <1335584346-8070-2-git-send-email-wenqing.lz@taobao.com>
References: <1335584346-8070-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40095 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab2D1Dc0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2012 23:32:26 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so1232888pbb.19
        for <linux-ext4@vger.kernel.org>; Fri, 27 Apr 2012 20:32:26 -0700 (PDT)
In-Reply-To: <1335584346-8070-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

ext4_file_buffered/direct_write are defined in order to split buffered IO and
direct IO in ext4.  This patch just refactor some stuff in write path.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/file.c |   66 +++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..e5d6be3 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -89,12 +89,51 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
 	return 0;
 }
 
+static inline ssize_t
+ext4_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
+			 unsigned long nr_segs, loff_t pos)
+{
+	return generic_file_aio_write(iocb, iov, nr_segs, pos);
+}
+
+static ssize_t
+ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
+		    unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	int unaligned_aio = 0;
+	ssize_t ret;
+
+	if (!is_sync_kiocb(iocb))
+		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
+
+	/* Unaligned direct AIO must be serialized; see comment above */
+	if (unaligned_aio) {
+		static unsigned long unaligned_warn_time;
+
+		/* Warn about this once per day */
+		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
+			ext4_msg(inode->i_sb, KERN_WARNING,
+				 "Unaligned AIO/DIO on inode %ld by %s; "
+				 "performance will be poor.",
+				 inode->i_ino, current->comm);
+		mutex_lock(ext4_aio_mutex(inode));
+		ext4_aiodio_wait(inode);
+	}
+
+	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	if (unaligned_aio)
+		mutex_unlock(ext4_aio_mutex(inode));
+
+	return ret;
+}
+
 static ssize_t
 ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
-	int unaligned_aio = 0;
 	int ret;
 
 	/*
@@ -114,29 +153,12 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
 					      sbi->s_bitmap_maxbytes - pos);
 		}
-	} else if (unlikely((iocb->ki_filp->f_flags & O_DIRECT) &&
-		   !is_sync_kiocb(iocb))) {
-		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
-	}
-
-	/* Unaligned direct AIO must be serialized; see comment above */
-	if (unaligned_aio) {
-		static unsigned long unaligned_warn_time;
-
-		/* Warn about this once per day */
-		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
-			ext4_msg(inode->i_sb, KERN_WARNING,
-				 "Unaligned AIO/DIO on inode %ld by %s; "
-				 "performance will be poor.",
-				 inode->i_ino, current->comm);
-		mutex_lock(ext4_aio_mutex(inode));
-		ext4_aiodio_wait(inode);
 	}
 
-	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
