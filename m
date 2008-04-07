From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4:  BUG: sleeping function called from invalid context
Date: Mon,  7 Apr 2008 20:18:52 +0530
Message-ID: <1207579732-9409-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:36552 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYDGOtH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2008 10:49:07 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m37EmiH1001715
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 00:48:44 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m37EqtUR246572
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 00:52:55 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m37En3f1013650
	for <linux-ext4@vger.kernel.org>; Tue, 8 Apr 2008 00:49:03 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We can't do GFP_NOFS allocation after taking ext4_lock_group

BUG: sleeping function called from invalid context at mm/slab.c:3054
in_atomic():1, irqs_disabled():0
1 lock held by vi/2426:
#0:  (&ei->i_data_sem){----}, at: [<c01cf665>] ext4_release_file+0x23/0x66
Pid: 2426, comm: vi Not tainted 2.6.25-rc7 #24
[<c011a3dc>] __might_sleep+0xbe/0xc5
[<c01620c9>] kmem_cache_alloc+0x22/0xa6
[<c01e382a>] ext4_mb_release_inode_pa+0x73/0x1b3
[<c01e6adf>] ext4_mb_discard_inode_preallocations+0x22d/0x2d4
[<c013000a>] ? param_set_ushort+0x32/0x39
[<c01ceba1>] ext4_discard_reservation+0x27/0x6a
[<c01cf66c>] ext4_release_file+0x2a/0x66
[<c0165bd6>] __fput+0xae/0x155
[<c0165e46>] fput+0x17/0x19
[<c0163756>] filp_close+0x50/0x5a
[<c01647c0>] sys_close+0x71/0xad
[<c0104aba>] sysenter_past_esp+0x5f/0xa5

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 09b02fc..0c616b7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3746,9 +3746,9 @@ static int ext4_mb_new_preallocation(struct ext4_allocation_context *ac)
  */
 static noinline int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 				struct buffer_head *bitmap_bh,
-				struct ext4_prealloc_space *pa)
+				struct ext4_prealloc_space *pa,
+				struct ext4_allocation_context *ac)
 {
-	struct ext4_allocation_context *ac;
 	struct super_block *sb = e4b->bd_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned long end;
@@ -3764,8 +3764,6 @@ static noinline int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 	BUG_ON(group != e4b->bd_group && pa->pa_len != 0);
 	end = bit + pa->pa_len;
 
-	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
-
 	if (ac) {
 		ac->ac_sb = sb;
 		ac->ac_inode = pa->pa_inode;
@@ -3810,22 +3808,18 @@ static noinline int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 		 */
 	}
 	atomic_add(free, &sbi->s_mb_discarded);
-	if (ac)
-		kmem_cache_free(ext4_ac_cachep, ac);
 
 	return err;
 }
 
 static noinline int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
-				struct ext4_prealloc_space *pa)
+				struct ext4_prealloc_space *pa,
+				struct ext4_allocation_context *ac)
 {
-	struct ext4_allocation_context *ac;
 	struct super_block *sb = e4b->bd_sb;
 	ext4_group_t group;
 	ext4_grpblk_t bit;
 
-	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
-
 	if (ac)
 		ac->ac_op = EXT4_MB_HISTORY_DISCARD;
 
@@ -3843,7 +3837,6 @@ static noinline int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
 		ac->ac_b_ex.fe_len = pa->pa_len;
 		ac->ac_b_ex.fe_logical = 0;
 		ext4_mb_store_history(ac);
-		kmem_cache_free(ext4_ac_cachep, ac);
 	}
 
 	return 0;
@@ -3864,6 +3857,7 @@ static noinline int ext4_mb_discard_group_preallocations(struct super_block *sb,
 	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_prealloc_space *pa, *tmp;
+	struct ext4_allocation_context *ac;
 	struct list_head list;
 	struct ext4_buddy e4b;
 	int err;
@@ -3891,6 +3885,7 @@ static noinline int ext4_mb_discard_group_preallocations(struct super_block *sb,
 	grp = ext4_get_group_info(sb, group);
 	INIT_LIST_HEAD(&list);
 
+	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 repeat:
 	ext4_lock_group(sb, group);
 	list_for_each_entry_safe(pa, tmp,
@@ -3945,9 +3940,9 @@ repeat:
 		spin_unlock(pa->pa_obj_lock);
 
 		if (pa->pa_linear)
-			ext4_mb_release_group_pa(&e4b, pa);
+			ext4_mb_release_group_pa(&e4b, pa, ac);
 		else
-			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
+			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
 
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
@@ -3955,6 +3950,8 @@ repeat:
 
 out:
 	ext4_unlock_group(sb, group);
+	if (ac)
+		kmem_cache_free(ext4_ac_cachep, ac);
 	ext4_mb_release_desc(&e4b);
 	put_bh(bitmap_bh);
 	return free;
@@ -3975,6 +3972,7 @@ void ext4_mb_discard_inode_preallocations(struct inode *inode)
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bitmap_bh = NULL;
 	struct ext4_prealloc_space *pa, *tmp;
+	struct ext4_allocation_context *ac;
 	ext4_group_t group = 0;
 	struct list_head list;
 	struct ext4_buddy e4b;
@@ -3989,6 +3987,7 @@ void ext4_mb_discard_inode_preallocations(struct inode *inode)
 
 	INIT_LIST_HEAD(&list);
 
+	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 repeat:
 	/* first, collect all pa's in the inode */
 	spin_lock(&ei->i_prealloc_lock);
@@ -4053,7 +4052,7 @@ repeat:
 
 		ext4_lock_group(sb, group);
 		list_del(&pa->pa_group_list);
-		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa);
+		ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
 		ext4_unlock_group(sb, group);
 
 		ext4_mb_release_desc(&e4b);
@@ -4062,6 +4061,8 @@ repeat:
 		list_del(&pa->u.pa_tmp_list);
 		call_rcu(&(pa)->u.pa_rcu, ext4_mb_pa_callback);
 	}
+	if (ac)
+		kmem_cache_free(ext4_ac_cachep, ac);
 }
 
 /*
-- 
1.5.5.rc1.22.g17689.dirty

