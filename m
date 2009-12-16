From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: flush delalloc blocks when space is low
Date: Wed, 16 Dec 2009 21:46:02 +0100
Message-ID: <20091216204602.GC28425@atrey.karlin.mff.cuni.cz>
References: <4B22D098.3080600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33397 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965045AbZLPUqD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Dec 2009 15:46:03 -0500
Content-Disposition: inline
In-Reply-To: <4B22D098.3080600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Creating many small files in rapid succession on a small
> filesystem can lead to spurious ENOSPC; on a 104MB filesystem:
> 
> for i in `seq 1 22500`; do
>     echo -n > $SCRATCH_MNT/$i
>     echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
> done
> 
> leads to ENOSPC even though after a sync, 40% of the fs is free
> again.
> 
> This is because we reserve worst-case metadata for delalloc writes,
> and when data is allocated that worst-case reservation is not
> usually needed.
> 
> When freespace is low, kicking off an async writeback will start
> converting that worst-case space usage into something more realistic,
> almost always freeing up space to continue.
> 
> This resolves the testcase for me, and survives all 4 generic
> ENOSPC tests in xfstests.
> 
> We'll still need a hard synchronous sync to squeeze out the last bit,
> but this fixes things up to a large degree.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
  Looks good.

  Acked-by: Jan Kara <jack@suse.cz>

							Honza
> ---
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5c5bc5d..5b3f468 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3024,11 +3024,18 @@ static int ext4_nonda_switch(struct super_block *sb)
>  	if (2 * free_blocks < 3 * dirty_blocks ||
>  		free_blocks < (dirty_blocks + EXT4_FREEBLOCKS_WATERMARK)) {
>  		/*
> -		 * free block count is less that 150% of dirty blocks
> -		 * or free blocks is less that watermark
> +		 * free block count is less than 150% of dirty blocks
> +		 * or free blocks is less than watermark
>  		 */
>  		return 1;
>  	}
> +	/*
> +	 * Even if we don't switch but are nearing capacity,
> +	 * start pushing delalloc when 1/2 of free blocks are dirty.
> +	 */
> +	if (free_blocks < 2 * dirty_blocks)
> +		writeback_inodes_sb_if_idle(sb);
> +
>  	return 0;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
