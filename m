From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] libext2fs: return errno on failure in ext2fs_sync_device()
Date: Mon, 11 Jan 2016 00:29:01 +0800
Message-ID: <1452443341-1851-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:34985 "EHLO
	mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbcAJQa3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Jan 2016 11:30:29 -0500
Received: by mail-pf0-f180.google.com with SMTP id 65so32865043pff.2
        for <linux-ext4@vger.kernel.org>; Sun, 10 Jan 2016 08:30:29 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_sync_device() returns -1 on ioctl error, which is the return
value from ioctl, but the callers expect the return value to be an errno
on failure.

Seen this while flushing in e2fsck on a file:

[root@localhost e2fsprogs]# e2fsck -Ff ~/ext4.img
ext2fs_sync_device: Unknown code ____ 255 while trying to flush /root/ext4.img

After fixing, correct error message is printed:

[root@localhost e2fsprogs]# e2fsck -Ff ~/ext4.img
ext2fs_sync_device: Inappropriate ioctl for device while trying to flush /root/ext4.img

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 lib/ext2fs/flushb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/flushb.c b/lib/ext2fs/flushb.c
index 98821fc..c62b659 100644
--- a/lib/ext2fs/flushb.c
+++ b/lib/ext2fs/flushb.c
@@ -52,6 +52,7 @@
  */
 errcode_t ext2fs_sync_device(int fd, int flushb)
 {
+	int ret = 0;
 	/*
 	 * We always sync the device in case we're running on old
 	 * kernels for which we can lose data if we don't.  (There
@@ -66,14 +67,18 @@ errcode_t ext2fs_sync_device(int fd, int flushb)
 #ifdef BLKFLSBUF
 		if (ioctl (fd, BLKFLSBUF, 0) == 0)
 			return 0;
+		ret = errno;
 #elif defined(__linux__)
 #warning BLKFLSBUF not defined
 #endif
 #ifdef FDFLUSH
-		return ioctl(fd, FDFLUSH, 0);   /* In case this is a floppy */
+		/* In case this is a floppy */
+		if (ioctl(fd, FDFLUSH, 0) == 0)
+			return 0;
+		ret = errno;
 #elif defined(__linux__)
 #warning FDFLUSH not defined
 #endif
 	}
-	return 0;
+	return ret;
 }
-- 
1.8.3.1

