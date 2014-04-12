From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/5] ext4: factor out common code in ext4_file_write()
Date: Sat, 12 Apr 2014 13:02:40 -0400
Message-ID: <1397322161-32148-5-git-send-email-tytso@mit.edu>
References: <1397322161-32148-1-git-send-email-tytso@mit.edu>
Cc: viro@ZenIV.linux.org.uk, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53226 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbaDLRCw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 13:02:52 -0400
In-Reply-To: <1397322161-32148-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This shouldn't change any logic flow; just delete duplicated code.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/file.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 5e428d58..7c8f483 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -98,6 +98,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct blk_plug plug;
+	int o_direct = file->f_flags & O_DIRECT;
 	int overwrite = 0;
 	size_t length = iov_length(iov, nr_segs);
 	ssize_t ret;
@@ -122,7 +123,7 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT)) {
+	if (o_direct) {
 		struct mutex *aio_mutex = NULL;
 
 		/* Unaligned direct AIO must be serialized; see comment above */
@@ -169,33 +170,21 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 			if (err == len && (map.m_flags & EXT4_MAP_MAPPED))
 				overwrite = 1;
 		}
-
-		ret = __generic_file_aio_write(iocb, iov, nr_segs,
-					       &iocb->ki_pos);
-		mutex_unlock(&inode->i_mutex);
-
-		if (ret > 0) {
-			ssize_t err;
-
-			err = generic_write_sync(file, iocb->ki_pos - ret, ret);
-			if (err < 0)
-				ret = err;
-		}
-		blk_finish_plug(&plug);
-	} else {
+	} else
 		mutex_lock(&inode->i_mutex);
-		ret = __generic_file_aio_write(iocb, iov, nr_segs,
-					       &iocb->ki_pos);
-		mutex_unlock(&inode->i_mutex);
 
-		if (ret > 0) {
-			ssize_t err;
+	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
+	mutex_unlock(&inode->i_mutex);
 
-			err = generic_write_sync(file, iocb->ki_pos - ret, ret);
-			if (err < 0)
-				ret = err;
-		}
+	if (ret > 0) {
+		ssize_t err;
+
+		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
+		if (err < 0)
+			ret = err;
 	}
+	if (o_direct)
+		blk_finish_plug(&plug);
 
 	return ret;
 }
-- 
1.9.0

