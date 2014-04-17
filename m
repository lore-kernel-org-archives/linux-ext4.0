From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] ext4: fix COLLAPSE_RANGE failure issue on ext4 with
 1KB block size
Date: Thu, 17 Apr 2014 10:25:56 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404171017220.2143@localhost.localdomain>
References: <002901cf59c3$16b21ca0$441655e0$@samsung.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1131679023-1397723159=:2143"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Namjae Jeon <namjae.jeon@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbaDQI0F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Apr 2014 04:26:05 -0400
In-Reply-To: <002901cf59c3$16b21ca0$441655e0$@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1131679023-1397723159=:2143
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT

On Thu, 17 Apr 2014, Namjae Jeon wrote:

> Date: Thu, 17 Apr 2014 07:27:45 +0900
> From: Namjae Jeon <namjae.jeon@samsung.com>
> To: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
>     'Luká¹ Czerner' <lczerner@redhat.com>
> Subject: [PATCH 1/3] ext4: fix COLLAPSE_RANGE failure issue on ext4 with 1KB
>     block size
> 
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> When formatting with 1KB or 2KB(not aligned with PAGE SIZE) block size,
> xfstests generic/075 and 091 are failing. The offset supplied to function
> truncate_pagecache_range is block size aligned. In this function start offset
> is re-aligned to PAGE_SIZE by rounding_up to the next page boundary.
> Due to this rounding up, old data remains in the page cache when blocksize is
> less than page size and start offset is not aligned with page size.
> In case of collapse range, we need to align start offset to page size boundary
> by doing a round down operation instead of round up.

Great, thanks for finding it.

> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/ext4/extents.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 1bb3e4b..f386dd6 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -5404,8 +5404,8 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  	struct super_block *sb = inode->i_sb;
>  	ext4_lblk_t punch_start, punch_stop;
>  	handle_t *handle;
> -	unsigned int credits;
> -	loff_t new_size;
> +	unsigned int credits, rounding;
> +	loff_t new_size, ioffset;
>  	int ret;
>  
>  	/* Collapse range works only on fs block size aligned offsets. */
> @@ -5428,8 +5428,11 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  			return ret;
>  	}
>  
> +	rounding = max_t(uint, 1 << EXT4_BLOCK_SIZE_BITS(sb), PAGE_CACHE_SIZE);
> +	ioffset = offset & ~(rounding - 1);

That looks like you're expecting that block size might be bigger
than page size. That's definitely not the case at the moment as we
can not have block size > page size. There is a discussion to
support this in the future, but even when the infrastructure is done
we would have to revisit the code anyway. So I do not think this is
needed. Just always round it down to PAGE_SIZE (since that's what
truncate_pagecache is actually using)

> +
>  	/* Write out all dirty pages */
> -	ret = filemap_write_and_wait_range(inode->i_mapping, offset, -1);
> +	ret = filemap_write_and_wait_range(inode->i_mapping, ioffset, -1);
>  	if (ret)
>  		return ret;
>  
> @@ -5451,7 +5454,7 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
>  		goto out_mutex;
>  	}
>  
> -	truncate_pagecache_range(inode, offset, -1);
> +	truncate_pagecache_range(inode, ioffset, -1);

As I mentioned in a different email we can just use
truncate_pagecache(). In fact we should use it because we want to
remove private COWed pages as well I think.

Thanks!
-Lukas

>  
>  	/* Wait for existing dio to complete */
>  	ext4_inode_block_unlocked_dio(inode);
> 
--8323328-1131679023-1397723159=:2143--
