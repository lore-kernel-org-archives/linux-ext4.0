From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] update ext4-nanosecond-patch comments
Date: Tue, 29 May 2007 11:18:22 +0530
Message-ID: <20070529054822.GA14186@skywalker.home.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:55278 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbXE2Fs6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 May 2007 01:48:58 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4T5oT4o9056472
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 15:50:29 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4T5q7gj126668
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 15:52:16 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4T5mSxl012811
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 15:48:28 +1000
Received: from localhost (skywalker.in.ibm.com [9.124.35.21])
	by d23av04.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l4T5mRke012780
	for <linux-ext4@vger.kernel.org>; Tue, 29 May 2007 15:48:28 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Also can we have a description of why s_{min, want}_extra_isize
fields are added in the commit message ?



diff --git a/ext4-nanosecond-patch b/ext4-nanosecond-patch
index ceaf339..02d00b7 100644
--- a/ext4-nanosecond-patch
+++ b/ext4-nanosecond-patch
@@ -1,8 +1,8 @@
 This patch is a spinoff of the old nanosecond patches.
 
 It includes some cleanups and addition of a creation timestamp. The
-EXT3_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
-s_{min, want}_extra_isize fields in struct ext3_super_block.
+EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE flag has also been added along with
+s_{min, want}_extra_isize fields in struct ext4_super_block.
 
 Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
 Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
