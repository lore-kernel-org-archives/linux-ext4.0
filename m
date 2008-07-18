From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs and blocks outside i_size
Date: Fri, 18 Jul 2008 08:37:06 -0400
Message-ID: <20080718123706.GE11221@mit.edu>
References: <20080718121130.GB23898@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37160 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755154AbYGRMhI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2008 08:37:08 -0400
Content-Disposition: inline
In-Reply-To: <20080718121130.GB23898@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 18, 2008 at 05:41:30PM +0530, Aneesh Kumar K.V wrote:
> Hi Ted,
> 
> With fallocate FALLOC_FL_KEEP_SIZE option, when we write to prealloc
> space and if we hit ENOSPC when trying to insert the extent,
> we actually zero out the extent. That means we can have blocks
> outside i_size for an inode. I guess e2fsck currently doesn't
> handle this. Or should we fix kernel to update i_size to the
> right value if we do a zero out of the extent ?
> 
> With fallocate if the prealloc area is small we also aggressively zeroout.
> This was needed so that a random write pattern on falloc area doesn't
> results in too many extents.  That also can result in the above
> error on fsck.

It would seem to me that e2fsck should be fixed to not complain about
blocks outside of i_size, *if* the blocks in question are marked as
being unitialized.  It also seems to me that updating i_size when the
extent is zero'ed out is also not the right thing to do.  Some
applications depend on i_size.

In the case where you hit ENOSPC when you need to grow the tree to
insert an extent, that's a tough one.  One approach would be to simply
return an error in that case, although that's unfortunate since in
addition to people using fallocate() to try to get better block
layout, some people want to preallocate blocks to guarantee that the
write will not fail!  For people whose reason for using fallocate()
are in the second camp, we can satisfy their need simply by stealing a
block from the end of the preallocate segment and use it to grow the
extent tree.  I'm inclined to think the second solution might be the
better one, but I'm sure that will be controversial.

For your second case, where we aggressively zero out blocks, one of
the reasons why we have to do that is because the kernel isn't
coalescing extents aggressively.  My inclination here is to *not*
aggressively zero out blocks outside outside of i_size, and to split
the extent in that case --- and then to make sure our extent
management code is better about coalescing extents, so that when we
convert an extent from INIT to UNINIT, we also check the previous and
next extent, and if we can combine current extent with an adjacent
extent, we should do so.

I suppose the other hack we could do is have e2fsck check the blocks
that are outside of i_size, and if they are all zero and extents are
involved, that it's a case of pre-allocated blocks that needed to be
zero'ed for some reason, as opposed to a corrupted i_size.  That seems
to be a really gross hack, though.

							- Ted
