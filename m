From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/31] e2p: Fix f[gs]etflags argument size mismatch
Date: Mon, 7 Oct 2013 20:06:02 -0400
Message-ID: <20131008000602.GA7725@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012721.28415.97544.stgit@birch.djwong.org>
 <20131007133304.GE4540@thunk.org>
 <20131007204055.GF6860@birch.djwong.org>
 <20131007232358.GG6860@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43327 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab3JHAGH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 20:06:07 -0400
Content-Disposition: inline
In-Reply-To: <20131007232358.GG6860@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 07, 2013 at 04:23:58PM -0700, Darrick J. Wong wrote:
> Yuck.  FUSE assumes an interface contract (the data size encoded in the ioctl
> number) that neither userspace nor kernel actually abide.  This has gone on for
> years with no problems, since both components made the same implicit assumption
> about data size in the same way.  Unfortunately, userspace breaks only on FUSE,
> so I don't know what to do.

I suspect we've never noticed because traditionally, FUSE has never
been used to front-end a file system that supports chattr/lsattr ---
most of thsoe file systems are available as native Linux file systems,
so it's probably not a common use case for FUSE.

Can we make the FUSE ioctl handler in fs/fuse/ioctl.c special case
handle the EXT2_IOC_[SG]ETFLAG ioctls.  That would it be consistent
with the other file systms.

> Long term I guess we could define a new pair of ioctls that work with pointers
> to 64-bit values and deprecate the old ones.  Or perhaps there's a better
> suggestion than "don't run chattr/lsattr on a FUSE"?

Well we can create a new pair of ioctls, and then have the userspace
code try the new ioctl, and if the kernel doesn't support it, try the
new ioctl.  But then we would have to fix up all of the file systems
in Linux, and it would take a while before users have a new kernel and
a new userspace which supports the new ioctl.

If we put the hack in fs/fuse/file.c's ioctl handler, then it only
requires a kernel upgrade....

						- Ted
