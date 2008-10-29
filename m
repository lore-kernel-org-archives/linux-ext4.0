From: Theodore Tso <tytso@mit.edu>
Subject: Re: potential regression in ext[34] call to __page_symlink()?
Date: Tue, 28 Oct 2008 22:40:48 -0400
Message-ID: <20081029024048.GB3766@mit.edu>
References: <170fa0d20810281711s2a508ed2o1af0db30733e8d2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
	Kirill Korotaev <dev@openvz.org>
To: Mike Snitzer <snitzer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49373 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752314AbYJ2Ckv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Oct 2008 22:40:51 -0400
Content-Disposition: inline
In-Reply-To: <170fa0d20810281711s2a508ed2o1af0db30733e8d2d@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 28, 2008 at 08:11:48PM -0400, Mike Snitzer wrote:
> The gfp_mask that is passed to __page_symlink() is being completely
> dropped on the floor.  Historically this mask was at least used by
> ext3 and ext4 to avoid recursing back into the FS from within a
> journal transaction; Kirill fixed that issue with this commit:
> 0adb25d2e71ab047423d6fc63d5d184590d0a66f
> 
> I'm quite naive when it comes to Nick's relatively new (>= 2.6.24) AOP
> pagecache_write_{begin,end} code that motivated __page_symlink to
> change with this commit:
> afddba49d18f346e5cc2938b6ed7c512db18ca68
> 
> Nick's change clearly did away with using the explicitly passed
> gfp_mask in __page_symlink().
> So at a minimum it would seem __page_symlink() now has an unused
> parameter that should be removed.
> 
> But a more serious concern would be: have ext[34]_symlink() regressed
> to being susceptible to the bug that Kirill fixed some time ago?

Yeah, I think this would be a potential problem for ext3/4.  Looks
like pagemap_write_begin() should take a gfp_mask argument, and then
pass it down through to __grab_cache_page(), which should then call
__page_cache_alloc() instead of _page_cache_alloc().  Then
__page_symlink() can actually pass in its gfp_mask to
pagemap_write_begin().

Nick, do you agree?

						- Ted
