From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH -v3] ext4: handle writeback of inodes which are being
 freed
Date: Mon, 8 Nov 2010 17:43:32 +1100
Message-ID: <20101108064332.GO13830@dastard>
References: <20101102202013.GA3861@elliptictech.com>
 <20101103181412.GH25614@thunk.org>
 <20101103182229.GA8766@elliptictech.com>
 <20101103205306.GA3627@elliptictech.com>
 <20101107212143.GA28396@thunk.org>
 <20101108011919.GN13830@dastard>
 <20101108050052.GA3099@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ted Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:53596 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751763Ab0KHGnk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Nov 2010 01:43:40 -0500
Content-Disposition: inline
In-Reply-To: <20101108050052.GA3099@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 08, 2010 at 12:00:52AM -0500, Ted Ts'o wrote:
> On Mon, Nov 08, 2010 at 12:19:19PM +1100, Dave Chinner wrote:
> > 
> > Doesn't this mean you are tossing away unwritten extent conversion
> > processing when IO is issued on any inode in the I_WILL_FREE/I_FREEING
> > state, or completing IO after the unmount is in progress?
> 
> Yeah, thanks for pointing that out.  Clearly I must have been
> sleep-deprived, since I had managed to convince myself we'd only end
> up in this situation when the inode had been deleted (as opposed to
> the situation where there's so much memory pressure that we're pushing
> out an inode that still has writebacks pending).
....
> @@ -254,9 +253,30 @@ static void ext4_end_bio(struct bio *bio, int error)
>  		if (!partial_write)
>  			SetPageUptodate(page);
>  	}
> -
>  	io_end->num_io_pages = 0;
>  
> +	if ((inode = io_end->inode) == NULL)
> +		goto no_work;
> +
> +	if (!(inode->i_sb->s_flags & MS_ACTIVE)) {
> +		pr_err("sb umounted, discard end_io request for inode %lu\n",
> +			io_end->inode->i_ino);
> +	no_work:
> +		ext4_free_io_end(io_end);
> +		return;
> +	}

These checks are no longer necessary.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
