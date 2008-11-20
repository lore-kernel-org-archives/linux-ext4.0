From: Peter Staubach <staubach@redhat.com>
Subject: Re: [PATCH 1/5] ext4: unlock group before ext4_error
Date: Thu, 20 Nov 2008 13:35:11 -0500
Message-ID: <4925ADDF.10103@redhat.com>
References: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38020 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbYKTSfg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Nov 2008 13:35:36 -0500
In-Reply-To: <1227205580-27596-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> Otherwise ext4_error will cause BUG because of
> scheduling in atomic context.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/mballoc.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 772e05b..039a5a6 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -460,10 +460,12 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
>  			blocknr +=
>  			    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
>  
> +			ext4_unlock_group(sb, e4b->bd_group);
>  			ext4_error(sb, __func__, "double-free of inode"
>  				   " %lu's block %llu(bit %u in group %u)\n",
>  				   inode ? inode->i_ino : 0, blocknr,
>  				   first + i, e4b->bd_group);
> +			ext4_unlock_group(sb, e4b->bd_group);
>   

This should be ext4_lock_group(sb, e4b->bd_group); shouldn't it?

    Thanx...

       ps

>  		}
>  		mb_clear_bit(first + i, e4b->bd_info->bb_bitmap);
>  	}
> @@ -704,6 +706,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
>  	grp->bb_fragments = fragments;
>  
>  	if (free != grp->bb_free) {
> +		ext4_unlock_group(sb, group);
>  		ext4_error(sb, __func__,
>  			"EXT4-fs: group %u: %u blocks in bitmap, %u in gd\n",
>  			group, free, grp->bb_free);
> @@ -711,6 +714,7 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
>  		 * If we intent to continue, we consider group descritor
>  		 * corrupt and update bb_free using bitmap value
>  		 */
> +		ext4_lock_group(sb, group);
>  		grp->bb_free = free;
>  	}
>  
> @@ -1625,15 +1629,18 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
>  			 * free blocks even though group info says we
>  			 * we have free blocks
>  			 */
> +			ext4_unlock_group(sb, e4b->bd_group);
>  			ext4_error(sb, __func__, "%d free blocks as per "
>  					"group info. But bitmap says 0\n",
>  					free);
> +			ext4_lock_group(sb, e4b->bd_group);
>  			break;
>  		}
>  
>  		mb_find_extent(e4b, 0, i, ac->ac_g_ex.fe_len, &ex);
>  		BUG_ON(ex.fe_len <= 0);
>  		if (free < ex.fe_len) {
> +			ext4_unlock_group(sb, e4b->bd_group);
>  			ext4_error(sb, __func__, "%d free blocks as per "
>  					"group info. But got %d blocks\n",
>  					free, ex.fe_len);
> @@ -1642,6 +1649,7 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
>  			 * indicate that the bitmap is corrupt. So exit
>  			 * without claiming the space.
>  			 */
> +			ext4_lock_group(sb, e4b->bd_group);
>  			break;
>  		}
>  
> @@ -3789,6 +3797,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
>  		bit = next + 1;
>  	}
>  	if (free != pa->pa_free) {
> +		ext4_unlock_group(sb, group);
>  		printk(KERN_CRIT "pa %p: logic %lu, phys. %lu, len %lu\n",
>  			pa, (unsigned long) pa->pa_lstart,
>  			(unsigned long) pa->pa_pstart,
> @@ -3799,6 +3808,7 @@ ext4_mb_release_inode_pa(struct ext4_buddy *e4b, struct buffer_head *bitmap_bh,
>  		 * pa is already deleted so we use the value obtained
>  		 * from the bitmap and continue.
>  		 */
> +		ext4_lock_group(sb, group);
>  	}
>  	atomic_add(free, &sbi->s_mb_discarded);
>  
> @@ -4607,9 +4617,11 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
>  		else if (block >= (entry->start_blk + entry->count))
>  			n = &(*n)->rb_right;
>  		else {
> +			ext4_unlock_group(sb, e4b->bd_group);
>  			ext4_error(sb, __func__,
>  			    "Double free of blocks %d (%d %d)\n",
>  			    block, entry->start_blk, entry->count);
> +			ext4_unlock_group(sb, e4b->bd_group);
>  			return 0;
>  		}
>  	}
>   

