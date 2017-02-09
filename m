From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Fix stripe-unaligned allocations
Date: Thu,  9 Feb 2017 16:30:49 +0100
Message-ID: <20170209153050.15317-1-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33857 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751074AbdBIPbg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 9 Feb 2017 10:31:36 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a filesystem is created using:

mkfs.ext4 -b 4096 -E stride=512 <dev>

and we try to allocate 64MB extent, we will end up directly in
ext4_mb_complex_scan_group(). This is because the request is detected as
power-of-two allocation (so we start in ext4_mb_regular_allocator()
with ac_criteria == 0) however the check before
ext4_mb_simple_scan_group() refuses the direct buddy scan because the
allocation request is too large. Since cr == 0, the check whether we
should use ext4_mb_scan_aligned() fails as well and we fall back to
ext4_mb_complex_scan_group().

Fix the problem by checking for upper limit on power-of-two requests
directly when detecting them.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/mballoc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7ae43c59bc79..37db7ba0f69e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2136,8 +2136,10 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	 * We search using buddy data only if the order of the request
 	 * is greater than equal to the sbi_s_mb_order2_reqs
 	 * You can tune it via /sys/fs/ext4/<partition>/mb_order2_req
+	 * We also support searching for power-of-two requests only for
+	 * requests upto maximum buddy size we have constructed.
 	 */
-	if (i >= sbi->s_mb_order2_reqs) {
+	if (i >= sbi->s_mb_order2_reqs && i <= sb->s_blocksize_bits + 2) {
 		/*
 		 * This should tell if fe_len is exactly power of 2
 		 */
@@ -2207,7 +2209,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 			}
 
 			ac->ac_groups_scanned++;
-			if (cr == 0 && ac->ac_2order < sb->s_blocksize_bits+2)
+			if (cr == 0)
 				ext4_mb_simple_scan_group(ac, &e4b);
 			else if (cr == 1 && sbi->s_stripe &&
 					!(ac->ac_g_ex.fe_len % sbi->s_stripe))
-- 
2.10.2
