From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: verify extent header depth
Date: Wed, 6 Jul 2016 20:54:47 -0400
Message-ID: <20160707005447.GA19871@thunk.org>
References: <1467840431-24550-1-git-send-email-vegard.nossum@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	"Darrick J. Wong" <darrick.wong@oracle.com>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40744 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbcGGAyv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jul 2016 20:54:51 -0400
Content-Disposition: inline
In-Reply-To: <1467840431-24550-1-git-send-email-vegard.nossum@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 06, 2016 at 11:27:11PM +0200, Vegard Nossum wrote:
> According to the wiki [1], eh_depth cannot be larger than 5:
> 
>     Depth of this extent node in the extent tree. 0 = this extent node
>     points to data blocks; otherwise, this extent node points to other
>     extent nodes. The extent tree can be at most 5 levels deep: a logical
>     block number can be at most 2^32, and the smallest n that satisfies
>     4*(((blocksize - 12)/12)^n) >= 2^32 is 5.

Hmm... well, so in practice it is *extremely* rare that the tree depth
would be even more than 3 deep.  That's because (a) the above
calculation assumes a block size of 1k, where where the fanout factor
is 84, instead of the 340 with a 4k blocksize, and (b) the calculation
assumes that all of the extents have a length of 1; which is the worst
case, but in practice is quite rare.

On the other hand, in the absolute worst case the tree *can* get have
a depth greater than 5, because we currently don't enforce the B+ tree
constraint that all nodes (except for the last leaf node) must be at
least half full.  Because of this, it's *possible* if all of the
extents are one block long (because the file system is highly
fragmented), and if there is an especially malicious punch hole and
fallocate sequence of operations, it might be possible to set up a
scenario with a 1k block file system which is extremely fragmented,
and then create a file whose extent tree has a huge number of empty
nodes, except in one block range where all of the interior nodes at
the 1st, 2nd, 3rd, 4th, and 5th level of the tree are completely full,
such that ext4_ext_create_new_leaf() might actually decide that it
needs to make the tree one level deeper.

I really can't quite see this happening except for someone who was
*really* trying to maliciously break the file system, though.

> Without this, we can end up trying to reserve too much space for the
> transaction in case of malicious corruption (here, eh_depth = 65280)

So we could arbitrarily limit eh_depth to say, 32 levels, or some
such.  That will prevent the malicious corruption, while also making
it very difficult for the malicious fallocate/punch hole workload
scenario to be triggered.  The best thing would be to actually
implement code to rebalance and shrink the extent tree when necessary...

	       	  	    	       	   - Ted
