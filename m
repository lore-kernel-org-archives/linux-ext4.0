From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Fri, 22 Feb 2008 19:15:39 -0500
Message-ID: <20080223001539.GD20118@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <47BC75A1.10605@redhat.com> <20080221140546.GF14614@mit.edu> <47BDA978.7060403@redhat.com> <20080222231434.GG3029@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46767 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750782AbYBWAQV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 19:16:21 -0500
Content-Disposition: inline
In-Reply-To: <20080222231434.GG3029@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2008 at 04:14:34PM -0700, Andreas Dilger wrote:
> On Feb 21, 2008  10:40 -0600, Eric Sandeen wrote:
> > Ok, but my concern is what happens to those long symlinks when they
> > really truly are in extents format.  One option is to say "hey it was
> > ext4DEV, deal with it" and nuke the symlink, but if possible, converting
> > back to the proper format would be nice.
> 
> Is that actually the case though?  That should be pretty easy to massage
> into storing a block number.  The difficulty is if the long symlink block
> is beyond 32-bit blocknr, in which case it actually needs extents format.
> We may as well bite the bullet and fix the code to be the same as with
> htree fakeroot index block reading and use the proper mapping to find
> the symlink block.  See htree_blk_iter_cb() for how to do that.

So before the recent patch were we actually creating long symlinks in
extents format?  Or were we just setting the flag but still treating
them as a block number?  If it was the latter, I guess we can put in
code into e2fsck to detect that case, and convert it back to a
singleton block number.  

> > I too had assumed that 48 bits would be it for now; it should be
> > sufficient for a good while.  I guess what I'd like to see if a usable
> > ext4 out there in the near future, with stuff added on later as
> > necessary; delalloc, flex_bg (if that doesn't make 2.6.25...) etc.

Flex_bg is already in 2.6.25.  What's in the patch queue are changes
to the allocation algorithms to make them smarter if flex_bg is
enabled.

> At some point 32-bit logical block numbers will also be an issue, but
> the need for 16TB+ non-sparse single files is rare even in my world.

Yeah, I think the real issue is unless someone is willing to sign up
to support a new extent format (which will require significant code
revamp in the kernel, since right now it pretty much assumes only a
single extent format from a code structure point of view), it's
probably not going to happen in the near future.

> > Oh, speaking of all this - what do you think the criteria are for
> > dropping the "dev" from ext4dev?  How do we decide that it's cooked
> > enough?  :)
> 
> I'd say when e2fsprogs has an official release with extents support,
> and there are no show-stopping bugs in the existing code...  I don't
> think that is too far off anymore.

I guess I'd be a *bit* more cautious.  We still have some code patches
such as the delayed allocation and to a lesser extent the online
defrag patches which have the possibility of introducing bugs.  Once
all of those get merged and we have a full kernel release cycle to fix
the last remaining bugs, that's when I would drop the -dev from the
name.

Speaking of which, that's probably one of the things we should start
concentrating on the kernel side, which is preparing what's left in
the unstable part of the queue to be cleaned up and ready for
submission during the next merge window.  Yeah, it's a ways, off, but
some of the patches left in the unstable series probably need quite a
bit of work.  :-)

						- Ted
