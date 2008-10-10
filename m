From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V3 04/11] ext4: Add percpu dirty block accounting.
Date: Thu, 09 Oct 2008 23:58:27 -0500
Message-ID: <48EEE0F3.8060006@redhat.com>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <48EE6D43.7070404@redhat.com> <20081010045211.GC4301@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37376 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYJJE6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Oct 2008 00:58:39 -0400
In-Reply-To: <20081010045211.GC4301@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:

> Can you test this patch

This does fix my 10G-fallocate testcase.

-Eric

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 64eeb9a..6e81c38 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2800,7 +2800,7 @@ void exit_ext4_mballoc(void)
>   */
>  static noinline_for_stack int
>  ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
> -				handle_t *handle)
> +				handle_t *handle, unsigned long reserv_blks)
>  {
>  	struct buffer_head *bitmap_bh = NULL;
>  	struct ext4_super_block *es;
> @@ -2893,7 +2893,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
>  	/*
>  	 * Now reduce the dirty block count also. Should not go negative
>  	 */
> -	percpu_counter_sub(&sbi->s_dirtyblocks_counter, ac->ac_b_ex.fe_len);
> +	percpu_counter_sub(&sbi->s_dirtyblocks_counter, reserv_blks);
>  	if (sbi->s_log_groups_per_flex) {
>  		ext4_group_t flex_group = ext4_flex_group(sbi,
>  							  ac->ac_b_ex.fe_group);
> @@ -4284,12 +4284,13 @@ static int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
>  ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  				 struct ext4_allocation_request *ar, int *errp)
>  {
> +	int freed;
>  	struct ext4_allocation_context *ac = NULL;
>  	struct ext4_sb_info *sbi;
>  	struct super_block *sb;
>  	ext4_fsblk_t block = 0;
> -	int freed;
> -	int inquota;
> +	unsigned long inquota;
> +	unsigned long reserv_blks;
>  
>  	sb = ar->inode->i_sb;
>  	sbi = EXT4_SB(sb);
> @@ -4308,6 +4309,8 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  			return 0;
>  		}
>  	}
> +	/* Number of reserv_blks for both delayed an non delayed allocation */
> +	reserv_blks = ar->len;
>  	while (ar->len && DQUOT_ALLOC_BLOCK(ar->inode, ar->len)) {
>  		ar->flags |= EXT4_MB_HINT_NOPREALLOC;
>  		ar->len--;
> @@ -4353,7 +4356,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>  	}
>  
>  	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
> -		*errp = ext4_mb_mark_diskspace_used(ac, handle);
> +		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_blks);
>  		if (*errp ==  -EAGAIN) {
>  			ac->ac_b_ex.fe_group = 0;
>  			ac->ac_b_ex.fe_start = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

