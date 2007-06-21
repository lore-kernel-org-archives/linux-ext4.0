From: Mingming Cao <cmm@us.ibm.com>
Subject: ext4 patch queue rebased to linux2.6.22-rc5
Date: Wed, 20 Jun 2007 17:50:01 -0700
Message-ID: <1182387001.22978.26.camel@localhost.localdomain>
References: <1181766059.3887.22.camel@dyn9047017103.beaverton.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, avmathur@us.ibm.com,
	alex@clusterfs.com, Girish Shilamkar <girish@clusterfs.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49231 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbXFUAuE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Jun 2007 20:50:04 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5L0o3Kf016506
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 20:50:03 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5L0o3As477112
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 20:50:03 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5L0o2IV023278
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 20:50:03 -0400
In-Reply-To: <1181766059.3887.22.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

http://repo.or.cz/w/ext4-patch-queue.git

diff --git a/series b/series


index d68345c..766f3eb 100644 (file)


--- a/series

+++ b/series

@@ -1,4 +1,4 @@

-# Rebased the patches to 2.6.22-rc4

+# Rebased the patches to 2.6.22-rc5

 

 # Add mount option to turn off extents

 ext4_noextent_mount_opt.patch

@@ -60,6 +60,14 @@ jbd-stats-through-procfs

 # Remove 32000 subdirs limit. 

 ext4_remove_subdirs_limit.patch

 

+# Add unused inode watermark and checksum to blockgroup descriptors

+ext4_uninit_blockgroup.patch

+# need sign off

+update-uninit.patch

+

+# Need sing off and fix coding style

+# Add journal checksums

+ext4-journal_chksum-2.6.20.patch

 ##############################################################

 # Unstable patches

 # Note: still lots of outstanding comments from linux-ext4 list, 12/2006

@@ -81,3 +89,8 @@ ext4_nodelalloc_mount_opt.patch

 

 # Fix error returned from ext4_reserve_global

 ext4_reserve_global_return_error_fix.patch

+

+#Fix invariant checking in ext4_rebalance_reservation()

+#Missing signed offs

+ext4_rebalance_reservation_invariant_checking_fix.patch

+ext4_delalloc_setpageprivate_fix.patch
