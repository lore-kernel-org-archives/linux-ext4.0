From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: Re: [PATCH 2/2] Large EAs
Date: Wed, 03 Dec 2008 16:08:27 +0530
Message-ID: <1228300707.3121.71.camel@localhost>
References: <1226954173.3972.70.camel@localhost>
 <20081126044138.GD1410@mit.edu>
 <460220570811252200t5d9e4aaax95f73843b8f3e482@mail.gmail.com>
 <20081126065439.GA27490@mit.edu> <20081126214929.GZ3186@webber.adilger.int>
 <20081127003555.GD14101@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@Sun.COM>,
	Kalpak Shah <kalpak.shah@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:50789 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYLCKir (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2008 05:38:47 -0500
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id mB3Acfro018273
	for <linux-ext4@vger.kernel.org>; Wed, 3 Dec 2008 10:38:43 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0KBA00101QRONZ00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Wed,
 03 Dec 2008 18:38:41 +0800 (SGT)
In-reply-to: <20081127003555.GD14101@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since we need to make sure that inodes are not used very frequently for
storing EAs, the following design was discussed on the ext4 concall:

xattrs of size blocksize/2 < ea_size <= blocksize are stored by
referencing the block number directly from the ext4_xattr_entry (using
some unique combination of bits to encode that this is referencing a
block instead of an inode, and also finding space to store 48-bit block
numbers) and then ea_size > blocksize is referenced directly by an
inode.

During discussion Andreas suggested another idea using which we can
avoid the need to point at blocks from the ext4_xattr_entry:

Use mballoc to try and find up to 64kB of contiguous blocks to store
smaller xattrs. Looking at the ext4_xattr_header it has an h_blocks
field which we can use to indicate the number of blocks in a row that
are allocated for this inode's xattrs. 

The ext4_xattr_entry has a 16-bit block offset that can be used to
point anywhere within a 64kB block.  This not only allows many more
small xattrs to be stored efficiently, but also mid-sized xattrs (<=
blocksize) can be handled efficiently because the data will be packed
into the single group of blocks.  It also avoids the need to reference
block numbers from the ext4_xattr_entry directly, which is ugly.

Comments?

Thanks,
Kalpak

On Wed, 2008-11-26 at 19:35 -0500, Theodore Tso wrote:
> On Wed, Nov 26, 2008 at 02:49:29PM -0700, Andreas Dilger wrote:
> > 
> > One benefit I think is that at least the orphaned EA inode can be
> > cleaned up instead of lingering in the middle of the shared EA tree.
> > 
> > Another benefit of having separate EAs is that it makes it tractable to
> > modify very large EAs.  Otherwise, if there are a number of large
> > EAs shared in a single tree they would all have to be modified in order
> > to store a larger value for an EA in the middle of the tree.
> 
> I guess I didn't make myself clear.  I was *not* suggesting that we
> share EA's in one inode, or in one extent tree.  Instead, what I
> suggested was that instead of having a pointer to an inode, if the
> value of the EA is less than half the blocksize, it is stored in the
> EA block.  If it is between 50% and 100% of the blocksize, instead of
> pointing at inode, we point to a block.  If it is greater than a
> blocksize, we point at a block containing an EA tree.  (Which means
> for a large EA the average space overhead is 6k --- 4k for the extent
> block, plus 2k for the fragmentation cost).
> 
> So this scheme very much uses separate EA's, and does not pack all of
> the EA's into a single tree.  It is deliberately kept simple precisely
> because like you I don't think it's worth it to optimize EA's.  On the
> other hand, running out of inodes is a big problem, and dynamic inodes
> is far more complicated an issue, especially if we don't have 64-bit
> inode support in the kernel and in userspace, and we need to worry
> about locality issues and how dynamic inodes work with online
> resizing. 
> 
> The tradeoff is that my scheme doesn't burn an inode for each large
> EA, but for EA's greater than a blocksize, we chew an extra block's
> worth of overhead.  Personally, I think it's a worthwhile tradeoff ---
> 
>    	       	  	  	     	     - Ted

