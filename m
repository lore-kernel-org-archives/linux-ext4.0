From: Conrad Meyer <cemeyer@uw.edu>
Subject: [PATCH] fs: ext4: Sign-extend tv_sec after ORing in epoch bits
Date: Sun, 30 Mar 2014 07:58:34 -0700
Message-ID: <1396191514-19081-1-git-send-email-cse.cem@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Conrad Meyer <cse.cem@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62862 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaC3O6p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Mar 2014 10:58:45 -0400
Received: by mail-pd0-f179.google.com with SMTP id w10so6902862pde.10
        for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 07:58:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixes kernel.org bug #23732.

Background: ext4 stores time as a 34-bit quantity; 2 bits in some extra
bits unneeded for nanoseconds in the inode, and 32 bits in the seconds
field.

On systems with 64-bit time_t, the EXT4_*INODE_GET_XTIME() code
incorrectly sign-extended the low 32-bits of the seconds quantity before
ORing in the 2 "epoch" bits from nanoseconds.

This patch ORs in the 2 higher bits, then sign extends the 34-bit signed
number to 64 bits.

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
Patch against next-20140328.

Note, the on-disk format has always been written correctly. It was just
interpreted incorrectly.

Repro:
Before:
$ touch -d 2038-01-31 test-123
$ sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
$ ls -ld test-123
drwxrwxr-x 2 cmeyer cmeyer 4096 Dec 25  1901 test-123

After:
$ ls -ld test-123
drwxrwxr-x 2 cmeyer cmeyer 4096 Jan 31  2038 test-123

Thanks!
---
 fs/ext4/ext4.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f4f889e..07ee03d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -710,6 +710,8 @@ struct move_extent {
 #define EXT4_EPOCH_BITS 2
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
 #define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
+#define EXT4_EPOCH_SIGN (((1UL << (EXT4_EPOCH_BITS - 1)) << 16) << 16)
+#define EXT4_SIGN_EXT   (~((((1UL << EXT4_EPOCH_BITS) << 16) << 16) - 1))
 
 /*
  * Extended fields will fit into an inode if the filesystem was formatted
@@ -761,19 +763,23 @@ do {									       \
 
 #define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
 do {									       \
-	(inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);       \
+	(inode)->xtime.tv_sec = (__u64)le32_to_cpu((raw_inode)->xtime);	       \
 	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
 		ext4_decode_extra_time(&(inode)->xtime,			       \
 				       raw_inode->xtime ## _extra);	       \
 	else								       \
 		(inode)->xtime.tv_nsec = 0;				       \
+	if (sizeof((inode)->xtime.tv_sec) > 4) {			       \
+		if ((inode)->xtime.tv_sec & EXT4_EPOCH_SIGN)		       \
+			(inode)->xtime.tv_sec |= EXT4_SIGN_EXT;		       \
+	}								       \
 } while (0)
 
 #define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
 do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
 		(einode)->xtime.tv_sec = 				       \
-			(signed)le32_to_cpu((raw_inode)->xtime);	       \
+			(__u64)le32_to_cpu((raw_inode)->xtime);		       \
 	else								       \
 		(einode)->xtime.tv_sec = 0;				       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
@@ -781,6 +787,10 @@ do {									       \
 				       raw_inode->xtime ## _extra);	       \
 	else								       \
 		(einode)->xtime.tv_nsec = 0;				       \
+	if (sizeof((einode)->xtime.tv_sec) > 4) {			       \
+		if ((einode)->xtime.tv_sec & EXT4_EPOCH_SIGN)		       \
+			(einode)->xtime.tv_sec |= EXT4_SIGN_EXT;	       \
+	}								       \
 } while (0)
 
 #define i_disk_version osd1.linux1.l_i_version
-- 
1.9.0

