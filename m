From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/5] libext2fs: Implement
 ext2fs_find_first_zero_generic_bmap().
Date: Mon, 26 Mar 2012 11:34:31 -0400
Message-ID: <20120326153431.GC15027@thunk.org>
References: <20120310213321.GK6961@sli.dy.fi>
 <20120310213740.GO6961@sli.dy.fi>
 <5E845FD5-30E4-47A1-AF8E-70A288E3442D@dilger.ca>
 <20120312191514.GS6961@sli.dy.fi>
 <20120323223331.GA8554@thunk.org>
 <20120326135355.GB2180@cc.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37591 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635Ab2CZPee (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Mar 2012 11:34:34 -0400
Content-Disposition: inline
In-Reply-To: <20120326135355.GB2180@cc.hut.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 26, 2012 at 04:53:56PM +0300, Sami Liedes wrote:
> > So I plan to pull in your patch series and then we can further enhance
> > this with iterator support afterwards.  Sami, if you'd be interested
> > in implementing iterators, that would be great!
> 
> Just to be on the same page, what is the motivation for iterators? Is
> it performance, making the code cleaner or facilitating further
> functionality?

It's a little of all three.  For example, in e2fsck's pass #5, we
currently test each bit, one at a time.  The code paths are quite
complex, but given that we're already using an rbtree for block and
inode bitmaps in e2fsck, using a find_first_set() function could
significantly improve performance.  (We can't really use an iterator
since we need to stop at each block group boundary to check the bg
summary values, but that's where using a find_first_set() with an
"upto" field would do what we want.)

I'll note by the way that it's possible for resize2fs, if we implement
find_first_set() and find_first_zero() for rbtree bitmaps, using
rbtree bitmaps could be even faster, since even with your
optimizations, if there are large blocks of unset bitmaps, we have to
check every single memory location in a bitarray, where as a rbtree
bitmap is much more space compact and would also be faster from a
"find_first_set" standpoint.

There are a few other places where it would make the code cleaner, and
where I might switch to using an rbtree-backed bitmap instead of a
sorted array implementation, but that's a secondary concern.

Cheers,

					- Ted
