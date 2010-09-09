From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] Don't bump up LLONG_MAX nr_to_write by a factor of 8
Date: Thu, 09 Sep 2010 14:03:37 -0500
Message-ID: <4C892F89.90201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0IITDj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Sep 2010 15:03:39 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o89J3cKd006449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 9 Sep 2010 15:03:38 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o89J3bgZ000890
	for <linux-ext4@vger.kernel.org>; Thu, 9 Sep 2010 15:03:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm uneasy with lots of stuff going on in ext4_da_writepages(),
but bumping nr_to_write from LLONG_MAX to -8 clearly isn't
making anything better, so avoid the multiplier in that case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d88ba4a..65c049c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3004,9 +3004,12 @@ static int ext4_da_writepages(struct address_space *mapping,
 	 * sbi->max_writeback_mb_bump whichever is smaller.
 	 */
 	max_pages = sbi->s_max_writeback_mb_bump << (20 - PAGE_CACHE_SHIFT);
-	if (!range_cyclic && range_whole)
-		desired_nr_to_write = wbc->nr_to_write * 8;
-	else
+	if (!range_cyclic && range_whole) {
+		if (wbc->nr_to_write == LLONG_MAX)
+			desired_nr_to_write = wbc->nr_to_write;
+		else
+			desired_nr_to_write = wbc->nr_to_write * 8;
+	} else
 		desired_nr_to_write = ext4_num_dirty_pages(inode, index,
 							   max_pages);
 	if (desired_nr_to_write > max_pages)

