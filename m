From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 20/49] libext2fs: fix parents when modifying extents
Date: Mon, 17 Mar 2014 09:59:20 -0700
Message-ID: <20140317165920.GG9070@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065605.30585.47791.stgit@birch.djwong.org>
 <20140314140158.GP8282@thunk.org>
 <20140314201319.GF9070@birch.djwong.org>
 <20140315154626.GB17270@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46343 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbaCQQ7Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2014 12:59:24 -0400
Content-Disposition: inline
In-Reply-To: <20140315154626.GB17270@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 15, 2014 at 11:46:26AM -0400, Theodore Ts'o wrote:
> On Fri, Mar 14, 2014 at 01:13:19PM -0700, Darrick J. Wong wrote:
> > Both cases above cause the (temporary) use of two extents to map the same lblk.
> > _set_bmap() first adjusts next_extent.e_lblk to cover the lblk, then decrements
> > extent.e_len so that "extent" no longer covers the lblk.  _punch_extent()
> > splits an extent by first inserting the second part of the extent and then
> > shortening the original extent to reflect the punchout.
> > 
> > These two cases seemed slightly suspect to me, but since e2fsprogs doesn't
> > journal, changing the code to reduce one extent and enlarge the other opens the
> > possibility that we could lose the lblk mapping entirely if something happens
> > in between the two operations.  I prefer "block still mapped but fsck is
> > unhappy about redundant bookeepping" to "the block is gone", so I added the two
> > fixes and let it go.
> 
> OK, fair enough, I'll merge in this patch since it's fixing a real
> bug, and I can't think of a good way to fix this issue without making
> pretty massive changes.
> 
> I'll note though that at the moment e2fsck doesn't have sophisticated
> extent tree recovery support; so if the extent tree is corrupt, it
> offers to zap the entire extent tree, instead of trying to fix up the
> extent tree.  That wasn't an issue because it was likely that if
> absent bugs, the most likely case if the extent tree is corrupted,
> there's not much you can do, so it wasn't worth it to add some code to
> handle these cases.
> 
> However, if a large number of users start using your FUSE server in
> production, then making sure the right thing happens when they suffer
> power failures start becoming more important --- but it may not be
> trivial since libext2fs wasn't originally intended for that use case.
> I am glad that you implemented it, since it's a great way to get
> better testing for various corner cases.  But that's different from
> advertising that the FUSE server should be used in production use
> cases; in particular, we might need to figure out some kind of
> journalling system for FUSE, either using the ext4's internal journal,
> or some user-space journalling system.

I wasn't planning to advertise fuse2fs for production use.  But perhaps it
could cough out a few more warnings if you're not mounting ro, and/or default
to ro?

--D
> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
