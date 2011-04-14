From: Shaohua Li <shaohua.li@intel.com>
Subject: [PATCH]ext4: delete dead code
Date: Thu, 14 Apr 2011 10:10:32 +0800
Message-ID: <1302747032.3981.181.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56831 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab1DNCK4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Apr 2011 22:10:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

percpu_counter_sum_positive never returns negative.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 fs/ext4/balloc.c |    5 -----
 1 file changed, 5 deletions(-)

Index: linux/fs/ext4/balloc.c
===================================================================
--- linux.orig/fs/ext4/balloc.c	2011-04-12 16:22:59.000000000 +0800
+++ linux/fs/ext4/balloc.c	2011-04-13 13:23:01.000000000 +0800
@@ -507,11 +507,6 @@ static int ext4_has_free_blocks(struct e
 						EXT4_FREEBLOCKS_WATERMARK) {
 		free_blocks  = percpu_counter_sum_positive(fbc);
 		dirty_blocks = percpu_counter_sum_positive(dbc);
-		if (dirty_blocks < 0) {
-			printk(KERN_CRIT "Dirty block accounting "
-					"went wrong %lld\n",
-					(long long)dirty_blocks);
-		}
 	}
 	/* Check whether we have space after
 	 * accounting for current dirty blocks & root reserved blocks.


