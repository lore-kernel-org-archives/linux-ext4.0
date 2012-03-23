From: Andi Kleen <ak@linux.intel.com>
Subject: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent cache
Date: Fri, 23 Mar 2012 15:17:15 -0700
Message-ID: <20120323221715.GA6712@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, linux-ext4@vger.kernel.org,
	tim.c.chen@linux.intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26250 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab2CWWR3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Mar 2012 18:17:29 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

We found that the super block cache line containing the extent cache hit/miss 
statistics counters is very hot in IO workloads.  

Besides the counter seems racy anyways and can lose updates because it's not
atomic.

Disabling the counter make a very measurable difference in some IO micro 
benchmarks on a 4S system.

I just disabled it for now because it doesn't seem very useful due to its
racy nature. An alternative would be to turn it into a per cpu counter,
if someone really needs it.

Simple patch to disable it appended.

-Andi

---

Disable statistics counter in ext4

This super bloc cache line is very hot and slows down high IO 
workloads.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74f23c2..7310b0e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2049,10 +2049,12 @@ static int ext4_ext_check_cache(struct inode *inode, ext4_lblk_t block,
 		ret = 1;
 	}
 errout:
+#if 0
 	if (!ret)
 		sbi->extent_cache_misses++;
 	else
 		sbi->extent_cache_hits++;
+#endif
 	trace_ext4_ext_in_cache(inode, block, ret);
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 	return ret;

-- 
ak@linux.intel.com -- Speaking for myself only
