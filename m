From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Thu, 21 Feb 2008 09:05:46 -0500
Message-ID: <20080221140546.GF14614@mit.edu>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org> <20080211045107.GB25089@mit.edu> <20080219050945.GU25098@mit.edu> <47BC75A1.10605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49284 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbYBUOGh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2008 09:06:37 -0500
Content-Disposition: inline
In-Reply-To: <47BC75A1.10605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 20, 2008 at 12:46:57PM -0600, Eric Sandeen wrote:
> Theodore Tso wrote:
> > The big news here is that extents branch is sufficiently finished that
> > I've promoted it to the next branch.
> 
> Hey, that's great news.  :)
> 
> Out of curiosity; what is the plan for behavior when finding symlinks
> with the extents flag set?  Last I checked e2fsprogs-interim, they got
> clobbered.  Is that on the TODO before extents support goes "live?"

Right now on e2fpsrogs 'next' the extents flag being set on symlinks,
block/char devices (in general inodes for which
ext2fs_has_valid_blocks returns NULL) are ignored.  I need to make
sure this does the right thing with long symlinks --- and I'd argue
that given that long symlinks can only *ever* be one block long, it's
pointless to use the extents format, since it's just too complicated,
and I *think* that's what the kernel code is doing, but I need to
check to be sure.

Eventually I'll add code to mainline to clear EXTENTS_FL from inodes
that shouldn't have it, but the kernel patches need to hit mainline first.

At this point, I think the only thing the 'pu' branch is missing is
the DIR_NLINKS patch, and I'll get that pulled in fairly quickly.  At
that point I believe the 'pu' branch and e2fsprogs-interim should be
of roughly the same functionality, except of course that the patches
which compose e2fsprogs-interim have gotten a lot more testing thanks
to Clusterfs using it in with Lustre, and the fact that at the moment,
if there are blocks that are claimed by multiple inodes, the 'clone'
feature which clones the block so that both inodes get their own copy
is not supported.  The filesystem can be made consistent by deleting
one of the files, which is all UFS-style fsck's shipping with
professional Unix systems like Solaris support :-P, but obviously
that's not ideal.  :-)

So one question which Eric you'll want to consider is at what point
you want to switch the FC users from e2fsprogs-interim to the
bleeding-edge e2fsprogs mainline code, since eventually this is the
branch that will have blk64_t support.

One related question is whether we want to try to get support for full
64-bit physical block numbers into ext4.  I think there were some
rough draft patches floating about, but IIRC they didn't
simultaneously support the 48-bit extent format.  The e2fsprogs
mainline implementation of extents makes it fairly easy to support new
extents formats --- it's minimal code changes in a single file,
lib/ext2fs/extents.c, and made sure all of the infrastructure was
present to make this easy --- but I believe that trying to support
multiple formats in the kernel given the current ext4 code would be
fairly invasive.  Given the timeline, I'm assuming that our current
path is that we aren't planning on pushing full 64-bit physical block
support into the extents format for what we hope will make it into the
next round of enterprise kernels, but I thought I should throw out the
question so we make the decision one way or the other, explicitly.

Comments?

						- Ted
