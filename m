From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: improve performance of region_allocate()
Date: Tue, 22 Aug 2017 08:45:05 -0400
Message-ID: <20170822124505.xr7wnxonsbml3mgh@thunk.org>
References: <20170819011635.1815929-1-dsp@fb.com>
 <20170822022948.nyn6fessudjaj5xh@thunk.org>
 <a4b31ace-3a54-051d-75df-b47452c789cb@uls.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Doug Porter <dsp@fb.com>, linux-ext4@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
To: Jaco Kroon <jaco@uls.co.za>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40814 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932773AbdHVMpL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 22 Aug 2017 08:45:11 -0400
Content-Disposition: inline
In-Reply-To: <a4b31ace-3a54-051d-75df-b47452c789cb@uls.co.za>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 22, 2017 at 11:36:54AM +0200, Jaco Kroon wrote:
> 
> Unfortunately I'm having trouble with inline formatting of the patch, so I
> have attached it instead of providing inline (sorry - I know that makes
> discussion difficult).  Was originally emailed to you as a series of three
> independent patches, with the below as 0001.  We still need to discuss the
> other optimization.

Yeah, sorry for not getting back to you.  I took a long weekend
vacation and this week has been super busy at work, so I haven't had a
chance to pursue the approach I've outlined in an earlier message ---
that is, instead of optimizing the region code (your patch and my
patch, where your patch is more general, but mine is simpler and only
optimizes the one case that is important for optimizing CPU
performance) or replacing it with an rbtree (Doug's patch), but
instead removing it altogether and replacing it with some better check
that avoids needing the memory usage altogether.

> The attached improves CPU performance from O(e*h) to O(e) and memory from
> O(h) to O(1).  The patch below does similar for CPU but nothing for memory
> (In my case it took fsck down by a significant margin).

I thought you were saying you had some false positives (where it was
causing e2fsck to complain about some valid extent trees in your file
system)?  That's why I've not acted on your proposed patch until I had
time to study the code more closely to understand what was going on
with the errors I thought you had reported.

> Ted - the provided patch by Doug may still improve performance for the other
> uses of region.c as well, but the impact will probably not be as severe
> since (as far as I know) there are usually not a great many number of EAs
> for each file.

Correct; we are limited to at most 64k if the new (experimental)
ea_inode feature is enabled; and without that feature, we are limited
to the 4k block size.  So I'm not particularly worried about the xattr
region use case.

Indeed, the region code was originally designed and implemented for
the xattr use case, and the use of a linked list approach was
deliberately chosen for simplicity because normally there are only a
handful of xattrs, and how they are laid out (keys contiguously
growing from one direction, values contiguously grown from the other
direction) is very friendly for that particular use case.  Hence, in
the common, non-error case, there are only going to be two entries on
the linked list when handling xattrs.


As far as the other (icount) optimization is concerned, that's on my
todo list but I'm trying to understand how much of a win it's going to
be on a densly hard linked file system, and whether the complexity due
to the handling the potential increased memory usage is worth it.  If
we leave to be something that has to be manually enabled using
/etc/e2fsck.conf, very few people will use it.  If we need to somehow
figure out how it's safe / necessary to activate the icount
optimization, especially if there are potentially multiple fsck's
running in parallel, this starts to get really complicated.  So
perhaps all we can do is leave it as a manually enabled option, but I
still need to think about that a bit.

Cheers,

						- Ted
