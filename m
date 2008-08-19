From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Patches for patch queue
Date: Tue, 19 Aug 2008 12:08:34 +0530
Message-ID: <20080819063834.GB6516@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:48752 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753522AbYHSGij (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Aug 2008 02:38:39 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7J6caqq017341
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 12:08:36 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7J6caFL1323046
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 12:08:36 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7J6caEQ010032
	for <linux-ext4@vger.kernel.org>; Tue, 19 Aug 2008 12:08:36 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Mingming,

Some update for patches in the patch queue. I am sending it as a diff
against patch queue so that it makes it easier to apply
The first hunk is a missed return 0 as a part of patch
ext4_invalidate_pages_when_delalloc_alloc_fail.patch

diff --git a/ext4_invalidate_pages_when_delalloc_alloc_fail.patch b/ext4_invalidate_pages_when_delalloc_alloc_fail.patch
index f0722ab..d47d3bf 100644
--- a/ext4_invalidate_pages_when_delalloc_alloc_fail.patch
+++ b/ext4_invalidate_pages_when_delalloc_alloc_fail.patch
@@ -92,7 +92,7 @@ Index: linux-2.6.27-rc3/fs/ext4/inode.c
 +		 * will find the dirty page again
 +		 */
 +		if (err == -EAGAIN)
-+			return;
++			return 0;
 +		/*
 +		 * get block failure will cause us
 +		 * to loop in writepages. Because
diff --git a/fix-delalloc-release-block-reservation-for-truncate b/fix-delalloc-release-block-reservation-for-truncate
index 8dc891b..32f1063 100644
--- a/fix-delalloc-release-block-reservation-for-truncate
+++ b/fix-delalloc-release-block-reservation-for-truncate
@@ -48,8 +48,8 @@ Index: linux-2.6.27-rc3/fs/ext4/inode.c
 +		 * but since this function is called from invalidate
 +		 * page, it's harmless to return without any action
 +		 */
-+		printk(KERN_INFO "ext4 delalloc try to release %d reserved"
-+			    "blocks for inode %lu, but there is no reserved"
++		printk(KERN_INFO "ext4 delalloc try to release %d reserved "
++			    "blocks for inode %lu, but there is no reserved "
 +			    "data blocks\n", to_free, inode->i_ino);
 +		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 +		return;
