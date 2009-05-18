From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] fix minimum size calculations
Date: Mon, 18 May 2009 17:02:32 -0500
Message-ID: <4A11DAF8.7050706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58120 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZERWCh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 18:02:37 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4IM2Ytg004531
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 18:02:38 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4IM2X0c007118
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 18:02:34 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4IM2WaZ030972
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 18:02:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The extra padding added to the minimum size calculations:

        /*
         * We need to reserve a few extra blocks if extents are
         * enabled, in case we need to grow the extent tree.  The more
         * we shrink the file system, the more space we need.
         */
        if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
                blks_needed += (fs->super->s_blocks_count - blks_needed)/500;

can go quite wrong if we've already added up more "blks_needed"
than our current size, and the above subtraction wraps.  This can
easily happen for a filesystem which is almost completely full.

In this case, just return the current fs size as the minimum and
be done with it.

With this fix we could probably call calculate_minimum_resize_size()
for each resize2fs invocation and refuse to resize smaller than that?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: e2fsprogs/resize/resize2fs.c
===================================================================
--- e2fsprogs.orig/resize/resize2fs.c
+++ e2fsprogs/resize/resize2fs.c
@@ -2003,6 +2003,12 @@ blk_t calculate_minimum_resize_size(ext2
 	blks_needed += overhead;
 
 	/*
+	 * If at this point we've already added up more "needed" than
+	 * the current size, just return current size as minimum.
+	 */
+	if (blks_needed >= fs->super->s_blocks_count)
+		return fs->super->s_blocks_count;
+	/*
 	 * We need to reserve a few extra blocks if extents are
 	 * enabled, in case we need to grow the extent tree.  The more
 	 * we shrink the file system, the more space we need.

