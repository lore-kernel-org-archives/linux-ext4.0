From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 2/2] Large EAs
Date: Wed, 26 Nov 2008 19:35:55 -0500
Message-ID: <20081127003555.GD14101@mit.edu>
References: <1226954173.3972.70.camel@localhost> <20081126044138.GD1410@mit.edu> <460220570811252200t5d9e4aaax95f73843b8f3e482@mail.gmail.com> <20081126065439.GA27490@mit.edu> <20081126214929.GZ3186@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kalpak Shah <kalpak.shah@gmail.com>,
	Kalpak Shah <Kalpak.Shah@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55477 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752068AbYK0AjI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2008 19:39:08 -0500
Content-Disposition: inline
In-Reply-To: <20081126214929.GZ3186@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 26, 2008 at 02:49:29PM -0700, Andreas Dilger wrote:
> 
> One benefit I think is that at least the orphaned EA inode can be
> cleaned up instead of lingering in the middle of the shared EA tree.
> 
> Another benefit of having separate EAs is that it makes it tractable to
> modify very large EAs.  Otherwise, if there are a number of large
> EAs shared in a single tree they would all have to be modified in order
> to store a larger value for an EA in the middle of the tree.

I guess I didn't make myself clear.  I was *not* suggesting that we
share EA's in one inode, or in one extent tree.  Instead, what I
suggested was that instead of having a pointer to an inode, if the
value of the EA is less than half the blocksize, it is stored in the
EA block.  If it is between 50% and 100% of the blocksize, instead of
pointing at inode, we point to a block.  If it is greater than a
blocksize, we point at a block containing an EA tree.  (Which means
for a large EA the average space overhead is 6k --- 4k for the extent
block, plus 2k for the fragmentation cost).

So this scheme very much uses separate EA's, and does not pack all of
the EA's into a single tree.  It is deliberately kept simple precisely
because like you I don't think it's worth it to optimize EA's.  On the
other hand, running out of inodes is a big problem, and dynamic inodes
is far more complicated an issue, especially if we don't have 64-bit
inode support in the kernel and in userspace, and we need to worry
about locality issues and how dynamic inodes work with online
resizing. 

The tradeoff is that my scheme doesn't burn an inode for each large
EA, but for EA's greater than a blocksize, we chew an extra block's
worth of overhead.  Personally, I think it's a worthwhile tradeoff ---

   	       	  	  	     	     - Ted
