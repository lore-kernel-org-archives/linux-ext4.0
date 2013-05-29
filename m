From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 2/4] ext4: Fix overflows in SEEK_HOLE, SEEK_DATA
 implementations
Date: Wed, 29 May 2013 21:51:17 +0800
Message-ID: <20130529135117.GA4476@gmail.com>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
 <1369829133-4307-3-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53053 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945Ab3E2NdS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 May 2013 09:33:18 -0400
Received: by mail-pb0-f43.google.com with SMTP id ma3so9270755pbc.16
        for <linux-ext4@vger.kernel.org>; Wed, 29 May 2013 06:33:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1369829133-4307-3-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 29, 2013 at 02:05:31PM +0200, Jan Kara wrote:
> ext4_lblk_t is just u32 so multiplying it by blocksize can easily
> overflow for files larger than 4 GB. Fix that by properly typing the
> block offsets before shifting.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Ah, it's my fault.  Thanks for fixing this.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  fs/ext4/file.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index b1b4d51..b19f0a4 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -312,7 +312,7 @@ static int ext4_find_unwritten_pgoff(struct inode *inode,
>  	blkbits = inode->i_sb->s_blocksize_bits;
>  	startoff = *offset;
>  	lastoff = startoff;
> -	endoff = (map->m_lblk + map->m_len) << blkbits;
> +	endoff = (loff_t)(map->m_lblk + map->m_len) << blkbits;
>  
>  	index = startoff >> PAGE_CACHE_SHIFT;
>  	end = endoff >> PAGE_CACHE_SHIFT;
> @@ -457,7 +457,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
>  		ret = ext4_map_blocks(NULL, inode, &map, 0);
>  		if (ret > 0 && !(map.m_flags & EXT4_MAP_UNWRITTEN)) {
>  			if (last != start)
> -				dataoff = last << blkbits;
> +				dataoff = (loff_t)last << blkbits;
>  			break;
>  		}
>  
> @@ -468,7 +468,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
>  		ext4_es_find_delayed_extent_range(inode, last, last, &es);
>  		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
>  			if (last != start)
> -				dataoff = last << blkbits;
> +				dataoff = (loff_t)last << blkbits;
>  			break;
>  		}
>  
> @@ -486,7 +486,7 @@ static loff_t ext4_seek_data(struct file *file, loff_t offset, loff_t maxsize)
>  		}
>  
>  		last++;
> -		dataoff = last << blkbits;
> +		dataoff = (loff_t)last << blkbits;
>  	} while (last <= end);
>  
>  	mutex_unlock(&inode->i_mutex);
> @@ -540,7 +540,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
>  		ret = ext4_map_blocks(NULL, inode, &map, 0);
>  		if (ret > 0 && !(map.m_flags & EXT4_MAP_UNWRITTEN)) {
>  			last += ret;
> -			holeoff = last << blkbits;
> +			holeoff = (loff_t)last << blkbits;
>  			continue;
>  		}
>  
> @@ -551,7 +551,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
>  		ext4_es_find_delayed_extent_range(inode, last, last, &es);
>  		if (es.es_len != 0 && in_range(last, es.es_lblk, es.es_len)) {
>  			last = es.es_lblk + es.es_len;
> -			holeoff = last << blkbits;
> +			holeoff = (loff_t)last << blkbits;
>  			continue;
>  		}
>  
> @@ -566,7 +566,7 @@ static loff_t ext4_seek_hole(struct file *file, loff_t offset, loff_t maxsize)
>  							      &map, &holeoff);
>  			if (!unwritten) {
>  				last += ret;
> -				holeoff = last << blkbits;
> +				holeoff = (loff_t)last << blkbits;
>  				continue;
>  			}
>  		}
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
