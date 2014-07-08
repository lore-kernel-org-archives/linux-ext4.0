From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: first write to large ext3 filesystem takes 96 seconds
Date: Mon, 7 Jul 2014 23:54:05 -0400
Message-ID: <20140708035405.GA27440@thunk.org>
References: <20140707211349.GA12478@kvack.org>
 <20140708001655.GI8254@thunk.org>
 <20140708013510.GB12478@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50409 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbaGHDyI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2014 23:54:08 -0400
Content-Disposition: inline
In-Reply-To: <20140708013510.GB12478@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 07, 2014 at 09:35:11PM -0400, Benjamin LaHaise wrote:
> 
> Sure -- I put a copy at http://www.kvack.org/~bcrl/mb_groups as it's a bit 
> too big for the mailing list.  The filesystem in question has a couple of 
> 11GB files on it, with the remainder of the space being taken up by files 
> 7200016 bytes in size.  

Right, so looking at mb_groups we see a bunch of the problems.  There
are a large number block groups which look like this:

#group: free  frags first [ 2^0   2^1   2^2   2^3   2^4   2^5   2^6   2^7   2^8   2^9   2^10  2^11  2^12  2^13  ]
#288  : 1540  7     13056 [ 0     0     1     0     0     0     0     0     6     0     0     0     0     0     ]

It would be very interesting to see what allocation pattern resulted
in so many block groups with this layout.  Before we read in
allocation bitmap, all we know from the block group descriptors is
that there are 1540 free blocks.  What we don't know is that they are
broken up into 6 256 block free regions, plus a 4 block region.

If we try to allocate a 1024 block region, we'll end up searching a
large number of these block groups before find one which is suitable.

Or there is a large collection of block groups that look like this:

#834  : 4900  39    514   [ 0     20    5     5     16    6     4     8     6     1     1     0     0     0     ]

Similarly, we could try to look for a contiguous 2048 range, but even
though there is 4900 blocks available, we can't tell the difference
between something a free block layout which looks like like the above,
versus one that looks like this:

#834  : 4900  39    514   [ 0      6    0     1     3    5     1     4     0     0     0     2     0     0     ]

We could try going straight for the largely empty block groups, but
that's more likely to fragment the file system more quickly, and then
once those largely empty block groups are partially used, then we'll
end up taking a long time while we scan all of the block groups.

       	      	     	  	   	- Ted


