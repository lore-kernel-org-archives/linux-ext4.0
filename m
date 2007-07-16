From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] Update series file
Date: Mon, 16 Jul 2007 20:51:35 +0530
Message-ID: <469B8CFF.8040303@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:56993 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbXGPPV6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jul 2007 11:21:58 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l6GFievL294692
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2007 01:44:49 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6GFPANb126836
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2007 01:25:11 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6GFLcRm022794
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2007 01:21:38 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I think the series file got updated wrongly

-aneesh

diff --git a/series b/series
index 183d72e..bf34353 100644
--- a/series
+++ b/series
@@ -2,14 +2,10 @@
 
 # fallocate() syscall patches and ext4 fallocate() implementation
 # Missing manpages
-ext4-fallocate-1-syscall_i386_amd64_ppc
-ext4-fallocate-2-syscall_s390
-ext4-fallocate-3-syscall_ia64
-ext4-fallocate-4-new_modes
-ext4-fallocate-5-ext4_support
-ext4-fallocate-6-uninit_write_support
-ext4-fallocate-7-ext4_new_modes
-ext4-fallocate-8-new-ondisk-format
+ext4-fallocate-2-syscall_i386_amd64_ppc
+ext4-fallocate-3-ext4_support
+ext4-fallocate-4-uninit_write_support
+ext4-fallocate-5-new-ondisk-format
 
 # Add mount option to turn off extents
 ext4_noextent_mount_opt.patch
