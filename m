From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] mark several more functions in mballoc.c as noinline
Date: Thu, 25 Jun 2009 12:09:52 -0500
Message-ID: <4A43AF60.70200@redhat.com>
References: <4A425E57.3090109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37031 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbZFYRJv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2009 13:09:51 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n5PH9s9b005203
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2009 13:09:54 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5PH9srk030002
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2009 13:09:54 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n5PH9rFE008871
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2009 13:09:53 -0400
In-Reply-To: <4A425E57.3090109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted noticed a stack-deep callchain through
writepages->ext4_mb_regular_allocator->ext4_mb_init_cache->submit_bh ...

With all the static functions in mballoc.c, gcc helpfully
inlines for us, and we get something like this:

ext4_mb_regular_allocator	(232 bytes stack)
	ext4_mb_init_cache	(232 bytes stack)
		submit_bh	(starts 464 deeper)

the 2 ext4 functions here get several others inlined; by telling
gcc not to inline them, we can save stack space for when we
head off into submit_bh land and associated block layer callchains.
The following noinlined functions are only called once, so this
won't impact any other callchains:

ext4_mb_regular_allocator 			(104) (was 232)
	ext4_mb_find_by_goal			 (56) (noinlined)
	ext4_mb_init_group			 (24) (noinlined)
		ext4_mb_init_cache		(136) (was 232)
			ext4_mb_generate_buddy	 (88) (noinlined)
			ext4_mb_generate_from_pa (40) (noinlined)
			submit_bh
	ext4_mb_simple_scan_group		 (24) (noinlined)
	ext4_mb_scan_aligned			 (56) (noinlined)
	ext4_mb_complex_scan_group		 (40) (noinlined)
	ext4_mb_try_best_found			 (24) (noinlined)

now when we head off into submit_bh() we're only 264 bytes deeper
in stack than when we entered ext4_mb_regular_allocator()
(vs. 464 bytes before).  Every 200 bytes helps.  :)

(V2: do more careful analysis of which inlined functions matter,
rather than the previous shotgun approach)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ed8482e..ed70e2e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -657,7 +657,8 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 	}
 }
 
-static void ext4_mb_generate_buddy(struct super_block *sb,
+static noinline_for_stack
+void ext4_mb_generate_buddy(struct super_block *sb,
 				void *buddy, void *bitmap, ext4_group_t group)
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
@@ -1480,7 +1481,8 @@ static void ext4_mb_measure_extent(struct ext4_allocation_context *ac,
 	ext4_mb_check_limits(ac, e4b, 0);
 }
 
-static int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
+static noinline_for_stack
+int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 					struct ext4_buddy *e4b)
 {
 	struct ext4_free_extent ex = ac->ac_b_ex;
@@ -1507,7 +1509,8 @@ static int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 	return 0;
 }
 
-static int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
+static noinline_for_stack
+int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 				struct ext4_buddy *e4b)
 {
 	ext4_group_t group = ac->ac_g_ex.fe_group;
@@ -1566,7 +1569,8 @@ static int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
  * The routine scans buddy structures (not bitmap!) from given order
  * to max order and tries to find big enough chunk to satisfy the req
  */
-static void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
 					struct ext4_buddy *e4b)
 {
 	struct super_block *sb = ac->ac_sb;
@@ -1609,7 +1613,8 @@ static void ext4_mb_simple_scan_group(struct ext4_allocation_context *ac,
  * In order to optimize scanning, caller must pass number of
  * free blocks in the group, so the routine can know upper limit.
  */
-static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 					struct ext4_buddy *e4b)
 {
 	struct super_block *sb = ac->ac_sb;
@@ -1668,7 +1673,8 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
  * we try to find stripe-aligned chunks for stripe-size requests
  * XXX should do so at least for multiples of stripe size as well
  */
-static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
+static noinline_for_stack
+void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
 				 struct ext4_buddy *e4b)
 {
 	struct super_block *sb = ac->ac_sb;
@@ -1831,7 +1837,8 @@ void ext4_mb_put_buddy_cache_lock(struct super_block *sb,
 
 }
 
-static int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
+static noinline_for_stack
+int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
 {
 
 	int ret;
@@ -3458,7 +3465,8 @@ static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
  * used in in-core bitmap. buddy must be generated from this bitmap
  * Need to be called with ext4 group lock held
  */
-static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
+static noinline_for_stack
+void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group)
 {
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);

