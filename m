From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] ext4: Replace hackish
	ext4_mb_poll_new_transaction with commit callback
Date: Fri, 17 Oct 2008 08:25:52 -0400
Message-ID: <20081017122552.GC21503@mit.edu>
References: <1224201763-9637-1-git-send-email-tytso@mit.edu> <20081017060424.GA26192@skywalker> <20081017100214.GB11557@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55678 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753628AbYJQMZz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 08:25:55 -0400
Content-Disposition: inline
In-Reply-To: <20081017100214.GB11557@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 17, 2008 at 06:02:14AM -0400, Theodore Tso wrote:
> > 
> > Why not use journal commit callback patch from andreas 
> > (MID:20080929201752.GN10950@webber.adilger.int
> > http://article.gmane.org/gmane.comp.file-systems.ext4/9148)
> > 
> > The patch you sent will allows only one call back to be registered.
> 
> Thanks for reminding me about that; I had completely forgotten about
> Andreas' patch.  Sure, I'll respin the patch to use his extension.

I looked more closely at Andreas' patch, and it's really not a good
fit for what we want to do.  The problem is that it is designed to
attach arbitrary callbacks on a per transaction basis.  Each time you
add a callback you need to allocate a stucture, and then it gets
chained onto a inked list.

For what we need for mballoc, not only is it massive overkill, but
every single time we try to free blocks, we would have to and then
search the list to see the remove_committed_blocks() callback was or
wasn't on the list yet, and if it wasn't then allocate a chunk of
memory to hold the struct journal_callback data structure and call
journal_callback_set() function.   

Furthermore, to get the locking right and to avoid race conditions,
we'd have to add a _journal_callback_set() function which doesn't take
the spinlock, and then take the spinlock ourselves, search the linked
list, allocate the memory, call _journal_callback_set(), and then
release the spinlock.

It was at about this point that I decided it Just Wasn't Worth It.

What I added was a dead-simple per-journal commit callback, with no
additional memory allocations (and requirement to do error handling if
the memory allocation fails), no need to take a spinlock before
manually adding the call back to each transaction handle, no need to
search the linked list to see if we have an entry on the linked list
already, etc.

If in the future we need a true per-transaction handle commit
callback, we can add this; but I think it still makes more sense to
keep the per-journal commit callback.  After all, as it stands the
current patch results in a net reduction of 46 lines of code.  Adding
all of this machinery would erase take far more than the savings by
removing ext4_mb_poll_new_transaction().

							- Ted
