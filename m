From: Fedor Uporov <thisisadrgreenthumb@gmail.com>
Subject: [PATCH] e2fsprogs: Apple Darwin, fix case of device with not 512
 bytes block size
Date: Sun, 19 Mar 2017 22:29:26 +0300
Message-ID: <20170319192926.GA3509@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36596 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751972AbdCSTdI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Mar 2017 15:33:08 -0400
Received: by mail-lf0-f66.google.com with SMTP id g70so8661461lfh.3
        for <linux-ext4@vger.kernel.org>; Sun, 19 Mar 2017 12:33:07 -0700 (PDT)
Received: from drgreenthumb (89-72-111-65.dynamic.chello.pl. [89.72.111.65])
        by smtp.gmail.com with ESMTPSA id i1sm2572358ljd.47.2017.03.19.12.24.14
        for <linux-ext4@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 19 Mar 2017 12:24:15 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Fedor Uporov <thisisadrgreenthumb@gmail.com>
---
 lib/blkid/getsize.c  | 11 +++++++----
 lib/ext2fs/getsize.c |  9 ++++++---
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/lib/blkid/getsize.c b/lib/blkid/getsize.c
index 8e8eb4c..3d26338 100644
--- a/lib/blkid/getsize.c
+++ b/lib/blkid/getsize.c
@@ -78,12 +78,15 @@ blkid_loff_t blkid_get_dev_size(int fd)
 	unsigned long long size64;
 	blkid_loff_t high, low;
 
-#ifdef DKIOCGETBLOCKCOUNT	/* For Apple Darwin */
-	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size64) >= 0) {
+#if defined DKIOCGETBLOCKCOUNT && defined DKIOCGETBLOCKSIZE	/* For Apple Darwin */
+	unsigned int size;
+
+	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size64) >= 0 &&
+	    ioctl(fd, DKIOCGETBLOCKSIZE, &size) >= 0) {
 		if (sizeof(blkid_loff_t) < sizeof(unsigned long long) &&
-		    (size64 << 9) > 0xFFFFFFFF)
+		    (size64 * size) > 0xFFFFFFFF)
 			return 0; /* EFBIG */
-		return (blkid_loff_t)size64 << 9;
+		return (blkid_loff_t)size64 * size;
 	}
 #endif
 
diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
index 89c33d4..68480c6 100644
--- a/lib/ext2fs/getsize.c
+++ b/lib/ext2fs/getsize.c
@@ -151,9 +151,12 @@ errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
 	if (fd < 0)
 		return errno;
 
-#ifdef DKIOCGETBLOCKCOUNT	/* For Apple Darwin */
-	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size64) >= 0) {
-		*retblocks = size64 / (blocksize / 512);
+#if defined DKIOCGETBLOCKCOUNT && defined DKIOCGETBLOCKSIZE	/* For Apple Darwin */
+	unsigned int size;
+
+	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size64) >= 0 &&
+	    ioctl(fd, DKIOCGETBLOCKSIZE, &size) >= 0) {
+		*retblocks = size64 * size / blocksize;
 		goto out;
 	}
 #endif
-- 
2.1.4
