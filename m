From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] delayed allocation for ext4
Date: Sat, 23 Dec 2006 14:31:23 +1100
Message-ID: <20061223033123.GL44411608@melbourne.sgi.com>
References: <m37iwjwumf.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:51779 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752302AbWLWDbe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Dec 2006 22:31:34 -0500
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m37iwjwumf.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 22, 2006 at 11:20:08PM +0300, Alex Tomas wrote:
> 
> Good day,
> 
> probably the previous set of patches (including mballoc/lg)
> is too large. so, I reworked delayed allocation a bit so
> that it can be used on top of regular balloc, though it
> still can be used with extents-enabled files only.
> 
> this time series contains just 3 patches:
> 
>  - booked-page-flag.patch
>    adds PG_booked bit to page->flags. it's used in delayed
>    allocation to mark space is already reserved for page
>    (including possible metadata)

So that mean's we'll have 2 separate mechanisms for marking
pages as delalloc. XFS uses the BH_delay flag to indicate
that a buffer (block) attached to the page is using delalloc.

FWIW, how does this mechanism deal with block size < page size?
Don't you have to track delalloc on a block basis rather than
a page basis?

>  - ext4-block-reservation.patch
>    this is scalable free space management. every time we
>    delay allocation of some page, a space (including metadata)
>    should be reserved
> 
>  - ext4-delayed-allocation.patch
>    delayed allocation itself, enabled by "delalloc" mount option.
>    extents support is also required. currently it works only
>    with blocksize=pagesize.

Ah, that's why you can get away with a page flag - you've ignored
the partial page delay state problem. Any plans to use the
existing method in the future so we will be able to use ext4 delalloc
on machines with a page size larger than 4k?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
