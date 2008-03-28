From: Pietro Gagliardi <pietro10@mac.com>
Subject: Kernel patch: ext2 creators list update
Date: Fri, 28 Mar 2008 17:54:07 -0400
Message-ID: <B897C02B-AB2F-4888-960A-2B72546BD5C1@mac.com>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: multipart/mixed; boundary=Apple-Mail-1-800781226
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtpoutm.mac.com ([17.148.16.66]:56417 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbYC1WBC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Mar 2008 18:01:02 -0400
Received: from mac.com (asmtp006-s [10.150.69.69])
	by smtpoutm.mac.com (Xserve/smtpout003/MantshX 4.0) with ESMTP id m2SLsDWY004299
	for <linux-ext4@vger.kernel.org>; Fri, 28 Mar 2008 14:54:13 -0700 (PDT)
Received: from [24.185.117.0] (ool-18b97500.dyn.optonline.net [24.185.117.0])
	(authenticated bits=0)
	by mac.com (Xserve/asmtp006/MantshX 4.0) with ESMTP id m2SLsBWs016689
	for <linux-ext4@vger.kernel.org>; Fri, 28 Mar 2008 14:54:12 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-1-800781226
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Hello. I'm working on a new OS that will have ext2 as the primary  
filesystem. I'm adding my OS to the list of creators, for the  
superblock item s_creator_os. I know the kernel doesn't use these  
values; I don't know if any user programs do, though.


--Apple-Mail-1-800781226
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=linux.patch
Content-Disposition: attachment;
	filename=linux.patch

--- linux-2.6.24.4/include/linux/ext2_fs.h.orig	2008-03-24 14:49:18.000000000 -0400
+++ linux-2.6.24.4/include/linux/ext2_fs.h	2008-03-28 17:36:55.000000000 -0400
@@ -426,6 +426,7 @@ struct ext2_super_block {
 #define EXT2_OS_MASIX		2
 #define EXT2_OS_FREEBSD		3
 #define EXT2_OS_LITES		4
+#define EXT2_OS_PGOS        5
 
 /*
  * Revision levels

--Apple-Mail-1-800781226
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed



Enjoy!
- Pietro Gagliardi


--Apple-Mail-1-800781226--
