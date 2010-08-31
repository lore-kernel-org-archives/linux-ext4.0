From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] ext4: don't bump nr_to_write if LONG_MAX
Date: Tue, 31 Aug 2010 09:04:29 -0500
Message-ID: <4C7D0BED.3070404@redhat.com>
References: <4C7D0A00.40601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab0HaOEc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Aug 2010 10:04:32 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7VE4WiM012954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 31 Aug 2010 10:04:32 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o7VE4Tfc010211
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 31 Aug 2010 10:04:32 -0400
In-Reply-To: <4C7D0A00.40601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In some cases we can reach ext4_da_writepages with
wbc->nr_to_write == LONG_MAX, !range_cyclic, and range_whole=1;
in this case we will try to bump it up by a factor of 8, which
leads to a nr_to_write value of -8.

I think we still get through the logic without changing
wbc->nr_to_write because the other tests which would change
it don't trip, but it seems dangerous to overflow 
desired_nr_to_write in the interim, it's not obvious.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 93497f6..2e72a4a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3004,9 +3004,11 @@ static int ext4_da_writepages(struct address_space *mapping,
 	 * sbi->max_writeback_mb_bump whichever is smaller.
 	 */
 	max_pages = sbi->s_max_writeback_mb_bump << (20 - PAGE_CACHE_SHIFT);
-	if (!range_cyclic && range_whole)
-		desired_nr_to_write = wbc->nr_to_write * 8;
-	else
+	if (!range_cyclic && range_whole) {
+		desired_nr_to_write = wbc->nr_to_write;
+		if (desired_nr_to_write != LONG_MAX)
+			desired_nr_to_write *= 8;
+	} else
 		desired_nr_to_write = ext4_num_dirty_pages(inode, index,
 							   max_pages);
 	if (desired_nr_to_write > max_pages)


