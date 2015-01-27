From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/54] libext2fs: avoid pointless EA block allocation
Date: Tue, 27 Jan 2015 11:07:36 -0500
Message-ID: <20150127160736.GE2453@thunk.org>
References: <20150127073533.13308.44994.stgit@birch.djwong.org>
 <20150127073606.13308.68905.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35310 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbbA0QHk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2015 11:07:40 -0500
Content-Disposition: inline
In-Reply-To: <20150127073606.13308.68905.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 26, 2015 at 11:36:06PM -0800, Darrick J. Wong wrote:
> Use qsort to move the inlinedata attribute to the front of the list
> and the empty entries to the end.  Then we can use handle->count to
> decide if we're done writing xattrs, which helps us to avoid the
> situation where we're midway through the attribute list, so we
> allocate an EA block to store more, but have no idea that there's
> actually nothing left in the list.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, although I wonder if we might want to be a bit more
sophisticated about how we handle the order of attributes in the
future.  In particular, if we need to spill over into an EA block,
there are certain things like the selinux security id that we would
want to be inline in the inode, and let other xattrs spill over into
the EA block.  And of course, if we can manage to fit all of the
xattrs into the inode, except for system.data, then we should bail on
using the inline data feature at all, and just allocate a normal data
block for the data, and not use an EA block for system.data at all.

It's much more imporant that we get this sort of stuff right for the
kernel implementation, though, and if we occasionally misoptimize
things in libext2fs, that's unfortunate, but it's primarily going to
be a problem for the FUSE driver...

					- Ted
