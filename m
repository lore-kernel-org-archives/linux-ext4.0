From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 1/2] fs: read_write: Check ->aio_write in __kernel_write() and vfs_write()
Date: Wed, 23 Apr 2014 16:46:45 +0300
Message-ID: <1398260806-19340-2-git-send-email-peter.ujfalusi@ti.com>
References: <1398260806-19340-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:44846 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbaDWNq4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2014 09:46:56 -0400
In-Reply-To: <1398260806-19340-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Do similar checks as it has been done in vfs_read for the aio_write
callback.
ext4 for example does not provide aio_write callback causing NULL pointer
dereference in do_sync_write() without this check.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 fs/read_write.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index b6336a54f70d..009d8542a889 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -500,8 +500,10 @@ ssize_t __kernel_write(struct file *file, const char *buf, size_t count, loff_t
 		count =  MAX_RW_COUNT;
 	if (file->f_op->write)
 		ret = file->f_op->write(file, p, count, pos);
-	else
+	else if (file->f_op->aio_write)
 		ret = do_sync_write(file, p, count, pos);
+	else
+		ret = new_sync_write(file, p, count, pos);
 	set_fs(old_fs);
 	if (ret > 0) {
 		fsnotify_modify(file);
@@ -528,8 +530,10 @@ ssize_t vfs_write(struct file *file, const char __user *buf, size_t count, loff_
 		file_start_write(file);
 		if (file->f_op->write)
 			ret = file->f_op->write(file, buf, count, pos);
-		else
+		else if (file->f_op->aio_write)
 			ret = do_sync_write(file, buf, count, pos);
+		else
+			ret = new_sync_write(file, buf, count, pos);
 		if (ret > 0) {
 			fsnotify_modify(file);
 			add_wchar(current, ret);
-- 
1.9.2

