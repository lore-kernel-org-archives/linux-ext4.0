From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/47] libext2fs: support BLKZEROOUT/FALLOC_FL_ZERO_RANGE
 in ext2fs_zero_blocks
Date: Sat, 13 Dec 2014 11:29:17 -0500
Message-ID: <20141213162917.GH17783@thunk.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215152.883.6795.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54500 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbaLMQ3S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Dec 2014 11:29:18 -0500
Content-Disposition: inline
In-Reply-To: <20141107215152.883.6795.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2014 at 01:51:52PM -0800, Darrick J. Wong wrote:
> +		ret = ioctl(data->dev, BLKZEROOUT, range);
> +		if (ret)
> +			goto err;
> +		if (!(data->flags & IO_FLAG_DIRECT_IO)) {
> +#ifdef POSIX_FADV_DONTNEED
> +			ret = posix_fadvise(data->dev, range[0], range[1],
> +					    POSIX_FADV_DONTNEED);
> +			if (ret == 0)
> +				goto err;
> +#endif
> +#ifdef BLKFLSBUF
> +			ret = ioctl(data->dev, BLKFLSBUF, 0);
> +#endif

Why do you need BLKFLSBUF after calling POSIX_FADV_DONTNEED?  The
problem with BLKFLSBUF is that it has a special meaning for ramdisks,
dating back to when the ramdisk was stored only in the buffer cache, namely:

http://www.memegen.com/meme/hotw4i

We could add yet another special case for the ramdisk, but I'm
seriously wondering whether the use of BLKZEROOUT is worth it.  Sure,
it will speed up mke2fs, but with the advent of metadata checksums, we
can skip clearing the journal and the inode table.

    	 	      	      	      	    - Ted
