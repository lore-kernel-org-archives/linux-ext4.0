From: Andreas Dilger <adilger@sun.com>
Subject: Re: mke2fs and lazy_itable_init
Date: Fri, 09 May 2008 02:19:30 -0600
Message-ID: <20080509081929.GD3627@webber.adilger.int>
References: <20080508224847.GR3627@webber.adilger.int>
 <20080509021827.GA8871@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:33963 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbYEIIT5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2008 04:19:57 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m498JutR005053
	for <linux-ext4@vger.kernel.org>; Fri, 9 May 2008 01:19:57 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K0L00801DJG0200@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 09 May 2008 01:19:56 -0700 (PDT)
In-reply-to: <20080509021827.GA8871@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 08, 2008  22:18 -0400, Theodore Ts'o wrote:
> On Thu, May 08, 2008 at 04:48:47PM -0600, Andreas Dilger wrote:
> > I just noticed lazy_itable_init in the mke2fs.8.in man page.  I think
> > a warning needs to be added there that this is not currently safe to
> > use, because the kernel does not yet do the background zeroing.  There
> > is nothing in the man page to indicate that this is unsafe...
> 
> Yeah, I was hoping we would actually get this fixed before 1.41 was
> released....  (i.e., implement the background zeroing).

It would still be an issue for 2.6.24 and 2.6.25 kernels, so I think
it at least deserves a warning until there is a specific kernel that
can be referenced that has this functionality.

> One of the
> things I was thinking about was whether we could avoid needing to go
> through the jbd layer when zeroing out an entire inode table block,
> and then in the completion callback function when the block group was
> completely initiaized, we could clear the ITABLE_UNINIT flag.
> 
> It doesn't need to go through the journal, because if we crash without
> having the flag set, its not a big deal; the inode table will just not
> be marked initialized.  The only thing which might require a little
> care is if buffer head referencing part of the inode table which is
> getting zero'ed out is in flight when an inode allocation happens, an
> inode gets marked dirty, and fs/ext4/inode.c wants to write out an
> inode table block that is in the middle of being zero'ed.  Given that
> we've bypassed the jbd layer for efficiency's sake, something bad
> could happy unless we protect it with some kind of lock.
> 
> Or we could just say that this initialization pass is relatively rare,
> so do it the cheap cheasy way, even if the blocks end up going through
> the journal.  The upside is that it should be pretty quick and easy to
> code it this way.

It is only a once-per-filesystem-lifetime operation, and while it is
a fair amount of IO, it could be done efficient because of sequential IO.
I believe that the unwritten extent code added a function "ext4_zero_blocks"
or similar that maps the ZERO_PAGE into a bio and submits that for IO
to zero out the extent.  This could be used for the inode tables also,
avoiding the major problem of dirtying thousands of blocks in memory.

The risk, as you write, is the locking, and the only locks I see on the
inode table are the bh locks on the itable blocks in __ext4_get_inode_loc().
We can't hold the per-group hashed spinlock for this IO.  We might consider
adding an rw semaphore, and in the very common case there will only ever
be readers on this lock.  If there is a zeroing happening then there can
be a "trylock" operation and the entire group skipped to avoid blocking
the caller for a long time.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

