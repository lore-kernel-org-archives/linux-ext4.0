From: Nick Piggin <npiggin@suse.de>
Subject: Re: potential regression in ext[34] call to __page_symlink()?
Date: Wed, 29 Oct 2008 04:25:57 +0100
Message-ID: <20081029032557.GA17624@wotan.suse.de>
References: <170fa0d20810281711s2a508ed2o1af0db30733e8d2d@mail.gmail.com> <20081029024048.GB3766@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Mike Snitzer <snitzer@gmail.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kirill Korotaev <dev@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:38487 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYJ2D0A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Oct 2008 23:26:00 -0400
Content-Disposition: inline
In-Reply-To: <20081029024048.GB3766@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 28, 2008 at 10:40:48PM -0400, Theodore Tso wrote:
> On Tue, Oct 28, 2008 at 08:11:48PM -0400, Mike Snitzer wrote:
> > The gfp_mask that is passed to __page_symlink() is being completely
> > dropped on the floor.  Historically this mask was at least used by
> > ext3 and ext4 to avoid recursing back into the FS from within a
> > journal transaction; Kirill fixed that issue with this commit:
> > 0adb25d2e71ab047423d6fc63d5d184590d0a66f
> > 
> > I'm quite naive when it comes to Nick's relatively new (>= 2.6.24) AOP
> > pagecache_write_{begin,end} code that motivated __page_symlink to
> > change with this commit:
> > afddba49d18f346e5cc2938b6ed7c512db18ca68
> > 
> > Nick's change clearly did away with using the explicitly passed
> > gfp_mask in __page_symlink().
> > So at a minimum it would seem __page_symlink() now has an unused
> > parameter that should be removed.
> > 
> > But a more serious concern would be: have ext[34]_symlink() regressed
> > to being susceptible to the bug that Kirill fixed some time ago?
> 
> Yeah, I think this would be a potential problem for ext3/4.  Looks
> like pagemap_write_begin() should take a gfp_mask argument, and then
> pass it down through to __grab_cache_page(), which should then call
> __page_cache_alloc() instead of _page_cache_alloc().  Then
> __page_symlink() can actually pass in its gfp_mask to
> pagemap_write_begin().
> 
> Nick, do you agree?

I agree it is a problem. It's a bit hard to pass down a gfp_mask
(because the caller would normally expect _all_ operations in the
called code to obey the mask, basically impossible to do for
GFP_NOFS because by definition we're calling into ->write_begin).

I was leaning towards adding a new AOP_FLAG_ there, usable just by
filesystem code, and just to tell any helper code to clear __GFP_FS.
That way callers won't get confused into thinking they can do
GFP_ATOMIC writes from interrupt context or something ;) (which,
trust me, somebody will attempt to do if it looks remotely feasible!)

