From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Don't allow lg prealloc list to be grow large.
Date: Tue, 22 Jul 2008 18:06:41 +0530
Message-ID: <20080722123641.GB17860@skywalker>
References: <1216725016-22855-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:37280 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753475AbYGVMh0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2008 08:37:26 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6MCb6Wa008859
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 18:07:12 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6MCb0EV1413270
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 18:07:00 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6MCasaU004309
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 18:06:54 +0530
Content-Disposition: inline
In-Reply-To: <1216725016-22855-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 22, 2008 at 04:40:16PM +0530, Aneesh Kumar K.V wrote:
> Currently locality group prealloc list is freed only when there is a block allocation
> failure. This can result in large number of per cpu locality group prealloc space
> and also make the ext4_mb_use_preallocated expensive. Convert the locality group
> prealloc list to a hash list. The hash index is the order of number of blocks
> in the prealloc space with a max order of 9. When adding prealloc space to the
> list we make sure total entries for each order does not exceed 8. If it is more
> than 8 we discard few entries and make sure the we have only <= 5 entries.
> 
> 

small update to fix the wrong usage of list APIs


diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e058509..f8da1a2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3348,7 +3348,7 @@ static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 		if (!added && pa->pa_free < tmp_pa->pa_free) {
 			/* Add to the tail of the previous entry */
 			list_add_tail_rcu(&pa->pa_inode_list,
-					tmp_pa->pa_inode_list.prev);
+						&tmp_pa->pa_inode_list);
 			added = 1;
 			/* we want to count the total
 			 * number of entries in the list
@@ -3357,7 +3357,7 @@ static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 		lg_prealloc_count++;
 	}
 	if (!added)
-		list_add_tail_rcu(&pa->pa_inode_list, &tmp_pa->pa_inode_list);
+		list_add_tail_rcu(&pa->pa_inode_list, &lg->lg_prealloc_list[order]);
 
 	/* Now trim the list to be not more than 8 elements */
 	if (lg_prealloc_count > 8) {
