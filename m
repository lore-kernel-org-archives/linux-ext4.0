From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] delayed allocation for ext4
Date: Fri, 29 Dec 2006 13:52:46 +1100
Message-ID: <20061229025246.GO44411608@melbourne.sgi.com>
References: <m37iwjwumf.fsf@bzzz.home.net> <20061223033123.GL44411608@melbourne.sgi.com> <m3zm9etomy.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:50948 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751613AbWL2Cwx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Dec 2006 21:52:53 -0500
To: Alex Tomas <alex@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <m3zm9etomy.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 23, 2006 at 10:09:57PM +0300, Alex Tomas wrote:
> 
> Good day,
> 
> >>>>> David Chinner (DC) writes:
> 
>  DC> So that mean's we'll have 2 separate mechanisms for marking
>  DC> pages as delalloc. XFS uses the BH_delay flag to indicate
>  DC> that a buffer (block) attached to the page is using delalloc.
> 
> well, for blocksize=pagesize we can save 56 bytes on every page.

Sure, but it means that ext4 w/ delalloc won't work on lots of
machines....

>  DC> FWIW, how does this mechanism deal with block size < page size?
>  DC> Don't you have to track delalloc on a block basis rather than
>  DC> a page basis?
> 
> I'm still thinking how better to deal with that w/o much code duplication.

Code duplication in ext4, or across all filesystems?

>  DC> Ah, that's why you can get away with a page flag - you've ignored
>  DC> the partial page delay state problem. Any plans to use the
>  DC> existing method in the future so we will be able to use ext4 delalloc
>  DC> on machines with a page size larger than 4k?
> 
> what do you mean by "exsiting"? BH_delay?

Yes.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
