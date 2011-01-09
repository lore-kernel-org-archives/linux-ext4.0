From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] discard an inode's preallocated blocks after failed
 allocation
Date: Sat, 8 Jan 2011 22:04:47 -0500
Message-ID: <20110109030447.GX21922@thunk.org>
References: <20101130232238.4F5A74274C@ruihe.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, tytso@mit.ed, linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45615 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1AIDE4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Jan 2011 22:04:56 -0500
Content-Disposition: inline
In-Reply-To: <20101130232238.4F5A74274C@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 30, 2010 at 03:22:38PM -0800, Jiaying Zhang wrote:
> We have seen kernel crashes caused by the BUG_ON in 
> ext4_mb_return_to_preallocation() that checks whether the inode's
> i_prealloc_list is empty. As I understand, the assumption is that
> when ext4_mb_return_to_preallocation() is called from ext4_free_blocks(),
> the inode's preallocation list should have been already discarded.
> However, although we call ext4_discard_preallocations() during ext4
> truncate, we don't always call that function in various failure
> cases before calling ext4_free_blocks(). So it is likely to hit this
> BUG_ON with disk errors or corrupted fs etc.
> 
> To fix the problem, the following patch adds ext4_discard_preallocation()
> before ext4_free_blocks() in failed allocation cases. This will discard
> any preallocated block extent attached to the inode, but I think it is 
> probably what we should be doing with failed allocation.
> 
> I am also curious whether we can drop the ext4_mb_return_to_preallocation()
> call from ext4_free_blocks(). From the comments above that function, it
> seems to intent to discard the specified blocks only but all it is currently
> doing is the BUG_ON check on whether the inode's preallocation list is empty.
> Is there any plan to extend this function later?
> 
> 
> ext4: discard an inode's preallocated blocks after failed allocation so that
> we won't hit on the BUG_ON check in ext4_mb_return_to_preallocation() later.
> 
> Signed-off-by: Jiaying Zhang <jiayingz@google.com>

Sorry, I haven't had a chance to go diving into the "legislative
intent" behind the code in question, until now.  The reason why I
haven't is because it's the mballoc code is a bit of a mess (and some
of it is my fault).

The basic idea behind ext4_mb_return_to_preallocation() is to take the
blocks that had been allocated, and if they are adjacent to the
preallocation regions reserved for the inode, to add them to back to
the preallocation region.  This is especially a good thing if the
blocks had just been taking from a preallocation region, and we
errored out trying to insert them into the extent tree, for example.
In that case, it would be good to be able to "put back" the blocks to
their original preallocation region.

There are only a few problems with this scheme:

1)  It was never implemented.

2) There is a BUG_ON which triggers if the inode has any
preallocations.  After staring at it for a long time, I've concluded
that it makes no sense whatsoever.  If I'm right about why it was
there, then in the case where we had just allocated some blocks from
the preallocation region, and now we need to put them back, of course
we inode would have some prellocated regions.

3) If the journal is enabled, we treat all data blocks as if they were
metadata blocks (that is, we don't actually release the blocks until
the current transaction has committed); this is necessary since we
need to make sure we don't actually use some data block until we know
it has been released.  This is fine, but (3a) in the code where we
finally get around to freeing the data blocks, we don't actually call
ext4_mb_return_to_preallcation(), which means the bug which Jiaying
was tracking down can never happen except in no-journal mod, and (3b)
if the data block has never been used (i.e., in the case where we
allocated the data block, but then ever got a chance to install the
blocks so they could have never have gotten used), we don't need to
wait until the next journal transaction --- and in fact in that case
there's no point calling trim on the blocks in question, since they
were never written into.

Argh; what a mess.

So it seems like the best thing to do for now is an alternate patch
which Jiaying had suggested to me privately, which is to simply remove
the BUG_ON in ext4_mb_return_to_preallocation(), since in the long
run, when we get aroundt to actually implementing
ext4_mb_return_to_preallocation(), it does the right thing.

I'm actually not sure how much of an optimization it is to implement
ext4_mb_return_to_preallocation(), so the other alternative is to
remove the function entirely.  How often are we likely to return an
error to userspace, and then have the userspace continue writing to
the file?

							- Ted
