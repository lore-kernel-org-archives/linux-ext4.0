From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 12672] New: lockdep warning when using ext4 on x86_64
Date: Mon, 9 Feb 2009 14:02:36 +0530
Message-ID: <20090209083236.GB31884@skywalker>
References: <bug-12672-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:49831 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZBIIck (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 03:32:40 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id n198WbR2024941
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 14:02:37 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n198UAxD3678246
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 14:00:10 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id n198Wa1q018894
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 19:32:36 +1100
Content-Disposition: inline
In-Reply-To: <bug-12672-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Can  you try this patch 

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index deba54f..34f3a66 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4476,23 +4476,26 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 			pa->pa_free -= ac->ac_b_ex.fe_len;
 			pa->pa_len -= ac->ac_b_ex.fe_len;
 			spin_unlock(&pa->pa_lock);
-			/*
-			 * We want to add the pa to the right bucket.
-			 * Remove it from the list and while adding
-			 * make sure the list to which we are adding
-			 * doesn't grow big.
-			 */
-			if (likely(pa->pa_free)) {
-				spin_lock(pa->pa_obj_lock);
-				list_del_rcu(&pa->pa_inode_list);
-				spin_unlock(pa->pa_obj_lock);
-				ext4_mb_add_n_trim(ac);
-			}
 		}
-		ext4_mb_put_pa(ac, ac->ac_sb, pa);
 	}
 	if (ac->alloc_semp)
 		up_read(ac->alloc_semp);
+	if (pa) {
+		/**
+		 * We want to add the pa to the right bucket.
+		 * Remove it from the list and while adding
+		 * make sure the list to which we are adding
+		 * doesn't grow big.
+		 */
+		if (likely(pa->pa_free)) {
+			spin_lock(pa->pa_obj_lock);
+			list_del_rcu(&pa->pa_inode_list);
+			spin_unlock(pa->pa_obj_lock);
+			ext4_mb_add_n_trim(ac);
+		}
+		ext4_mb_put_pa(ac, ac->ac_sb, pa);
+	}
+
 	if (ac->ac_bitmap_page)
 		page_cache_release(ac->ac_bitmap_page);
 	if (ac->ac_buddy_page)
