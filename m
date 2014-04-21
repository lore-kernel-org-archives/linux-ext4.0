From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH v2 0/4] ext4: extents status tree shrinker improvement
Date: Mon, 21 Apr 2014 10:05:23 -0400
Message-ID: <20140421140523.GF14869@thunk.org>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
 <20140416151938.GA17208@thunk.org>
 <20140416154209.GB17208@thunk.org>
 <20140417153526.GF18591@thunk.org>
 <20140421135007.GA19966@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51715 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaDUOF2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2014 10:05:28 -0400
Content-Disposition: inline
In-Reply-To: <20140421135007.GA19966@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 21, 2014 at 09:50:07PM +0800, Zheng Liu wrote:
> First question is about 'nr_to_scan'.  Do you want me to generate a
> patch to fix it in this merge window?  Because I can imagine that this
> patch should be trival and easy for reviewing.

I looked at trying to create such a patch for this development cycle,
and I decided not to try to fix this for 3.15 because it's a bit
subtle.  What we have in nr_to_scan is not broken per se.  I'm not
sure it's the best behaviour, but it is at least consistent.

Right now, when nr_to_scan is zero, we are return to the shrinker the
number of items which _can_ be shrunk (i.e., we don't include the
extents subject to delalloc).  Hence what we are effectively telling
the shrinker is that the extents that are in the extent cache due to
delalloc don't exist for the purposes of counting them.  So if we
don't count them when we report the number of items in the cache, then
it's consistent that we don't count then when we tell the shrinker
that we've scanned that many items.

So if we change this, we should also change the number of items that
we have in the cache (i.e., when the shrinker is calle with nr_to_scan
is zero) to include _all_ of the shrinkers in the cache, and if we run
out items, we need to return SHRINK_STOP.

I suspect we should make this change, but it's not as simple patch as
I had initially thought, and I think we'll want to be very careful in
testing it to make sure it behaves correctly.  So instead of including
this as a bug fix for 3.15, I suspect it may be better to code and
test it for 3.16, and if we're confident, we can include a cc:
stable@vger.kernel.org so it gets backported to 3.15.x.

What do other folks think?

> Second question is about your deeply thought.  From your comment, it
> seems that now we need a replacement algorithm that looks like we do in
> memory management subsystem.  Now in memory management subsystem, we
> have an active list and an inactive list which tracks some pages.  When
> the system read/write some pages, these pages will be put on inactive
> list.  Then if some pages are accessed again, they will be promoted into
> active list.  When 'kswapd' thread tries to reclaim some pages, it will
> drop some pages from inactive list and demote some pages from active
> list to inactive list.  I am happy to give it a try later.

Yes, although we'll need to be careful that we don't introduce
scalability problems caused by needing to take too many locks.  So I
don't think we want to move items from the inactive to active list
when the extent cache is referenced.  Instead, we'll probably want to
bump a ref count in the cache entry, and then in the shrinker, when we
scan the inactive list, we can check the ref count and decide then to
move the item to the active list.  That way, only the shrinker needs
to take the global lock.

Cheers,

						- Ted
