From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Correction to nanosecond timestamp patch for 64-bit arch
Date: Sun, 17 Jun 2007 18:32:46 +0530
Message-ID: <1182085374.4141.5.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:51020 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbXFQNDJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jun 2007 09:03:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=5079 mentions the problem with timestamps in ext2/3/4. If the timestamp is set to before epoch, the files have their dates changed on 64-bit partitions.

The corrections from this bug also need to be incorporated in the nanosecond patch. 

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: linux-2.6.21/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.21.orig/include/linux/ext4_fs.h
+++ linux-2.6.21/include/linux/ext4_fs.h
@@ -366,9 +366,9 @@ static inline __le32 ext4_encode_extra_t
 static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
 {
        if (sizeof(time->tv_sec) > 4)
-	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
-			       << 32;
-       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
+	       time->tv_sec |= (__u64)((signed)le32_to_cpu(extra) &
+				       EXT4_EPOCH_MASK) << 32;
+       time->tv_nsec = ((signed)le32_to_cpu(extra) & EXT4_NSEC_MASK) >> 2;
 }
 
 #define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)			       \
@@ -390,7 +390,7 @@ do {									       \
 
 #define EXT4_INODE_GET_XTIME(xtime, inode, raw_inode)			       \
 do {									       \
-	(inode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);	       \
+	(inode)->xtime.tv_sec = (signed)le32_to_cpu((raw_inode)->xtime);       \
 	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## _extra))     \
 		ext4_decode_extra_time(&(inode)->xtime,			       \
 				       raw_inode->xtime ## _extra);	       \
@@ -399,7 +399,8 @@ do {									       \
 #define EXT4_EINODE_GET_XTIME(xtime, einode, raw_inode)			       \
 do {									       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime))		       \
-		(einode)->xtime.tv_sec = le32_to_cpu((raw_inode)->xtime);      \
+		(einode)->xtime.tv_sec = 				       \
+				(signed)le32_to_cpu((raw_inode)->xtime);       \
 	if (EXT4_FITS_IN_INODE(raw_inode, einode, xtime ## _extra))	       \
 		ext4_decode_extra_time(&(einode)->xtime,		       \
 				       raw_inode->xtime ## _extra);	       \
