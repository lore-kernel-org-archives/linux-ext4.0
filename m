Return-Path: <SRS0=P4kf=OT=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:23631 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeLJMw6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Dec 2018 07:52:58 -0500
From: Kanchan Joshi <joshi.k@samsung.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.com,
        viro@zeniv.linux.org.uk, darrick.wong@oracle.com, axboe@kernel.dk,
        jrdr.linux@gmail.com, ebiggers@google.com,
        jooyoung.hwang@samsung.com, chur.lee@samsung.com,
        prakash.v@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 1/2] fs: introduce APIs to enable sending write-hint with
 buffer-head
Date: Mon, 10 Dec 2018 18:20:03 +0530
Message-id: <1544446204-5291-2-git-send-email-joshi.k@samsung.com>
In-reply-to: <1544446204-5291-1-git-send-email-joshi.k@samsung.com>
References: <1544446204-5291-1-git-send-email-joshi.k@samsung.com>
        <CGME20181210125251epcas1p3023db72cc08d6b2f899141d551d53f61@epcas1p3.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

submit_bh and write_dirty_buffer do not take write-hint as
parameter. This patch introduces variants which do.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/buffer.c                 | 21 +++++++++++++++++++++
 include/linux/buffer_head.h |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1286c2b..60c8867 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3094,6 +3094,13 @@ int submit_bh(int op, int op_flags, struct buffer_head *bh)
 }
 EXPORT_SYMBOL(submit_bh);
 
+int submit_bh_write_hint(int op, int op_flags, struct buffer_head *bh,
+			 enum rw_hint hint)
+{
+	return submit_bh_wbc(op, op_flags, bh, hint, NULL);
+}
+EXPORT_SYMBOL(submit_bh_write_hint);
+
 /**
  * ll_rw_block: low-level access to block devices (DEPRECATED)
  * @op: whether to %READ or %WRITE
@@ -3162,6 +3169,20 @@ void write_dirty_buffer(struct buffer_head *bh, int op_flags)
 }
 EXPORT_SYMBOL(write_dirty_buffer);
 
+void write_dirty_buffer_write_hint(struct buffer_head *bh, int op_flags,
+				   enum rw_hint hint)
+{
+	lock_buffer(bh);
+	if (!test_clear_buffer_dirty(bh)) {
+		unlock_buffer(bh);
+		return;
+	}
+	bh->b_end_io = end_buffer_write_sync;
+	get_bh(bh);
+	submit_bh_wbc(REQ_OP_WRITE, op_flags, bh, hint, NULL);
+}
+EXPORT_SYMBOL(write_dirty_buffer_write_hint);
+
 /*
  * For a data-integrity writeout, we need to wait upon any in-progress I/O
  * and then start new I/O and then wait upon it.  The caller must have a ref on
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7b73ef7..ac9f111 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -200,7 +200,10 @@ void ll_rw_block(int, int, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, int op_flags);
 void write_dirty_buffer(struct buffer_head *bh, int op_flags);
+void write_dirty_buffer_write_hint(struct buffer_head *bh, int op_flags,
+				   enum rw_hint hint);
 int submit_bh(int, int, struct buffer_head *);
+int submit_bh_write_hint(int, int, struct buffer_head *, enum rw_hint hint);
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
-- 
2.7.4
