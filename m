From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: ext4 xfstest regression due to ext4_es_lookup_extent
Date: Sun, 24 Feb 2013 11:21:56 +0800
Message-ID: <20130224032156.GA5840@gmail.com>
References: <87obfcs1x6.fsf@openvz.org>
 <20130222180325.GB21264@thunk.org>
 <87txp3cqwt.fsf@openvz.org>
 <51289343.90704@gmail.com>
 <20130224001447.GB1196@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:65029 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759410Ab3BXDHG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Feb 2013 22:07:06 -0500
Received: by mail-pb0-f47.google.com with SMTP id rp2so1086422pbb.34
        for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2013 19:07:05 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130224001447.GB1196@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 23, 2013 at 07:14:47PM -0500, Theodore Ts'o wrote:
> On Sat, Feb 23, 2013 at 06:00:35PM +0800, Zheng Liu wrote:
> > > Actually I think that the regression in 269'th you have found recently
> > > caused by similar issue and commit which you foud by bisecting ( the one
> > > which allow migration between indirect<->extent based inodes)
> > > simply helps to spot real issue in es_caching code.
> > 
> > I will revise this patch.  IIRC, we forgot to update status tree after
> > an inode is migrated from extent-based to indirect-based.  Thanks for
> > pointing out.
> 
> Can you do this as a new commit?  I've already bumped the master
> pointer up since I finished running xfstests and I'm seeing no
> regressions (at least with my set of xfstests).  So given that
> everything has been tested and things looks pretty stable, I pushed up
> the master branch.

Yes, I will prepare it as a new commit.  But I am not pretty sure that
the root cause is es_caching.

> 
> I did remember that you were still working on this regression, but
> since we're already half-way through the merge window, I really want
> to make things are ready for a merge request to Linus.  (Which I
> probably will be sending to Linus by Monday or Tuesday.)
> 
> I do plan to collect bug fixes and any remaining regression fixes to
> push to Linus by -rc2 or -rc3, so if don't rush fixing up defrag
> functionality.

For defrag regression, I have two choice to fix it.  One is a quick but
sub-optimal fix that we can invalidate all written/unwritten/hole extent
from status tree.  But it will decrease the performance because we need
to load extent into status tree again.  Further, one thing we need to
keep in our mind is that some extent is unwritten and delayed.  So it
makes thing complicated.  But now we don't need to worry about it
because a bigalloc file system doesn't support defrag.  So we are safe.

Another is to update all extent in status tree.  I think this is a
better choice and I think Dmirty is working on it.  Dmitry, I don't get
your response.  Could you confirm it?

TBH, we never use migration and defrag feature in our product system.
I admit that I almost don't pay a attention to them.  It's my fault.

I make a plan for the next works.

1. Try to prepare a patch that invalidates all cache in status tree to
fix defrag regression, and wait Dmitry's patch.

2. Revise migration patch.

3. Submit remain patches for extent status tree that try to convert
unwritten extent in end_io callback function and remove a bogus wait in
ext4_ind_direct_IO.  Now the patch has already done and still need to be
tested.

4. get_block_t and *map_blocks cleanup.

5. extent-level locking.

Any comment?

Thanks,
                                                - Zheng
