From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH] ext4: memory leakage in ext4_discard_preallocations
Date: Thu, 18 Mar 2010 20:39:40 +0800
Message-ID: <ac8f92701003180539h7228040bm82a0c69d678ec93b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33959 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab0CRMjl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Mar 2010 08:39:41 -0400
Received: by gyg8 with SMTP id 8so978093gyg.19
        for <linux-ext4@vger.kernel.org>; Thu, 18 Mar 2010 05:39:40 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Thu Mar 18 20:33:44 2010

When unexpected errors occur, there is memory leakage, and more.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ zj/mballoc.c	2010-03-18 20:41:32.000000000 +0800
@@ -3717,6 +3717,7 @@ void ext4_discard_preallocations(struct
 	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
+	int occurs = 0;

 	if (!S_ISREG(inode->i_mode)) {
 		/*BUG_ON(!list_empty(&ei->i_prealloc_list));*/
@@ -3781,6 +3782,7 @@ repeat:
 	}
 	spin_unlock(&ei->i_prealloc_lock);

+best_efforts:
 	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
 		BUG_ON(pa->pa_type != MB_INODE_PA);
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
@@ -3811,6 +3813,12 @@ repeat:
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
+	if (! list_empty(&list)) {
+		if (occurs++ < 2)
+			goto best_efforts;
+		else
+			BUG();
+	}
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
 }
