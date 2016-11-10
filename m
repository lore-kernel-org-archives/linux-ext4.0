From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH V2] ext4: ext4_mb_seq_groups_show: Fix stack memory
 corruption
Date: Thu, 10 Nov 2016 18:13:46 +0100
Message-ID: <20161110171346.GA31098@quack2.suse.cz>
References: <1478756764-4459-1-git-send-email-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger@dilger.ca
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45270 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934264AbcKJRNu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 10 Nov 2016 12:13:50 -0500
Content-Disposition: inline
In-Reply-To: <1478756764-4459-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-11-16 11:16:04, Chandan Rajendra wrote:
> The number of 'counters' elements needed in 'struct sg' is
> super_block->s_blocksize_bits + 2. Presently we have 16 'counters'
> elements in the array. This is insufficient for block sizes >= 32k. In
> such cases the memcpy operation performed in ext4_mb_seq_groups_show()
> would cause stack memory corruption.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changelog: 
> v1->v2: Use EXT4_MAX_BLOCK_LOG_SIZE instead of the integer constant 16.
> 
>  fs/ext4/mballoc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a937ac7..7ae43c5 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2287,7 +2287,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
>  	struct ext4_group_info *grinfo;
>  	struct sg {
>  		struct ext4_group_info info;
> -		ext4_grpblk_t counters[16];
> +		ext4_grpblk_t counters[EXT4_MAX_BLOCK_LOG_SIZE + 2];
>  	} sg;
>  
>  	group--;
> -- 
> 2.5.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
