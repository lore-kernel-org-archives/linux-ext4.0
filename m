From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: use directio end_io error status to finish
 unwritten aio dio correctly
Date: Fri, 19 Feb 2016 09:02:32 +1100
Message-ID: <20160218220232.GA4262@dastard>
References: <20160218054557.GH6338@birch.djwong.org>
 <20160218060148.GA10571@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32714 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1425045AbcBRWCf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Feb 2016 17:02:35 -0500
Content-Disposition: inline
In-Reply-To: <20160218060148.GA10571@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 17, 2016 at 10:01:48PM -0800, Christoph Hellwig wrote:
> Might help to tell that this is on top of a direct-io.c patch from the
> XFS tree.
> 
> I don't think clearing any flags is the right thing - now that we
> always call ->end_io the code dealing with it in ext4_ext_direct_IO
> can simply be moved to the ->end_io handler.
> 
> Something like the untested patch below:
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 9db04dd..b741c79 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3166,23 +3166,25 @@ static int ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>  {
>          ext4_io_end_t *io_end = iocb->private;
>  
> -	if (size <= 0)
> -		return 0;
> -
>  	/* if not async direct IO just return */
>  	if (!io_end)
>  		return 0;
>  
> +	if (size <= 0) {
> +		WARN_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
> +		goto out;
> +	}

That will still issue a warning when an I/O error occurs on an
unwritten extent.

> +
>  	ext_debug("ext4_end_io_dio(): io_end 0x%p "
>  		  "for inode %lu, iocb 0x%p, offset %llu, size %zd\n",
>   		  iocb->private, io_end->inode->i_ino, iocb, offset,
>  		  size);
>  
> -	iocb->private = NULL;
>  	io_end->offset = offset;
>  	io_end->size = size;
> +out:
>  	ext4_put_io_end(io_end);

Won't that now call ext4_put_io_end() ->
ext4_convert_unwritten_extents() with an uninitialised offset and
size?

i.e. I don't think this prevents warnings, and may make things
worse when real errors occur....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
