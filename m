From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: ext4_mb_seq_groups_show: Fix stack memory
 corruption
Date: Tue, 8 Nov 2016 10:21:15 +0100
Message-ID: <20161108092115.GG32353@quack2.suse.cz>
References: <1478501141-15651-1-git-send-email-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        adilger@dilger.ca
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49779 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932280AbcKHJVX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Nov 2016 04:21:23 -0500
Content-Disposition: inline
In-Reply-To: <1478501141-15651-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 07-11-16 12:15:41, Chandan Rajendra wrote:
> The number of 'counters' elements needed in 'struct sg' is
> super_block->s_blocksize_bits + 2. Presently we have 16 'counters'
> elements in the array. This is insufficient for block sizes >= 32k. In
> such cases the memcpy operation performed in ext4_mb_seq_groups_show()
> would cause stack memory corruption.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/ext4/mballoc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a937ac7..67e6fcb 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2287,7 +2287,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
>  	struct ext4_group_info *grinfo;
>  	struct sg {
>  		struct ext4_group_info info;
> -		ext4_grpblk_t counters[16];
> +		ext4_grpblk_t counters[16 + 2];

How about using EXT4_MAX_BLOCK_LOG_SIZE + 2? It would be somewhat clearer
what that means...  Having a function returning number of buddy counters in
a group info would be even better (and a constant for maximum number of
counters) but that's an independent cleanup...

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
