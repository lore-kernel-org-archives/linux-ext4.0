From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] delayed allocation for ext4
Date: Sat, 23 Dec 2006 09:27:18 +0000
Message-ID: <20061223092718.GA26276@infradead.org>
References: <m37iwjwumf.fsf@bzzz.home.net> <20061223033123.GL44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:50947 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbWLWJ1X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Dec 2006 04:27:23 -0500
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061223033123.GL44411608@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Dec 23, 2006 at 02:31:23PM +1100, David Chinner wrote:
> >  - ext4-delayed-allocation.patch
> >    delayed allocation itself, enabled by "delalloc" mount option.
> >    extents support is also required. currently it works only
> >    with blocksize=pagesize.
> 
> Ah, that's why you can get away with a page flag - you've ignored
> the partial page delay state problem. Any plans to use the
> existing method in the future so we will be able to use ext4 delalloc
> on machines with a page size larger than 4k?

I think fixing this up for blocksize < pagesize is an absolute requirement
to get things merged.  We don't need more filesystems that are crippled
on half of our platforms.

Note that recording delayed alloc state at a page granularity in addition
to just the buffer heads has a lot of advantages aswell and would help
xfs, too.  But I think it makes a lot more sense to record it as a radix
tree tag to speed up the gang lookups for delalloc conversion.
