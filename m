From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] ext4: inline generic_file_aio_write() into ext4_file_write()
Date: Sat, 12 Apr 2014 13:02:37 -0400
Message-ID: <1397322161-32148-2-git-send-email-tytso@mit.edu>
References: <1397322161-32148-1-git-send-email-tytso@mit.edu>
Cc: viro@ZenIV.linux.org.uk, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53220 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaDLRCs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 13:02:48 -0400
In-Reply-To: <1397322161-32148-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Copy generic_file_aio_write() into ext4_file_write().  This is part of
a patch series which allows us to simplify ext4_file_write() and
ext4_file_dio_write(), by calling __generic_file_aio_write() directly.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/file.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 25a20b6..8b22556 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -113,8 +113,6 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 		ext4_unwritten_wait(inode);
 	}
 
-	BUG_ON(iocb->ki_pos != pos);
-
 	mutex_lock(&inode->i_mutex);
 	blk_start_plug(&plug);
 
@@ -168,9 +166,12 @@ static ssize_t
 ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		unsigned long nr_segs, loff_t pos)
 {
+	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
 
+	BUG_ON(iocb->ki_pos != pos);
+
 	/*
 	 * If we have encountered a bitmap-format file, the size limit
 	 * is smaller than s_maxbytes, which is for extent-mapped files.
@@ -192,8 +193,20 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 
 	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT))
 		ret = ext4_file_dio_write(iocb, iov, nr_segs, pos);
-	else
-		ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+	else {
+		mutex_lock(&inode->i_mutex);
+		ret = __generic_file_aio_write(iocb, iov, nr_segs,
+					       &iocb->ki_pos);
+		mutex_unlock(&inode->i_mutex);
+
+		if (ret > 0) {
+			ssize_t err;
+
+			err = generic_write_sync(file, iocb->ki_pos - ret, ret);
+			if (err < 0)
+				ret = err;
+		}
+	}
 
 	return ret;
 }
-- 
1.9.0

