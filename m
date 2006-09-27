From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 07/12] rfc: 2fsprogs update
Date: Wed, 27 Sep 2006 10:38:00 -0400
Message-ID: <20060927143800.GD9483@thunk.org>
References: <20060926143343.GA20020@openx1.frec.bull.fr> <20060926144832.GG25755@openx1.frec.bull.fr> <20060926173700.GD4219@thunk.org> <20060927133642.GB25703@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Jean-Pierre Dion <jean-pierre.dion@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:5788 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S932347AbWI0Oh6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Sep 2006 10:37:58 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060927133642.GB25703@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 27, 2006 at 03:36:42PM +0200, Alexandre Ratchov wrote:
> Perhaps it's not obvious, but thats my approach to get all of the
> conversions right without rewriting everything from scratch ;-). I'm still
> open to other approches.

Yes, and I appreciate that concern.  However, given that we need to
support an extents-based iterator anyway, and given that we need to
break the bitmap code anyway so that it gets away from using inline
functions and can __eventually__ support multiple back-end
implementation, we will end up needing to breaking and reimplementing
the interfaces anyway....  and for the other bits of code, simply
defining a new interface and changing blk_t to blk64_t isn't that hard
and isn't want I would call "rewriting".   

The other thing I would mention is that my plan for the extent
iterator is that if the inode uses indirect blocks, what the extent
iterator would do is call the block iterator function, and then
coalesce the results into extents and call the extent callback
function.  So the question of when to use __u32 pointers wouldn't
arise, since we would use the existing code to iterate through the
indirect blocks.  Easy!

Similarly, what I would do for the block_iterator is *if* the inode is
extent based, and *if* the filesystem is less than 2**32 blocks, then
the block iterator would call the extent_iterator, and then translate
the extents into blocks and call the block iterator's callback
function multiple times.  This would be a backwards compatibility
scaffolding, until other portions of the library were converted over
use the extent iterator directly.

So in this fashion it's possible to minimize the amount of code that
we need to maintain in parallel; each functionality is only
implemented in one place, and yet the result still has as much
backwards compatibility as possible.

						- Ted
