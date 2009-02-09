From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [Bug 12672] New: lockdep warning when using ext4 on x86_64
Date: Mon, 9 Feb 2009 15:38:17 +0530
Message-ID: <20090209100817.GC31884@skywalker>
References: <bug-12672-13602@http.bugzilla.kernel.org/> <20090209083236.GB31884@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [202.81.31.146] ([202.81.31.146]:38433 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZBIKI3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 05:08:29 -0500
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id n19A6e1e019257
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 21:06:40 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n19A8iKN340216
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 21:08:44 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n19A8QpP024509
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 21:08:26 +1100
Content-Disposition: inline
In-Reply-To: <20090209083236.GB31884@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Updated patch

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix lockdep warning

We should not call ext4_mb_add_n_trim while holding alloc_semp.

=============================================
[ INFO: possible recursive locking detected ]
2.6.29-rc4-git1-dirty #124
---------------------------------------------
ffsb/3116 is trying to acquire lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<ffffffff8035a6e8>]
 ext4_mb_load_buddy+0xd2/0x343

but task is already holding lock:
 (&meta_group_info[i]->alloc_sem){----}, at: [<ffffffff8035a6e8>]
 ext4_mb_load_buddy+0xd2/0x343

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

 fs/ext4/mballoc.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index deba54f..2b5ffe7 100644
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
+		 * doesn't grow big. We need to release
+		 * alloc_semp before calling ext4_mb_add_n_trim()
+		 */
+		if (pa->pa_linear && likely(pa->pa_free)) {
+			spin_lock(pa->pa_obj_lock);
+			list_del_rcu(&pa->pa_inode_list);
+			spin_unlock(pa->pa_obj_lock);
+			ext4_mb_add_n_trim(ac);
+		}
+		ext4_mb_put_pa(ac, ac->ac_sb, pa);
+	}
 	if (ac->ac_bitmap_page)
 		page_cache_release(ac->ac_bitmap_page);
 	if (ac->ac_buddy_page)
-- 
tg: (d5b5623..) ext4_lockdep (depends on: master)
