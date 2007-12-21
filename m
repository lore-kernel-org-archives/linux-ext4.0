From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix the soft lockup with multi block allocator.
Date: Fri, 21 Dec 2007 16:39:50 +0530
Message-ID: <1198235390-18485-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu, adilger@sun.com, bzzz@sun.com, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:50798 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXLULJz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Dec 2007 06:09:55 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id lBLB9m0Q020483
	for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2007 22:09:48 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBLB9rKO3637368
	for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2007 22:09:53 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBLB9rrb030773
	for <linux-ext4@vger.kernel.org>; Fri, 21 Dec 2007 22:09:53 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With the multi block allocator when we don't have prealloc space we discard
the existing preallocaltion data and try to rebuild the buddy cache. While
discarding the loop through the group specific prealloc list. If we find any
particular prealloc space being used we mark the space busy. If we are not
able to find enough free space and if we have any prealloc space busy we loop
back again. With non preempted kernel this tight loop resulted in watchdog
timer triggering soft lockup warning.


Whe we are allocation the block we search the prealloc list and mark the
prealloc space used via incrementing pa_count value. One after succesffuly
allocating the block we need to update the block bitmap and this could
actually involved a disk io if the bitmap need to read from the disk. This
actually cause prealloc space to be marked used for quiet a long time. This
inturn results in the discard logic going on tight loop resulting in watchdog
timer triggering soft lockup warning.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 844765c..cbc8143 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3729,7 +3729,7 @@ static int ext4_mb_discard_group_preallocations(struct super_block *sb,
 	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
-	int busy;
+	int busy = 0;
 	int free = 0;
 
 	mb_debug("discard preallocation for group %lu\n", group);
@@ -3754,20 +3754,12 @@ static int ext4_mb_discard_group_preallocations(struct super_block *sb,
 	INIT_LIST_HEAD(&list);
 
 repeat:
-	busy = 0;
 	ext4_lock_group(sb, group);
 	list_for_each_entry_safe(pa, tmp,
 				&grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
 		if (atomic_read(&pa->pa_count)) {
 			spin_unlock(&pa->pa_lock);
-			/* FIXME!!
-			 * It is quiet natural to have the pa being
-			 * used on other cpus when we are trying free
-			 * space
-			printk(KERN_ERR "uh! busy PA\n");
-			dump_stack();
-			*/
 			busy = 1;
 			continue;
 		}
@@ -3790,7 +3782,9 @@ repeat:
 
 	/* if we still need more blocks and some PAs were used, try again */
 	if (free < needed && busy) {
+		busy = 0;
 		ext4_unlock_group(sb, group);
+		schedule_timeout(HZ);
 		goto repeat;
 	}
 
-- 
1.5.4.rc0-dirty
