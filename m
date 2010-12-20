From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Remove warning message from ext4_issue_discard
 helper
Date: Mon, 20 Dec 2010 12:19:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012201218470.12772@dhcp-lab-213.englab.brq.redhat.com>
References: <1290537723-18558-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab0LTLTv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Dec 2010 06:19:51 -0500
In-Reply-To: <1290537723-18558-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 23 Nov 2010, Lukas Czerner wrote:

> ext4_issue_discard is supposed to be helper for calling discard, however
> in case that underlying device does not support discard it prints out
> the warning message and clears the DISCARD t_mount_opt flag. Since it
> can be (and is) used by others, it should not do anything and let the
> caller to handle the error case.
> 
> This commit removes warning message and flag setting from
> ext4_issue_discard and use it just in place where it is really needed
> (release_blocks_on_commit). FITRIM ioctl should not set any flags nor it
> should print out warning messages, so get rid of the warning as well.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/ext4/mballoc.c |   22 ++++++++++------------
>  1 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 5b4d4e3..e479319 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2608,18 +2608,12 @@ int ext4_mb_release(struct super_block *sb)
>  static inline int ext4_issue_discard(struct super_block *sb,
>  		ext4_group_t block_group, ext4_grpblk_t block, int count)
>  {
> -	int ret;
>  	ext4_fsblk_t discard_block;
>  
>  	discard_block = block + ext4_group_first_block_no(sb, block_group);
>  	trace_ext4_discard_blocks(sb,
>  			(unsigned long long) discard_block, count);
> -	ret = sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
> -	if (ret == -EOPNOTSUPP) {
> -		ext4_warning(sb, "discard not supported, disabling");
> -		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
> -	}
> -	return ret;
> +	return sb_issue_discard(sb, discard_block, count, GFP_NOFS, 0);
>  }
>  
>  /*
> @@ -2631,7 +2625,7 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
>  	struct super_block *sb = journal->j_private;
>  	struct ext4_buddy e4b;
>  	struct ext4_group_info *db;
> -	int err, count = 0, count2 = 0;
> +	int err, ret, count = 0, count2 = 0;
>  	struct ext4_free_data *entry;
>  	struct list_head *l, *ltmp;
>  
> @@ -2641,9 +2635,15 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
>  		mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
>  			 entry->count, entry->group, entry);
>  
> -		if (test_opt(sb, DISCARD))
> -			ext4_issue_discard(sb, entry->group,
> +		if (test_opt(sb, DISCARD)) {
> +			ret = ext4_issue_discard(sb, entry->group,
>  					entry->start_blk, entry->count);
> +			if (unlikely(ret == -EOPNOTSUPP)) {
> +				ext4_warning(sb, "discard not supported, "
> +						 "disabling");
> +				clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
> +			}
> +		}
>  
>  		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
>  		/* we expect to find existing buddy because it's pinned */
> @@ -4718,8 +4718,6 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
>  	ext4_unlock_group(sb, group);
>  
>  	ret = ext4_issue_discard(sb, group, start, count);
> -	if (ret)
> -		ext4_std_error(sb, ret);
>  
>  	ext4_lock_group(sb, group);
>  	mb_free_blocks(NULL, e4b, start, ex.fe_len);
> 

Ping
