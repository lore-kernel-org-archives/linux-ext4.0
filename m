From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/54] libext2fs: avoid pointless EA block allocation
Date: Tue, 27 Jan 2015 11:26:13 -0800
Message-ID: <20150127192613.GA21455@birch.djwong.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073606.13308.68905.stgit@birch.djwong.org>
 <20150127160736.GE2453@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39283 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbbA0T0S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jan 2015 14:26:18 -0500
Content-Disposition: inline
In-Reply-To: <20150127160736.GE2453@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 27, 2015 at 11:07:36AM -0500, Theodore Ts'o wrote:
> On Mon, Jan 26, 2015 at 11:36:06PM -0800, Darrick J. Wong wrote:
> > Use qsort to move the inlinedata attribute to the front of the list
> > and the empty entries to the end.  Then we can use handle->count to
> > decide if we're done writing xattrs, which helps us to avoid the
> > situation where we're midway through the attribute list, so we
> > allocate an EA block to store more, but have no idea that there's
> > actually nothing left in the list.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Applied, although I wonder if we might want to be a bit more
> sophisticated about how we handle the order of attributes in the
> future.  In particular, if we need to spill over into an EA block,
> there are certain things like the selinux security id that we would

Agreed.

> want to be inline in the inode, and let other xattrs spill over into
> the EA block.  And of course, if we can manage to fit all of the
> xattrs into the inode, except for system.data, then we should bail on
> using the inline data feature at all, and just allocate a normal data
> block for the data, and not use an EA block for system.data at all.

I've been wondering for a while why there isn't a name index for
system.data -- doing that would allow 4 more bytes of inline data per
inode.

> It's much more imporant that we get this sort of stuff right for the
> kernel implementation, though, and if we occasionally misoptimize
> things in libext2fs, that's unfortunate, but it's primarily going to
> be a problem for the FUSE driver...

<shrug> That might (for now) be less of a problem for fuse, since
libext2fs has inline directories spill over to a block as soon as
i_block[] fills up... haven't decided if that's a "feature" or a "bug".

(The kernel implementation seems ok with my not-rigorous 3.19 spot
check.)

--D
> 
> 					- Ted
