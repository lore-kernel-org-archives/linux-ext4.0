From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] fix bb_prealloc_list corruption due to wrong group
	locking
Date: Mon, 16 Mar 2009 11:14:27 +0530
Message-ID: <20090316054427.GA17376@skywalker>
References: <49BAD6D9.3010505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:59312 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbZCPFoe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2009 01:44:34 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp09.in.ibm.com (8.13.1/8.13.1) with ESMTP id n2G5Ig3v010443
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 10:48:42 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n2G5ibOJ4206736
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 11:14:37 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id n2G5iS4Z001774
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 16:44:28 +1100
Content-Disposition: inline
In-Reply-To: <49BAD6D9.3010505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 13, 2009 at 04:57:45PM -0500, Eric Sandeen wrote:
> This is for Red Hat bug 490026,
> EXT4 panic, list corruption in ext4_mb_new_inode_pa
> 
> (this was on backported ext4 from 2.6.29)
> 
> We hit a BUG() in __list_add from  ext4_mb_new_inode_pa()
> because the list head pointed to a removed item:
> 
> list_add corruption. next->prev should be ffff81042f2fe158,
> but was 0000000000200200
> 
> (0000000000200200 is LIST_POISON2, set when the item is deleted)
> 
> ext4_lock_group(sb, group) is supposed to protect this list for
> each group, and a common code flow is this:
> 
>     ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
>     ext4_lock_group(sb, grp);
>     list_del(&pa->pa_group_list);
>     ext4_unlock_group(sb, grp);
> 
> so its critical that we get the right group number back for
> this pa->pa_pstart block.
> 
> however, ext4_mb_put_pa passes in (pa->pa_pstart - 1) with a 
> comment, "-1 is to protect from crossing allocation group"
> 
> Other list-manipulators do not use the "-1" so we have the 
> potential to lock the wrong group and race.  Given how the 
> ext4_get_group_no_and_offset() function works, it doesn't seem
> to me that the subtraction is correct.
> 
> I've not been able to reproduce the bug, so this is by inspection.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Index: linux-2.6/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.orig/fs/ext4/mballoc.c
> +++ linux-2.6/fs/ext4/mballoc.c
> @@ -3603,8 +3603,7 @@ static void ext4_mb_put_pa(struct ext4_a
>  	pa->pa_deleted = 1;
>  	spin_unlock(&pa->pa_lock);
> 
> -	/* -1 is to protect from crossing allocation group */
> -	ext4_get_group_no_and_offset(sb, pa->pa_pstart - 1, &grp, NULL);
> +	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
> 
>  	/*
>  	 * possible race:
> 


But the change is needed for lg prealloc space because locality group
prealloc reduce pa_pstart on block allocation and once fully allocated
pa_pstart can point to the next block group. But what you found is also
correct for inode prealloc space. I guess the code broke due to FLEX_BG
because without FLEX_BG pa_pstart will never be the first block in the
group so even for inode prealloc space pa_pstart - 1 would be in the
same group. You may want to do

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4415bee..b4656f7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3585,11 +3585,10 @@ static void ext4_mb_pa_callback(struct rcu_head *head)
  * drops a reference to preallocated space descriptor
  * if this was the last reference and the space is consumed
  */
-static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
-			struct super_block *sb, struct ext4_prealloc_space *pa)
+static void ext4_mb_put_pa(struct super_block *sb,
+			ext4_group_t grp, struct ext4_prealloc_space *pa)
 {
-	ext4_group_t grp;
-
+	
 	if (!atomic_dec_and_test(&pa->pa_count) || pa->pa_free != 0)
 		return;
 
@@ -3602,10 +3601,7 @@ static void ext4_mb_put_pa(struct ext4_allocation_context *ac,
 
 	pa->pa_deleted = 1;
 	spin_unlock(&pa->pa_lock);
-
-	/* -1 is to protect from crossing allocation group */
-	ext4_get_group_no_and_offset(sb, pa->pa_pstart - 1, &grp, NULL);
-
+	
 	/*
 	 * possible race:
 	 *
@@ -4469,8 +4465,11 @@ static void ext4_mb_add_n_trim(struct ext4_allocation_context *ac)
  */
 static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 {
+	ext4_group_t grp;
 	struct ext4_prealloc_space *pa = ac->ac_pa;
 	if (pa) {
+		ext4_get_group_no_and_offset(ac->ac_sb,
+					pa->pa_pstart, &grp, NULL);
 		if (pa->pa_linear) {
 			/* see comment in ext4_mb_use_group_pa() */
 			spin_lock(&pa->pa_lock);
@@ -4497,7 +4496,7 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 			spin_unlock(pa->pa_obj_lock);
 			ext4_mb_add_n_trim(ac);
 		}
-		ext4_mb_put_pa(ac, ac->ac_sb, pa);
+		ext4_mb_put_pa(ac->ac_sb, grp, pa);
 	}
 	if (ac->ac_bitmap_page)
 		page_cache_release(ac->ac_bitmap_page);
