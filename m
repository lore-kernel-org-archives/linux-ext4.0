From: Dan Ehrenberg <dehrenberg@google.com>
Subject: [PATCH] ext4: Change the handling of RAID stripe width
Date: Wed,  6 Jul 2011 13:47:25 -0700
Message-ID: <1309985245-14835-1-git-send-email-dehrenberg@google.com>
Cc: Dan Ehrenberg <dehrenberg@google.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:46334 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab1GFUrk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 16:47:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously, the stripe width was blindly used for determining the size
of allocations. Now, the stripe width is used as a hint for the initial
mb_group_prealloc; if it is greater than 1, then we make sure that
mb_group_prealloc is some multiple of it, and otherwise it is ignored.
mb_group_prealloc is always usable to adjust the preallocation strategy,
not just when the stripe-width is 0 as before.

Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>
---
 fs/ext4/mballoc.c |   40 +++++++++++++++++++++++++++++-----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6ed859d..710c27f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -127,13 +127,14 @@
  * based on file size. This can be found in ext4_mb_normalize_request. If
  * we are doing a group prealloc we try to normalize the request to
  * sbi->s_mb_group_prealloc. Default value of s_mb_group_prealloc is
- * 512 blocks. This can be tuned via
- * /sys/fs/ext4/<partition/mb_group_prealloc. The value is represented in
- * terms of number of blocks. If we have mounted the file system with -O
+ * 512 blocks. If we have mounted the file system with -O
  * stripe=<value> option the group prealloc request is normalized to the
- * stripe value (sbi->s_stripe)
+ * the smallest multiple of the stripe value (sbi->s_stripe) which is
+ * greater than the default mb_group_prealloc. This can be tuned via
+ * /sys/fs/ext4/<partition>/mb_group_prealloc. The value is represented in
+ * terms of number of blocks.
  *
- * The regular allocator(using the buddy cache) supports few tunables.
+ * The regular allocator (using the buddy cache) supports a few tunables.
  *
  * /sys/fs/ext4/<partition>/mb_min_to_scan
  * /sys/fs/ext4/<partition>/mb_max_to_scan
@@ -2471,7 +2472,26 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	sbi->s_mb_stats = MB_DEFAULT_STATS;
 	sbi->s_mb_stream_request = MB_DEFAULT_STREAM_THRESHOLD;
 	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
+	/*
+	 * If the stripe width is 1, this makes no sense and
+	 * we set it to 0 to turn off stripe handling code.
+	 */
+	if (sbi->s_stripe == 1)
+		sbi->s_stripe = 0;
+
 	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
+	/*
+	 * If there is a s_stripe > 1, then we set the s_mb_group_prealloc
+	 * to the lowest multiple of s_stripe which is bigger than
+	 * the s_mb_group_prealloc as determined above. We want
+	 * the preallocation size to be an exact multiple of the
+	 * RAID stripe size so that preallocations don't fragment
+	 * the stripes.
+	 */
+	if (sbi->s_stripe > 1) {
+		sbi->s_mb_group_prealloc = roundup(
+			sbi->s_mb_group_prealloc, sbi->s_stripe);
+	}
 
 	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
 	if (sbi->s_locality_groups == NULL) {
@@ -2830,8 +2850,9 @@ out_err:
 
 /*
  * here we normalize request for locality group
- * Group request are normalized to s_strip size if we set the same via mount
- * option. If not we set it to s_mb_group_prealloc which can be configured via
+ * Group request are normalized to s_mb_group_prealloc, which goes to
+ * s_strip if we set the same via mount option.
+ * s_mb_group_prealloc can be configured via
  * /sys/fs/ext4/<partition>/mb_group_prealloc
  *
  * XXX: should we try to preallocate more than the group has now?
@@ -2842,10 +2863,7 @@ static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
 	struct ext4_locality_group *lg = ac->ac_lg;
 
 	BUG_ON(lg == NULL);
-	if (EXT4_SB(sb)->s_stripe)
-		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_stripe;
-	else
-		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc;
+	ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_mb_group_prealloc;
 	mb_debug(1, "#%u: goal %u blocks for locality group\n",
 		current->pid, ac->ac_g_ex.fe_len);
 }
-- 
1.7.3.1

