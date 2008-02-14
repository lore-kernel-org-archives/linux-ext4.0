From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] reduce mballoc stack usage with noinline
Date: Thu, 14 Feb 2008 15:19:44 -0800
Message-ID: <1203031185.3637.41.camel@localhost.localdomain>
References: <47A377A7.8030302@redhat.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42113 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765386AbYBNXTx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Feb 2008 18:19:53 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1ENJom8015530
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 18:19:50 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1ENJkwk265684
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 18:19:50 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1ENJkek005954
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 18:19:46 -0500
In-Reply-To: <47A377A7.8030302@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Added in patch queue,

Thanks!

On Fri, 2008-02-01 at 13:48 -0600, Eric Sandeen wrote:
> mballoc.c is a whole lot of static functions, which gcc seems to
> really like to inline.
> 
> With the changes below, on x86, I can at least get from:
> 
> 432 ext4_mb_new_blocks
> 240 ext4_mb_free_blocks
> 208 ext4_mb_discard_group_preallocations
> 188 ext4_mb_seq_groups_show
> 164 ext4_mb_init_cache
> 152 ext4_mb_release_inode_pa
> 136 ext4_mb_seq_history_show
> ...
> 
> to
> 
> 220 ext4_mb_free_blocks
> 188 ext4_mb_seq_groups_show
> 176 ext4_mb_regular_allocator
> 164 ext4_mb_init_cache
> 156 ext4_mb_new_blocks
> 152 ext4_mb_release_inode_pa
> 136 ext4_mb_seq_history_show
> 124 ext4_mb_release_group_pa
> ...
> 
> which still has some big functions in there, but not 432 bytes!
> 
> I wonder if a zone would make sense for struct ext4_allocation_context,
> it's 108 bytes by itself.
> 
> I haven't honestly done any investigation of any performance
> impact of the noinlines; FWIW xfs just took control of inlining,
> and marked almost every non-trivial function as noinline, (although
> the xfs situation was a little more dire) and I don't think they had
> any noticeable performance impact.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> ---
> 
> Index: linux-2.6.24-git9/fs/ext4/mballoc.c
> ===================================================================
> --- linux-2.6.24-git9.orig/fs/ext4/mballoc.c
> +++ linux-2.6.24-git9/fs/ext4/mballoc.c
> @@ -1146,7 +1146,7 @@ out:
>  	return err;
>  }
> 
> -static int ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
> +static noinline int ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
>  		struct ext4_buddy *e4b)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> @@ -1926,7 +1926,7 @@ static int ext4_mb_good_group(struct ext
>  	return 0;
>  }
> 
> -static int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
> +static noinline int ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
>  {
>  	ext4_group_t group;
>  	ext4_group_t i;
> @@ -2433,7 +2433,7 @@ static void ext4_mb_history_init(struct 
>  	/* if we can't allocate history, then we simple won't use it */
>  }
> 
> -static void ext4_mb_store_history(struct ext4_allocation_context *ac)
> +static noinline void ext4_mb_store_history(struct ext4_allocation_context *ac)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
>  	struct ext4_mb_history h;
> @@ -2769,7 +2769,7 @@ int ext4_mb_release(struct super_block *
>  	return 0;
>  }
> 
> -static void ext4_mb_free_committed_blocks(struct super_block *sb)
> +static noinline void ext4_mb_free_committed_blocks(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	int err;
> @@ -2982,7 +2982,7 @@ void exit_ext4_mballoc(void)
>   * Check quota and mark choosed space (ac->ac_b_ex) non-free in bitmaps
>   * Returns 0 if success or error code
>   */
> -static int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
> +static noinline int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
>  				handle_t *handle)
>  {
>  	struct buffer_head *bitmap_bh = NULL;
> @@ -3099,7 +3099,7 @@ static void ext4_mb_normalize_group_requ
>   * Normalization means making request better in terms of
>   * size and alignment
>   */
> -static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
> +static noinline void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  				struct ext4_allocation_request *ar)
>  {
>  	int bsbits, max;
> @@ -3368,7 +3368,7 @@ static void ext4_mb_use_group_pa(struct 
>  /*
>   * search goal blocks in preallocated space
>   */
> -static int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
> +static noinline int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
>  	struct ext4_locality_group *lg;
> @@ -3535,7 +3535,7 @@ static void ext4_mb_put_pa(struct ext4_a
>  /*
>   * creates new preallocated space for given inode
>   */
> -static int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
> +static noinline int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
>  {
>  	struct super_block *sb = ac->ac_sb;
>  	struct ext4_prealloc_space *pa;
> @@ -3622,7 +3622,7 @@ static int ext4_mb_new_inode_pa(struct e
>  /*
>   * creates new preallocated space for locality group inodes belongs to
>   */
> -static int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
> +static noinline int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
>  {
>  	struct super_block *sb = ac->ac_sb;
>  	struct ext4_locality_group *lg;
> @@ -3695,7 +3695,7 @@ static int ext4_mb_new_preallocation(str
>   * the caller MUST hold group/inode locks.
>   * TODO: optimize the case when there are no in-core structures yet
>   */
> -static int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
> +static noinline int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
>  				struct buffer_head *bitmap_bh,
>  				struct ext4_prealloc_space *pa)
>  {
> @@ -3755,7 +3755,7 @@ static int ext4_mb_release_inode_pa(stru
>  	return err;
>  }
> 
> -static int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
> +static noinline int ext4_mb_release_group_pa(struct ext4_buddy *e4b,
>  				struct ext4_prealloc_space *pa)
>  {
>  	struct ext4_allocation_context ac;
> @@ -3791,7 +3791,7 @@ static int ext4_mb_release_group_pa(stru
>   * - how many do we discard
>   *   1) how many requested
>   */
> -static int ext4_mb_discard_group_preallocations(struct super_block *sb,
> +static noinline int ext4_mb_discard_group_preallocations(struct super_block *sb,
>  					ext4_group_t group, int needed)
>  {
>  	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
> @@ -4113,7 +4113,7 @@ static void ext4_mb_group_or_file(struct
>  	mutex_lock(&ac->ac_lg->lg_mutex);
>  }
> 
> -static int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
> +static noinline int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
>  				struct ext4_allocation_request *ar)
>  {
>  	struct super_block *sb = ar->inode->i_sb;
> @@ -4337,7 +4337,7 @@ static void ext4_mb_poll_new_transaction
>  	ext4_mb_free_committed_blocks(sb);
>  }
> 
> -static int ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
> +static noinline int ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
>  			  ext4_group_t group, ext4_grpblk_t block, int count)
>  {
>  	struct ext4_group_info *db = e4b->bd_info;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
