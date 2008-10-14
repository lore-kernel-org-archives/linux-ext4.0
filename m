From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Free ext4_prealloc_space using kmem_cache_free
Date: Tue, 14 Oct 2008 12:03:28 +0530
Message-ID: <1223966008-6656-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1223966008-6656-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223966008-6656-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223966008-6656-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223966008-6656-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223966008-6656-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1223966008-6656-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, cmm@us.ibm.com, tytso@mit.edu,
	sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:49206 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753530AbYJNGdw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Oct 2008 02:33:52 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m9E6XneW025334
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 12:03:49 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9E6XnfW995364
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 12:03:49 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m9E6Xm5C005007
	for <linux-ext4@vger.kernel.org>; Tue, 14 Oct 2008 12:03:49 +0530
In-Reply-To: <1223966008-6656-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should use kmem_cache_free to free memory allocated
via kmem_cache_alloc

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7023228..c22b904 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2569,7 +2569,7 @@ static void ext4_mb_cleanup_pa(struct ext4_group_info *grp)
 		pa = list_entry(cur, struct ext4_prealloc_space, pa_group_list);
 		list_del(&pa->pa_group_list);
 		count++;
-		kfree(pa);
+		kmem_cache_free(ext4_pspace_cachep, pa);
 	}
 	if (count)
 		mb_debug("mballoc: %u PAs left\n", count);
-- 
1.6.0.2.526.g5c283

