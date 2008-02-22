From: Andreas Dilger <adilger@sun.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Fri, 22 Feb 2008 16:14:34 -0700
Message-ID: <20080222231434.GG3029@webber.adilger.int>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org>
 <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu>
 <20080219050945.GU25098@mit.edu> <47BC75A1.10605@redhat.com>
 <20080221140546.GF14614@mit.edu> <47BDA978.7060403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56192 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbYBVXOm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 18:14:42 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1MNEfLP005384
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:14:41 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JWN00E01XT8LK00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 22 Feb 2008 15:14:41 -0800 (PST)
In-reply-to: <47BDA978.7060403@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 21, 2008  10:40 -0600, Eric Sandeen wrote:
> Ok, but my concern is what happens to those long symlinks when they
> really truly are in extents format.  One option is to say "hey it was
> ext4DEV, deal with it" and nuke the symlink, but if possible, converting
> back to the proper format would be nice.

Is that actually the case though?  That should be pretty easy to massage
into storing a block number.  The difficulty is if the long symlink block
is beyond 32-bit blocknr, in which case it actually needs extents format.
We may as well bite the bullet and fix the code to be the same as with
htree fakeroot index block reading and use the proper mapping to find
the symlink block.  See htree_blk_iter_cb() for how to do that.

> > One related question is whether we want to try to get support for full
> > 64-bit physical block numbers into ext4.  I think there were some
> > rough draft patches floating about, but IIRC they didn't
> > simultaneously support the 48-bit extent format.
> 
> I too had assumed that 48 bits would be it for now; it should be
> sufficient for a good while.  I guess what I'd like to see if a usable
> ext4 out there in the near future, with stuff added on later as
> necessary; delalloc, flex_bg (if that doesn't make 2.6.25...) etc.

At some point 32-bit logical block numbers will also be an issue, but
the need for 16TB+ non-sparse single files is rare even in my world.

> Oh, speaking of all this - what do you think the criteria are for
> dropping the "dev" from ext4dev?  How do we decide that it's cooked
> enough?  :)

I'd say when e2fsprogs has an official release with extents support,
and there are no show-stopping bugs in the existing code...  I don't
think that is too far off anymore.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
