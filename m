From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 20/49] libext2fs: fix parents when modifying extents
Date: Fri, 14 Mar 2014 13:13:19 -0700
Message-ID: <20140314201319.GF9070@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065605.30585.47791.stgit@birch.djwong.org>
 <20140314140158.GP8282@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47610 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbaCNUNZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Mar 2014 16:13:25 -0400
Content-Disposition: inline
In-Reply-To: <20140314140158.GP8282@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 14, 2014 at 10:01:58AM -0400, Theodore Ts'o wrote:
> On Mon, Mar 10, 2014 at 11:56:05PM -0700, Darrick J. Wong wrote:
> > In ext2fs_extent_set_bmap() and ext2fs_punch_extent(), fix the parents
> > when altering either end of an extent so that the parent nodes reflect
> > the added mapping.
> 
> Can you say more about what bug/symptom this fixes?

I first observed symptoms when calls to _set_bmap() or _punch_extent() on a
leaf node would leave the index node's ei_block set to the wrong value, which
e2fsck complains about.

In the _set_bmap() case, I noticed that the "remapping last block in extent"
case would produce symptoms if we are trying to remap a block from "extent" to
"next_extent", and the two extents are pointed to by different index nodes.
_extent_replace(..., next_extent) updates e_lblk in the leaf extent, but
because there's no _extent_fix_parents() call, the index nodes never get
updated.

In the _punch_extent() case, we conclude that we need to split an extent into
two pieces since we're punching out the middle.  If the extent is the last
extent in the block, the second extent will be inserted into a new leaf node
block.  Without _fix_parents(), the index node doesn't seem to get updated.

> > There's a slight complication to using fix_parents: if there are two
> > mappings to an lblk in the tree, the value of handle->path->curr can
> > point to either extent afterwards), which is documented in a comment.
> 
> It's horribly wrong to map an lblk with two extents.  So the question
> is at what places should we complain if we notice this.  In the ideal
> world we would never allow an extent tree to be mutated in such a way
> that it is invalid like this, but I am worried about the overhead
> costs of always checking.  But if there are places where it wouldn't
> take much effort to check, we should probably do so and return an
> error.  (If the extent tree is already invalid, I suppose we should
> allow error out the operation, since this would affect e2fsck and
> debugfs.  I'm talking about checks to make sure that libext2fs or its
> callers don't accidentally make things worse.)

Both cases above cause the (temporary) use of two extents to map the same lblk.
_set_bmap() first adjusts next_extent.e_lblk to cover the lblk, then decrements
extent.e_len so that "extent" no longer covers the lblk.  _punch_extent()
splits an extent by first inserting the second part of the extent and then
shortening the original extent to reflect the punchout.

These two cases seemed slightly suspect to me, but since e2fsprogs doesn't
journal, changing the code to reduce one extent and enlarge the other opens the
possibility that we could lose the lblk mapping entirely if something happens
in between the two operations.  I prefer "block still mapped but fsck is
unhappy about redundant bookeepping" to "the block is gone", so I added the two
fixes and let it go.

--D
> 
> 	    	  	       	  - Ted
> 
> P.S.  I suppose the one possible valid use case for making an invalid
> extent tree is a developer making an invalid extent tree for
> regression testing, so maybe there should be an exemption for debugfs.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
