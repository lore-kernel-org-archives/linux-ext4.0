From: jing zhang <zj.barak@gmail.com>
Subject: [PATCH 2/2] ext4: try to relieve ext4_mb_discard_group_preallocations()
	from hard work in simple way
Date: Fri, 26 Mar 2010 00:20:24 +0800
Message-ID: <ac8f92701003250920v5483d59esd5444aa42ee97ee@mail.gmail.com>
References: <ac8f92701003250824q6aeeac4cw55cb0d913e5a3bd3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:33202 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0CYQUY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Mar 2010 12:20:24 -0400
Received: by pzk32 with SMTP id 32so1791068pzk.4
        for <linux-ext4@vger.kernel.org>; Thu, 25 Mar 2010 09:20:24 -0700 (PDT)
In-Reply-To: <ac8f92701003250824q6aeeac4cw55cb0d913e5a3bd3@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jing Zhang <zj.barak@gmail.com>

Date: Wed Mar 25  23:15:06     2010

The function, ext4_mb_discard_group_preallocations(), works alone as
hard as possible without correct understanding its caller's good thinking.

With more understanding the work, the caller should be responsible for
the mission.

And the callee just does the correct, then feeds back, like chip.

Then both get relieved.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jing Zhang <zj.barak@gmail.com>

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc-11-2.c	2010-03-25 23:56:24.000000000 +0800
@@ -3595,8 +3595,6 @@ ext4_mb_discard_group_preallocations(str
 	struct ext4_allocation_context *ac;
 	struct list_head list;
 	struct ext4_buddy e4b;
-	int err;
-	int busy = 0;
 	int free = 0;

 	mb_debug(1, "discard preallocation for group %u\n", group);
@@ -3611,29 +3609,25 @@ ext4_mb_discard_group_preallocations(str
 		return 0;
 	}

-	err = ext4_mb_load_buddy(sb, group, &e4b);
-	if (err) {
+	if (ext4_mb_load_buddy(sb, group, &e4b)) {
 		ext4_error(sb, __func__, "Error in loading buddy "
 				"information for %u", group);
 		put_bh(bitmap_bh);
 		return 0;
 	}

-	if (needed == 0)
-		needed = EXT4_BLOCKS_PER_GROUP(sb) + 1;

 	INIT_LIST_HEAD(&list);
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 	if (ac)
 		ac->ac_sb = sb;
-repeat:
+
 	ext4_lock_group(sb, group);
 	list_for_each_entry_safe(pa, tmp,
 				&grp->bb_prealloc_list, pa_group_list) {
 		spin_lock(&pa->pa_lock);
 		if (atomic_read(&pa->pa_count)) {
 			spin_unlock(&pa->pa_lock);
-			busy = 1;
 			continue;
 		}
 		if (pa->pa_deleted) {
@@ -3653,23 +3647,6 @@ repeat:
 		list_add(&pa->u.pa_tmp_list, &list);
 	}

-	/* if we still need more blocks and some PAs were used, try again */
-	if (free < needed && busy) {
-		busy = 0;
-		ext4_unlock_group(sb, group);
-		/*
-		 * Yield the CPU here so that we don't get soft lockup
-		 * in non preempt case.
-		 */
-		yield();
-		goto repeat;
-	}
-
-	/* found anything to free? */
-	if (list_empty(&list)) {
-		BUG_ON(free != 0);
-		goto out;
-	}

 	/* now free all selected PAs */
 	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
@@ -3688,7 +3665,7 @@ repeat:
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}

-out:
+
 	ext4_unlock_group(sb, group);
 	if (ac)
 		kmem_cache_free(ext4_ac_cachep, ac);
@@ -4183,14 +4160,24 @@ static int ext4_mb_discard_preallocation
 	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
 	int ret;
 	int freed = 0;
+	int tried = 0;

 	trace_ext4_mb_discard_preallocations(sb, needed);
+again:
 	for (i = 0; i < ngroups && needed > 0; i++) {
 		ret = ext4_mb_discard_group_preallocations(sb, i, needed);
 		freed += ret;
 		needed -= ret;
 	}

+	if (needed > 0)
+		/* log it */
+		mb_debug(1, "%d PAs undiscard\n", needed);
+	if (! freed && ! tried++)
+		/* try to avoid -ENOSPC */
+		goto again;
+	if (! freed)
+		mb_debug(1, "discard PAs failed\n");
 	return freed;
 }
