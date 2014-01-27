From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Fix race when checking i_size on direct i/o read
Date: Mon, 27 Jan 2014 11:13:05 +0100
Message-ID: <20140127101305.GB24480@quack.suse.cz>
References: <1387456073.2763.20.camel@menhir>
 <20131219224400.GC31386@dastard>
 <1387531724.2739.13.camel@menhir>
 <20131223030006.GD3220@dastard>
 <1389712933.2790.31.camel@menhir>
 <20140114191901.GC27863@quack.suse.cz>
 <20140115071933.GA3449@gmail.com>
 <1389886553.2779.32.camel@menhir>
 <CAJfpegtffQj1Rk0UM6nd0yBpbnS8kXjN-1j04gt1hnZefLZJ9w@mail.gmail.com>
 <1390574542.2707.14.camel@menhir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Zheng Liu <gnehzuil.liu@gmail.com>, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Christoph Hellwig <hch@infradead.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Chris Mason <clm@fb.com>,
	Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbaA0KNJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jan 2014 05:13:09 -0500
Content-Disposition: inline
In-Reply-To: <1390574542.2707.14.camel@menhir>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 24-01-14 14:42:22, Steven Whitehouse wrote:
> 
> So far I've had one ACK for this, and no other comments. So I think it
> is probably time to send this via some suitable tree. I'm guessing that
> the vfs tree would be the most appropriate route, but not sure that
> there is one at the moment (don't see anything recent at kernel.org)
> so in that case I think -mm is the "back up plan". Al, please let me
> know if you will take this?
> 
> Steve.
> 
> ---------------------
> 
> Following on from the "Re: [PATCH v3] vfs: fix a bug when we do some dio
> reads with append dio writes" thread on linux-fsdevel, this patch is my
> current version of the fix proposed as option (b) in that thread.
  I think it would be good to have a full information about the race we are
trying to solve and why your patch fixes it in the changelog. We can still
defer to list archives for the discussion why you've decided to fix it the
way you've fixed it.

Other than that I agree with the change so feel free to add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> Removing the i_size test from the direct i/o read path at vfs level
> means that filesystems now have to deal with requests which are beyond
> i_size themselves. These I've divided into three sets:
> 
>  a) Those with "no op" ->direct_IO (9p, cifs, ceph)
> These are obviously not going to be an issue
> 
>  b) Those with "home brew" ->direct_IO (nfs, fuse)
> I've been told that NFS should not have any problem with the larger
> i_size, however I've added an extra test to FUSE to duplicate the
> original behaviour just to be on the safe side.
> 
>  c) Those using __blockdev_direct_IO()
> These call through to ->get_block() which should deal with the EOF
> condition correctly. I've verified that with GFS2 and I believe that
> Zheng has verified it for ext4. I've also run the test on XFS and it
> passes both before and after this change.
> 
> The part of the patch in filemap.c looks a lot larger than it really is
> - there are only two lines of real change. The rest is just indentation
> of the contained code.
> 
> There remains a test of i_size though, which was added for btrfs. It
> doesn't cause the other filesystems a problem as the test is performed
> after ->direct_IO has been called. It is possible that there is a race
> that does matter to btrfs, however this patch doesn't change that, so
> its still an overall improvement.
> 
> 
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Reported-by: Zheng Liu <gnehzuil.liu@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <david@fromorbit.com>
> Acked-by: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 74f6ca5..77bcc30 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2727,6 +2727,9 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
>  	inode = file->f_mapping->host;
>  	i_size = i_size_read(inode);
>  
> +	if ((rw == READ) && (offset > i_size))
> +		return 0;
> +
>  	/* optimization for short read */
>  	if (async_dio && rw != WRITE && offset + count > i_size) {
>  		if (offset >= i_size)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 7a7f3e0..d56d3c1 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1428,30 +1428,28 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  		if (!count)
>  			goto out; /* skip atime */
>  		size = i_size_read(inode);
> -		if (pos < size) {
> -			retval = filemap_write_and_wait_range(mapping, pos,
> +		retval = filemap_write_and_wait_range(mapping, pos,
>  					pos + iov_length(iov, nr_segs) - 1);
> -			if (!retval) {
> -				retval = mapping->a_ops->direct_IO(READ, iocb,
> -							iov, pos, nr_segs);
> -			}
> -			if (retval > 0) {
> -				*ppos = pos + retval;
> -				count -= retval;
> -			}
> +		if (!retval) {
> +			retval = mapping->a_ops->direct_IO(READ, iocb,
> +							   iov, pos, nr_segs);
> +		}
> +		if (retval > 0) {
> +			*ppos = pos + retval;
> +			count -= retval;
> +		}
>  
> -			/*
> -			 * Btrfs can have a short DIO read if we encounter
> -			 * compressed extents, so if there was an error, or if
> -			 * we've already read everything we wanted to, or if
> -			 * there was a short read because we hit EOF, go ahead
> -			 * and return.  Otherwise fallthrough to buffered io for
> -			 * the rest of the read.
> -			 */
> -			if (retval < 0 || !count || *ppos >= size) {
> -				file_accessed(filp);
> -				goto out;
> -			}
> +		/*
> +		 * Btrfs can have a short DIO read if we encounter
> +		 * compressed extents, so if there was an error, or if
> +		 * we've already read everything we wanted to, or if
> +		 * there was a short read because we hit EOF, go ahead
> +		 * and return.  Otherwise fallthrough to buffered io for
> +		 * the rest of the read.
> +		 */
> +		if (retval < 0 || !count || *ppos >= size) {
> +			file_accessed(filp);
> +			goto out;
>  		}
>  	}
>  
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
