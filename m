From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] uninitialized groups ported - kernel
Date: Fri, 22 Jun 2007 11:20:25 -0500
Message-ID: <1182529225.10740.10.camel@kleikamp.austin.ibm.com>
References: <1181065733.5219.8.camel@mathur-dsktp>
	 <4665AFEF.3060602@redhat.com> <20070605212005.GM5181@schatzie.adilger.int>
	 <467755D3.8030802@linux.vnet.ibm.com>
	 <20070619075034.GQ5181@schatzie.adilger.int>
	 <1182340580.3819.3.camel@dhcp7.linsyssoft.com>
	 <20070621173757.GA1075@schatzie.adilger.int>
	 <467B0FA6.1090509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Girish Shilamkar <girish@clusterfs.com>,
	linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49129 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563AbXFVQU2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jun 2007 12:20:28 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5MGLZ8K016130
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2007 12:21:35 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5MGKRhH546132
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2007 12:20:27 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5MGKQaA008075
	for <linux-ext4@vger.kernel.org>; Fri, 22 Jun 2007 12:20:27 -0400
In-Reply-To: <467B0FA6.1090509@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-06-21 at 16:54 -0700, Avantika Mathur wrote:
> Kernel build was failing with the uninitialized patches when 
> CONFIG_CRC16=m. The patch below resolves this issue.

Why does ext4 duplicate lib/crc16.c?  What's wrong with putting "select
CRC16" in Kconfig?

How about this instead?

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

diff -urp linux-2.6.22-rc5-ext4/fs/Kconfig linux/fs/Kconfig
--- linux-2.6.22-rc5-ext4/fs/Kconfig	2007-06-22 10:08:49.000000000 -0500
+++ linux/fs/Kconfig	2007-06-22 11:13:08.000000000 -0500
@@ -139,6 +139,7 @@ config EXT3_FS_SECURITY
 config EXT4DEV_FS
 	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	select CRC16
 	select JBD2
 	help
 	  Ext4dev is a predecessor filesystem of the next generation
diff -urp linux-2.6.22-rc5-ext4/fs/ext4/group.h linux/fs/ext4/group.h
--- linux-2.6.22-rc5-ext4/fs/ext4/group.h	2007-06-22 10:10:52.000000000 -0500
+++ linux/fs/ext4/group.h	2007-06-22 11:09:32.000000000 -0500
@@ -8,9 +8,7 @@
 
 #ifndef _LINUX_EXT4_GROUP_H
 #define _LINUX_EXT4_GROUP_H
-#if defined(CONFIG_CRC16) || defined(CONFIG_CRC16_MODULE)
 #include <linux/crc16.h>
-#endif
 
 extern __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 group,
 				   struct ext4_group_desc *gdp);
diff -urp linux-2.6.22-rc5-ext4/fs/ext4/super.c linux/fs/ext4/super.c
--- linux-2.6.22-rc5-ext4/fs/ext4/super.c	2007-06-22 10:10:53.000000000 -0500
+++ linux/fs/ext4/super.c	2007-06-22 11:13:37.000000000 -0500
@@ -1260,56 +1260,6 @@ static int ext4_setup_super(struct super
 	return res;
 }
 
-#if !defined(CONFIG_CRC16) && !defined(CONFIG_CRC16_MODULE)
-/** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
-__u16 const crc16_table[256] = {
-	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
-	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
-	0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
-	0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
-	0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
-	0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
-	0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
-	0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
-	0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
-	0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
-	0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
-	0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
-	0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
-	0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
-	0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
-	0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
-	0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
-	0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
-	0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
-	0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
-	0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
-	0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
-	0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
-	0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
-	0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
-	0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
-	0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
-	0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
-	0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
-	0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
-	0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
-	0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
-};
-
-static inline __u16 crc16_byte(__u16 crc, const __u8 data)
-{
-	return (crc >> 8) ^ crc16_table[(crc ^ data) & 0xff];
-}
-
-__u16 crc16(__u16 crc, __u8 const *buffer, size_t len)
-{
-	while (len--)
-		crc = crc16_byte(crc, *buffer++);
-	return crc;
-}
-#endif
-
 __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
 			    struct ext4_group_desc *gdp)
 {

-- 
David Kleikamp
IBM Linux Technology Center
