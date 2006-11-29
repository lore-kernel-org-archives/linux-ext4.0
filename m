From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/4] BIG_BG: support of large block groups
Date: Wed, 29 Nov 2006 12:23:19 -0500
Message-ID: <20061129172318.GD5771@thunk.org>
References: <1164386860.17961.67.camel@ckrm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:26507 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S934975AbWK2RXV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 12:23:21 -0500
To: Valerie Clement <Valerie.Clement@bull.net>
Content-Disposition: inline
In-Reply-To: <1164386860.17961.67.camel@ckrm>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 24, 2006 at 05:47:40PM +0100, Valerie Clement wrote:
> Currently, the maximum number of blocks in a block group is the
> number of bits in a block, since the block bitmap must be stored
> inside a single block.  So on a 4 KB blocksize filesystem, the
> maximum number of blocks in a group is 32768.  This constraint can
> limit the maximum size of the filesystem.

So what's the current limitation on the maximum size of the filesystem
without big block groups?  Well, the block group number is an unsigned
32 bit number, so we can have 2**32 block group.  Using a 4k (2**12)
block group, have a limit of 32768 blocks per block group, or 2**15
blocks.  So the limit is 2**(32+15) or 2**47 blocks, or 2**59 bytes
(512 petabytes).

So one justification of doing this work is we can raise the limit from
2**59 bytes to 2**63 bytes (after which point we have to worry about
loff_t on 32-bit systems and off_t on 64-bit systems being a signed
64-bit number).  So it buys us a factor of 16 increase from 512
petabytes to 8 exabytes of maximum filesystem size (assuming that we
also have the full 64-bit support patches, of course).

(For reference, the Internet Archive Wayback machine contains
approximately 2 petabytes of information, and the Star Trek: TNG's
character Data was purported to have a storage capacity of 88
petabytes.)

The other thing to note about the 2**32 block group number limitation
is this is not a filesystem format limitation, but a implementation
limitation, and is based on dgrp_t being a 32-bit unsigned integer.
If we ever needed to go beyond 512 petabytes, we could do so by making
dgrp_t 64-bits.

> If we already see that the execution time of fsck and mkfs commands is
> reduced when increasing the size of groups on a large filesystem, I'll
> will do performance testing in the next days to see the other impacts of
> this modification.

The execution time speedup of mkfs would mainly be in the time that it
takes to write out the bitmaps in a less seeky fashion --- although
the metablockgroup format change does this as well.  There is also be
a secondary improvement based on the fact that the overhead of writing
out the block group descriptor shrinks, but given that this overhead
is an extra 4k block for every 8 gigabytes of filesystem space, I'm
not sure how important the overhead really is.  We will also get the
execution mkfs speedup (and in fact a much more significant one) when
we implement the lazy initialization of the bitmap blocks and inode
table blocks.

The metablockgroup changes also would enable the storing the bitmap
blocks contiguously which would speed up reading and writing the
bitmap blocks.  The main advantage remaining of the big blockgroups is
then the need to keep track of additional numbers of block utilization
statistics on a per-block group basis, and in allowing the "pool" of
blocks in the ext4's block group be bigger, which could help (or hurt)
our allocation policies.  And, the metablockgroup changes are
significantly simpler (already implemented in e2fsprogs, and involve a
very minor change to the mount code's sanity checking about valid
locations for bitmap blocks).

Am I missing anything?   

Based on this analysis, it's clear that the big block groups patch has
some benefits, but I'm wondering if they are sufficiently large to be
worth it, especially since we also have to consider the changes
necessary to the e2fsprogs (which haven't been written yet as far as I
know).  Comments?

						- Ted
