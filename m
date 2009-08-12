From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] reject too-large filesystems on 32-bit kernels
Date: Wed, 12 Aug 2009 17:30:23 -0500
Message-ID: <4A83427F.60106@redhat.com>
References: <4A833CED.2010708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33966 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141AbZHLWaY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2009 18:30:24 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n7CMUPo7005524
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 18:30:25 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7CMUO4r006357
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 18:30:24 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n7CMUNkt000613
	for <linux-ext4@vger.kernel.org>; Wed, 12 Aug 2009 18:30:24 -0400
In-Reply-To: <4A833CED.2010708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 will happily mount a > 16T filesystem on a 32-bit box, but
this is not safe; writes to the block device will wrap past 16T
and the page cache can't index past 16T (232 index * 4k pages).

Adding another test to the existing "too many sectors" test
should do the trick.

Add a comment, a relevant return value, and fix the reference
to the CONFIG_LBD(AF) option as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Get error sign right, too much userspace today :)

Index: linux-2.6.29.noarch/fs/ext4/super.c
===================================================================
--- linux-2.6.29.noarch.orig/fs/ext4/super.c
+++ linux-2.6.29.noarch/fs/ext4/super.c
@@ -2274,13 +2274,20 @@ static int ext4_fill_super(struct super_
 		goto failed_mount;
 	}
 
+	/*
+	 * Test whether we have more sectors than will fit in sector_t,
+	 * and whether the max offset is addressable by the page cache.
+	 */
 	if (ext4_blocks_count(es) >
-		    (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) {
+		    (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9) ||
+	    ext4_blocks_count(es) >
+		    (pgoff_t)(~0ULL) >> (PAGE_CACHE_SHIFT - sb->s_blocksize_bits)) {
 		printk(KERN_ERR "EXT4-fs: filesystem on %s:"
-			" too large to mount safely\n", sb->s_id);
+			" too large to mount safely on this system\n", sb->s_id);
 		if (sizeof(sector_t) < 8)
-			printk(KERN_WARNING "EXT4-fs: CONFIG_LBD not "
+			printk(KERN_WARNING "EXT4-fs: CONFIG_LBDAF not "
 					"enabled\n");
+		ret = -EFBIG;
 		goto failed_mount;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

