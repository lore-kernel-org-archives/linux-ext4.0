From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: More ext4 acl/xattr corruption - 4th occurence now
Date: Fri, 15 May 2009 10:25:08 +0530
Message-ID: <20090515045508.GA1279@skywalker>
References: <20090513062634.GE4972@kulgan> <20090514044011.GC11352@mit.edu> <20090514110659.GA5146@kulgan> <20090514132506.GD5146@kulgan> <20090514140732.GI11352@mit.edu> <20090514143014.GH5146@kulgan> <20090514161254.GJ11352@mit.edu> <20090514210244.GL5146@kulgan> <20090514212325.GG21316@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Andreas Dilger <adilger@sun.com>, Alex Tomas <bzzz@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57404 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZEOEz2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 May 2009 00:55:28 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n4F4rnBm025436
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 14:53:49 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4F4tPmJ1437934
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 14:55:25 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4F4tPPC013688
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 14:55:25 +1000
Content-Disposition: inline
In-Reply-To: <20090514212325.GG21316@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 14, 2009 at 05:23:25PM -0400, Theodore Tso wrote:
> On Fri, May 15, 2009 at 06:32:45AM +0930, Kevin Shanahan wrote:
> > Okay, so now I've booted into 2.6.29.3 + check_block_validity patch +
> > short circuit i_cached_extent patch, mounted the fs without
> > nodelalloc. I was able to run the full exchange backup without
> > triggering the check_block_validity error.
> 
> Great!
> 
> So here's the final fix (it replaces the short circuit i_cached_extent
> patch) which I plan to push to Linus.  It should be much less of a
> performance hit than simply short-circuiting i_cached_extent...
> 
> Thanks so much for helping to find track this down!!!  If ever someone
> deserved an "Ext4 Baker Street Irregulars" T-shirt, it would be
> you....
> 
>        	       	   	      	   	      - Ted
> 
> commit 039ed7a483fdcb2dbbc29f00cd0d74c101ab14c5
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Thu May 14 17:09:37 2009 -0400
> 
>     ext4: Fix race in ext4_inode_info.i_cached_extent
>     
>     If one CPU is reading from a file while another CPU is writing to the
>     same file different locations, there is nothing protecting the
>     i_cached_extent structure from being used and updated at the same
>     time.  This could potentially cause the wrong location on disk to be
>     read or written to, including potentially causing the corruption of
>     the block group descriptors and/or inode table.


It should be multiple readers. We don't allow read/write or multiple
writers via ext4_ext_get_blocks. &EXT4_I(inode)->i_data_sem is supposed
to protect read/write and multiple writers. What it allowed was
multiple readers(get_block call with create = 0). And readers did cache
the extent information which it read from the disk. So the fix is
correct, but we need to update the commit message.

Reviewed-by:Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


>     
>     Many thanks to Ken Shannah for helping to track down this problem.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 172656c..e3a55eb 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -1841,11 +1841,13 @@ ext4_ext_put_in_cache(struct inode *inode, ext4_lblk_t block,
>  {
>  	struct ext4_ext_cache *cex;
>  	BUG_ON(len == 0);
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	cex = &EXT4_I(inode)->i_cached_extent;
>  	cex->ec_type = type;
>  	cex->ec_block = block;
>  	cex->ec_len = len;
>  	cex->ec_start = start;
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
>  }
> 
>  /*
> @@ -1902,12 +1904,17 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
>  			struct ext4_extent *ex)
>  {
>  	struct ext4_ext_cache *cex;
> +	int ret = EXT4_EXT_CACHE_NO;
> 
> +	/* 
> +	 * We borrow i_block_reservation_lock to protect i_cached_extent
> +	 */
> +	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>  	cex = &EXT4_I(inode)->i_cached_extent;
> 
>  	/* has cache valid data? */
>  	if (cex->ec_type == EXT4_EXT_CACHE_NO)
> -		return EXT4_EXT_CACHE_NO;
> +		goto errout;
> 
>  	BUG_ON(cex->ec_type != EXT4_EXT_CACHE_GAP &&
>  			cex->ec_type != EXT4_EXT_CACHE_EXTENT);
> @@ -1918,11 +1925,11 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
>  		ext_debug("%u cached by %u:%u:%llu\n",
>  				block,
>  				cex->ec_block, cex->ec_len, cex->ec_start);
> -		return cex->ec_type;
> +		ret = cex->ec_type;
>  	}
> -
> -	/* not in cache */
> -	return EXT4_EXT_CACHE_NO;
> +errout:
> +	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
> +	return ret;
>  }
> 
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
