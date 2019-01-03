Return-Path: <SRS0=m/y1=PL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34550 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729118AbfACMG4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 3 Jan 2019 07:06:56 -0500
Subject: Re: [PATCH] ext4: Replace opencoded i_writecount usage with
 inode_is_open_for_write
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
References: <20181211082355.19841-1-nborisov@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <403814af-e9af-3f95-653f-d6ab572d49f3@suse.com>
Date: Thu, 3 Jan 2019 14:06:52 +0200
MIME-Version: 1.0
In-Reply-To: <20181211082355.19841-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 11.12.18 г. 10:23 ч., Nikolay Borisov wrote:
> There is a function which clearly conveys the objective of checking
> i_writecount. Additionally the usage in ext4_mb_initialize_context was
> wrong, since a node would have wrongfully been reported as writable if
> i_writecount had a negative value (MMAP_DENY_WRITE).
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Gentle ping

> ---
>  fs/ext4/inode.c   | 2 +-
>  fs/ext4/mballoc.c | 7 +++----
>  2 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 22a9d8159720..04e5bc0b5c8d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -391,7 +391,7 @@ void ext4_da_update_reserve_space(struct inode *inode,
>  	 * inode's preallocations.
>  	 */
>  	if ((ei->i_reserved_data_blocks == 0) &&
> -	    (atomic_read(&inode->i_writecount) == 0))
> +	    !inode_is_open_for_write(inode))
>  		ext4_discard_preallocations(inode);
>  }
>  
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index e2248083cdca..6fb76d408093 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4176,9 +4176,8 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
>  	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
>  		>> bsbits;
>  
> -	if ((size == isize) &&
> -	    !ext4_fs_is_busy(sbi) &&
> -	    (atomic_read(&ac->ac_inode->i_writecount) == 0)) {
> +	if ((size == isize) && !ext4_fs_is_busy(sbi) &&
> +	    !inode_is_open_for_write(ac->ac_inode)) {
>  		ac->ac_flags |= EXT4_MB_HINT_NOPREALLOC;
>  		return;
>  	}
> @@ -4258,7 +4257,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
>  			(unsigned) ar->goal, ac->ac_flags, ac->ac_2order,
>  			(unsigned) ar->lleft, (unsigned) ar->pleft,
>  			(unsigned) ar->lright, (unsigned) ar->pright,
> -			atomic_read(&ar->inode->i_writecount) ? "" : "non-");
> +			inode_is_open_for_write(ar->inode) ? "" : "non-");
>  	return 0;
>  
>  }
> 
