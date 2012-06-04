From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 08/10] ext2: use memweight()
Date: Mon, 4 Jun 2012 12:10:18 +0200
Message-ID: <20120604101018.GC7670@quack.suse.cz>
References: <1338644416-11417-1-git-send-email-akinobu.mita@gmail.com>
 <1338644416-11417-8-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab2FDKKU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Jun 2012 06:10:20 -0400
Content-Disposition: inline
In-Reply-To: <1338644416-11417-8-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 02-06-12 22:40:14, Akinobu Mita wrote:
> Use memweight() to count the total number of bits clear in memory area.
> This change only affects the code segments enabled by EXT2FS_DEBUG.
> 
> This also fixes printk format warning that only reveals with EXT2FS_DEBUG.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: linux-ext4@vger.kernel.org
> ---
> 
> No changes from v1
> 
>  fs/ext2/balloc.c |   22 ++--------------------
>  fs/ext2/ext2.h   |    1 -
>  fs/ext2/ialloc.c |    5 ++++-
>  3 files changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
> index 1c36139..9095500 100644
> --- a/fs/ext2/balloc.c
> +++ b/fs/ext2/balloc.c
> @@ -1442,25 +1442,6 @@ ext2_fsblk_t ext2_new_block(struct inode *inode, unsigned long goal, int *errp)
>  	return ext2_new_blocks(inode, goal, &count, errp);
>  }
>  
> -#ifdef EXT2FS_DEBUG
> -
> -static const int nibblemap[] = {4, 3, 3, 2, 3, 2, 2, 1, 3, 2, 2, 1, 2, 1, 1, 0};
> -
> -unsigned long ext2_count_free (struct buffer_head * map, unsigned int numchars)
> -{
> -	unsigned int i;
> -	unsigned long sum = 0;
> -
> -	if (!map)
> -		return (0);
> -	for (i = 0; i < numchars; i++)
> -		sum += nibblemap[map->b_data[i] & 0xf] +
> -			nibblemap[(map->b_data[i] >> 4) & 0xf];
> -	return (sum);
> -}
> -
> -#endif  /*  EXT2FS_DEBUG  */
> -
  So actually if you look at this function, you see that it counts bits in
map->b_data. That is guaranteed to be long aligned pointer so there's no
need for your memweight(). bitmap_weight() would be enough, especially
given that it can handle number of bits which is not a multiple of
BITS_PER_LONG.

  For ext3 it's the same BTW.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
