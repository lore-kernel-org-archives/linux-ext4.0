From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12672] lockdep warning when using ext4 on x86_64
Date: Mon,  9 Feb 2009 00:32:51 -0800 (PST)
Message-ID: <20090209083251.EFCAA108041@picon.linux-foundation.org>
References: <bug-12672-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbZBIIcy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2009 03:32:54 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n198WqNP031110
	for <linux-ext4@vger.kernel.org>; Mon, 9 Feb 2009 00:32:53 -0800
In-Reply-To: <bug-12672-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12672





------- Comment #1 from aneesh.kumar@linux.vnet.ibm.com  2009-02-09 00:32 -------

Can  you try this patch 

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index deba54f..34f3a66 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4476,23 +4476,26 @@ static int ext4_mb_release_context(struct
ext4_allocation_context *ac)
                        pa->pa_free -= ac->ac_b_ex.fe_len;
                        pa->pa_len -= ac->ac_b_ex.fe_len;
                        spin_unlock(&pa->pa_lock);
-                       /*
-                        * We want to add the pa to the right bucket.
-                        * Remove it from the list and while adding
-                        * make sure the list to which we are adding
-                        * doesn't grow big.
-                        */
-                       if (likely(pa->pa_free)) {
-                               spin_lock(pa->pa_obj_lock);
-                               list_del_rcu(&pa->pa_inode_list);
-                               spin_unlock(pa->pa_obj_lock);
-                               ext4_mb_add_n_trim(ac);
-                       }
                }
-               ext4_mb_put_pa(ac, ac->ac_sb, pa);
        }
        if (ac->alloc_semp)
                up_read(ac->alloc_semp);
+       if (pa) {
+               /**
+                * We want to add the pa to the right bucket.
+                * Remove it from the list and while adding
+                * make sure the list to which we are adding
+                * doesn't grow big.
+                */
+               if (likely(pa->pa_free)) {
+                       spin_lock(pa->pa_obj_lock);
+                       list_del_rcu(&pa->pa_inode_list);
+                       spin_unlock(pa->pa_obj_lock);
+                       ext4_mb_add_n_trim(ac);
+               }
+               ext4_mb_put_pa(ac, ac->ac_sb, pa);
+       }
+
        if (ac->ac_bitmap_page)
                page_cache_release(ac->ac_bitmap_page);
        if (ac->ac_buddy_page)


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
