From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext4: Warn when discard request fails other than
 EOPNOTSUPP
Date: Thu, 8 Nov 2012 12:08:28 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211081208040.19842@dhcp-1-104.brq.redhat.com>
References: <1350648758-3318-1-git-send-email-lczerner@redhat.com> <1350648758-3318-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab2KHLIg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 06:08:36 -0500
In-Reply-To: <1350648758-3318-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 19 Oct 2012, Lukas Czerner wrote:

> Date: Fri, 19 Oct 2012 14:12:38 +0200
> From: Lukas Czerner <lczerner@redhat.com>
> To: linux-ext4@vger.kernel.org
> Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
> Subject: [PATCH 2/2] ext4: Warn when discard request fails other than
>     EOPNOTSUPP
> 
> We should warn user then the discard request fails. However we need to
> exclude -EOPNOTSUPP case since parts of the device might not support it
> while other parts can. So print the kernel warning when the error !=
> -EOPNOTSUPP is returned from ext4_issue_discard().
> 
> We should also handle error cases in batched discard, again excluding
> EOPNOTSUPP.

ping to the series. Any comments here ?

Thanks!
-Lukas

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/mballoc.c |   47 +++++++++++++++++++++++++++++++++++------------
>  1 files changed, 35 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index f8b27bf..cbab0c8 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2607,9 +2607,17 @@ static void ext4_free_data_callback(struct super_block *sb,
>  	mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
>  		 entry->efd_count, entry->efd_group, entry);
>  
> -	if (test_opt(sb, DISCARD))
> -		ext4_issue_discard(sb, entry->efd_group,
> -				   entry->efd_start_cluster, entry->efd_count);
> +	if (test_opt(sb, DISCARD)) {
> +		err = ext4_issue_discard(sb, entry->efd_group,
> +					 entry->efd_start_cluster,
> +					 entry->efd_count);
> +		if (err && err != -EOPNOTSUPP)
> +			ext4_msg(sb, KERN_WARNING, "discard request in"
> +				 " group:%d block:%d count:%d failed"
> +				 " with %d", entry->efd_group,
> +				 entry->efd_start_cluster,
> +				 entry->efd_count, err);
> +	}
>  
>  	err = ext4_mb_load_buddy(sb, entry->efd_group, &e4b);
>  	/* we expect to find existing buddy because it's pinned */
> @@ -4657,8 +4665,16 @@ do_more:
>  		 * with group lock held. generate_buddy look at
>  		 * them with group lock_held
>  		 */
> -		if (test_opt(sb, DISCARD))
> -			ext4_issue_discard(sb, block_group, bit, count);
> +		if (test_opt(sb, DISCARD)) {
> +			err = ext4_issue_discard(sb, block_group, bit, count);
> +			if (err && err != -EOPNOTSUPP)
> +				ext4_msg(sb, KERN_WARNING, "discard request in"
> +					 " group:%d block:%d count:%lu failed"
> +					 " with %d", block_group, bit, count,
> +					 err);
> +		}
> +
> +
>  		ext4_lock_group(sb, block_group);
>  		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
>  		mb_free_blocks(inode, &e4b, bit, count_clusters);
> @@ -4854,10 +4870,11 @@ error_return:
>   * one will allocate those blocks, mark it as used in buddy bitmap. This must
>   * be called with under the group lock.
>   */
> -static void ext4_trim_extent(struct super_block *sb, int start, int count,
> +static int ext4_trim_extent(struct super_block *sb, int start, int count,
>  			     ext4_group_t group, struct ext4_buddy *e4b)
>  {
>  	struct ext4_free_extent ex;
> +	int ret = 0;
>  
>  	trace_ext4_trim_extent(sb, group, start, count);
>  
> @@ -4873,9 +4890,10 @@ static void ext4_trim_extent(struct super_block *sb, int start, int count,
>  	 */
>  	mb_mark_used(e4b, &ex);
>  	ext4_unlock_group(sb, group);
> -	ext4_issue_discard(sb, group, start, count);
> +	ret = ext4_issue_discard(sb, group, start, count);
>  	ext4_lock_group(sb, group);
>  	mb_free_blocks(NULL, e4b, start, ex.fe_len);
> +	return ret;
>  }
>  
>  /**
> @@ -4904,7 +4922,7 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
>  	void *bitmap;
>  	ext4_grpblk_t next, count = 0, free_count = 0;
>  	struct ext4_buddy e4b;
> -	int ret;
> +	int ret = 0;
>  
>  	trace_ext4_trim_all_free(sb, group, start, max);
>  
> @@ -4931,8 +4949,11 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
>  		next = mb_find_next_bit(bitmap, max + 1, start);
>  
>  		if ((next - start) >= minblocks) {
> -			ext4_trim_extent(sb, start,
> -					 next - start, group, &e4b);
> +			ret = ext4_trim_extent(sb, start,
> +					       next - start, group, &e4b);
> +			if (ret && ret != -EOPNOTSUPP)
> +				break;
> +			ret = 0;
>  			count += next - start;
>  		}
>  		free_count += next - start;
> @@ -4953,8 +4974,10 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
>  			break;
>  	}
>  
> -	if (!ret)
> +	if (!ret) {
> +		ret = count;
>  		EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
> +	}
>  out:
>  	ext4_unlock_group(sb, group);
>  	ext4_mb_unload_buddy(&e4b);
> @@ -4962,7 +4985,7 @@ out:
>  	ext4_debug("trimmed %d blocks in the group %d\n",
>  		count, group);
>  
> -	return count;
> +	return ret;
>  }
>  
>  /**
> 
