From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Re: [PATCH] uninitialized groups ported - kernel
Date: Thu, 21 Jun 2007 16:54:14 -0700
Message-ID: <467B0FA6.1090509@linux.vnet.ibm.com>
References: <1181065733.5219.8.camel@mathur-dsktp> <4665AFEF.3060602@redhat.com> <20070605212005.GM5181@schatzie.adilger.int> <467755D3.8030802@linux.vnet.ibm.com> <20070619075034.GQ5181@schatzie.adilger.int> <1182340580.3819.3.camel@dhcp7.linsyssoft.com> <20070621173757.GA1075@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070006050303090506060008"
Cc: Girish Shilamkar <girish@clusterfs.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50567 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbXFUXyE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 19:54:04 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5LNs4Xf001906
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 19:54:04 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5LNs4sA503050
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 19:54:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5LNs3WI030499
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 19:54:04 -0400
In-Reply-To: <20070621173757.GA1075@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------070006050303090506060008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Kernel build was failing with the uninitialized patches when 
CONFIG_CRC16=m. The patch below resolves this issue.

Also, when testing the patches, filesystem mount fails:

EXT4-fs error (device sdc1): ext4_check_descriptors: Checksum for group 1 failed (0!=1)

EXT4-fs: group descriptors corrupted!

EXT4-fs error (device sdc1): ext4_check_descriptors: Checksum for group 7 failed (0!=1)

Even though the uninitgrps feature is not enabled, the gdp->bg_checksum 
on disk is nonzero.
Mingming will pull the patches out of the patch queue until this is fixed.

Thanks
Avantika
---


--------------070006050303090506060008
Content-Type: text/x-patch;
 name="uninit-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="uninit-fix.patch"

diff -uprN linux-2.6.22-rc5/fs/ext4/group.h linux-2.6.22-rc5-patch/fs/ext4/group.h
--- linux-2.6.22-rc5/fs/ext4/group.h	2007-06-21 16:32:52.000000000 -0700
+++ linux-2.6.22-rc5-patch/fs/ext4/group.h	2007-06-21 16:30:33.000000000 -0700
@@ -8,7 +8,7 @@
 
 #ifndef _LINUX_EXT4_GROUP_H
 #define _LINUX_EXT4_GROUP_H
-#if defined(CONFIG_CRC16) || defined(CONFIG_CRC16_MODULE)
+#if defined(CONFIG_CRC16)
 #include <linux/crc16.h>
 #endif
 
diff -uprN linux-2.6.22-rc5/fs/ext4/super.c linux-2.6.22-rc5-patch/fs/ext4/super.c
--- linux-2.6.22-rc5/fs/ext4/super.c	2007-06-21 16:32:53.000000000 -0700
+++ linux-2.6.22-rc5-patch/fs/ext4/super.c	2007-06-21 16:30:22.000000000 -0700
@@ -1232,7 +1232,7 @@ static int ext4_setup_super(struct super
 	return res;
 }
 
-#if !defined(CONFIG_CRC16) && !defined(CONFIG_CRC16_MODULE)
+#if !defined(CONFIG_CRC16)
 /** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
 __u16 const crc16_table[256] = {
 	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,

--------------070006050303090506060008--
