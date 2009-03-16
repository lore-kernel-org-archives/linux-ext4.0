From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Rename pa_linear to pa_type
Date: Mon, 16 Mar 2009 12:54:34 -0500
Message-ID: <49BE925A.5060108@redhat.com>
References: <1237225207-1649-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41415 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbZCPRyu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 13:54:50 -0400
In-Reply-To: <1237225207-1649-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Impact: code cleanup
> 
> This patch rename pa_linear to pa_type and add MB_INODE_PA
> and MB_GROUP_PA to indicate inode and group prealloc space.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Seems reasonable to me.  Though I might not put "inode or group" in the
pa_type comments just because that might possibly change later.   Not a
big deal though.

Especially this part:

-		if (pa->pa_linear)
+		if (pa->pa_type == MB_GROUP_PA)
 			ext4_mb_release_group_pa(&e4b, pa, ac);

is a lot clearer; other tests for linear did have a bit more to do with
linear use but that's not abstracted enough; it really is inode or group
use.  It might be worth keeping a comment somewhere though that the
group prealloc is still used in a linear fashion?

but those are nitpicks...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/ext4/mballoc.c |   14 +++++++-------
>  fs/ext4/mballoc.h |    7 +++++--
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 4415bee..72331ce 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3696,7 +3696,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
>  	INIT_LIST_HEAD(&pa->pa_inode_list);
>  	INIT_LIST_HEAD(&pa->pa_group_list);
>  	pa->pa_deleted = 0;
> -	pa->pa_linear = 0;
> +	pa->pa_type = MB_INODE_PA;
>  
>  	mb_debug("new inode pa %p: %llu/%u for %u\n", pa,
>  			pa->pa_pstart, pa->pa_len, pa->pa_lstart);
> @@ -3759,7 +3759,7 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
>  	INIT_LIST_HEAD(&pa->pa_inode_list);
>  	INIT_LIST_HEAD(&pa->pa_group_list);
>  	pa->pa_deleted = 0;
> -	pa->pa_linear = 1;
> +	pa->pa_type = MB_GROUP_PA;
>  
>  	mb_debug("new group pa %p: %llu/%u for %u\n", pa,
>  		 pa->pa_pstart, pa->pa_len, pa->pa_lstart);
> @@ -4013,7 +4013,7 @@ repeat:
>  		list_del_rcu(&pa->pa_inode_list);
>  		spin_unlock(pa->pa_obj_lock);
>  
> -		if (pa->pa_linear)
> +		if (pa->pa_type == MB_GROUP_PA)
>  			ext4_mb_release_group_pa(&e4b, pa, ac);
>  		else
>  			ext4_mb_release_inode_pa(&e4b, bitmap_bh, pa, ac);
> @@ -4113,7 +4113,7 @@ repeat:
>  	spin_unlock(&ei->i_prealloc_lock);
>  
>  	list_for_each_entry_safe(pa, tmp, &list, u.pa_tmp_list) {
> -		BUG_ON(pa->pa_linear != 0);
> +		BUG_ON(pa->pa_type != MB_INODE_PA);
>  		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
>  
>  		err = ext4_mb_load_buddy(sb, group, &e4b);
> @@ -4365,7 +4365,7 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
>  			continue;
>  		}
>  		/* only lg prealloc space */
> -		BUG_ON(!pa->pa_linear);
> +		BUG_ON(pa->pa_type != MB_GROUP_PA);
>  
>  		/* seems this one can be freed ... */
>  		pa->pa_deleted = 1;
> @@ -4471,7 +4471,7 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
>  {
>  	struct ext4_prealloc_space *pa = ac->ac_pa;
>  	if (pa) {
> -		if (pa->pa_linear) {
> +		if (pa->pa_type == MB_GROUP_PA) {
>  			/* see comment in ext4_mb_use_group_pa() */
>  			spin_lock(&pa->pa_lock);
>  			pa->pa_pstart += ac->ac_b_ex.fe_len;
> @@ -4491,7 +4491,7 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
>  		 * doesn't grow big.  We need to release
>  		 * alloc_semp before calling ext4_mb_add_n_trim()
>  		 */
> -		if (pa->pa_linear && likely(pa->pa_free)) {
> +		if ((pa->pa_type == MB_GROUP_PA) && likely(pa->pa_free)) {
>  			spin_lock(pa->pa_obj_lock);
>  			list_del_rcu(&pa->pa_inode_list);
>  			spin_unlock(pa->pa_obj_lock);
> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
> index 10a2921..340cc4b 100644
> --- a/fs/ext4/mballoc.h
> +++ b/fs/ext4/mballoc.h
> @@ -132,12 +132,15 @@ struct ext4_prealloc_space {
>  	ext4_lblk_t		pa_lstart;	/* log. block */
>  	unsigned short		pa_len;		/* len of preallocated chunk */
>  	unsigned short		pa_free;	/* how many blocks are free */
> -	unsigned short		pa_linear;	/* consumed in one direction
> -						 * strictly, for grp prealloc */
> +	unsigned short		pa_type;	/* pa type. inode or group */
>  	spinlock_t		*pa_obj_lock;
>  	struct inode		*pa_inode;	/* hack, for history only */
>  };
>  
> +enum {
> +	MB_INODE_PA = 0,
> +	MB_GROUP_PA = 1
> +};
>  
>  struct ext4_free_extent {
>  	ext4_lblk_t fe_logical;

