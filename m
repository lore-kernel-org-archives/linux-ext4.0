From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Sun, 29 Jul 2007 19:18:07 +1000
Message-ID: <20070729091807.GF31489@sgi.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com> <20070727050714.GS12413810@sgi.com> <46A9A41C.7080104@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59490 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760746AbXG2JS2 (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Sun, 29 Jul 2007 05:18:28 -0400
Content-Disposition: inline
In-Reply-To: <46A9A41C.7080104@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 27, 2007 at 11:51:56AM +0400, Alex Tomas wrote:
> David Chinner wrote:
> >Using a new API for new functionality is a bad thing?
> 
> if existing API can be used ...

Sure, but using the existing APIs is no good if the only filesystem
in the kernel that supports delalloc cannot use the new code....

> >Also, looking at the way mpage_da_map_blocks() is done - if we have
> >an 128MB delalloc extent - ext4 will allocate that will allocate it
> >in one go, right? What happens if we then crash after only writing a
> >few megabytes of that extent? stale data exposure? XFS can allocate
> >multiple gigabytes in a single get_blocks call so even if ext4 can't
> >do this, it's a problem for XFS.....
> 
> what happens if IO to 2nd MB is completed, while IO to 1st MB is not
> (probably sitting in queue) ? do you update on-disk size in this case?
> how do you track this?

We're updating the in-memory on-disk inode here, not the actual
inode on disk. That means that if we crashed right here, the file
size on disk would not be changed at all and the filesystem would
behave as if both writes did not ever occur and we simply end up
with empty "preallocated" blocks beyond EOF....

But this is really irrelevant - the issue at hand is what we want
for VFS level delalloc support. IMO, that mechanism needs to support
both XFS and ext4, and I'd prefer if it doesn't perpetuate the
bufferhead abuses of the past (i.e. define an iomap structure
instead of overloading bufferheads yet again).

> >So without the ability to attach specific I/O completions to bios
> >or support for unwritten extents directly in __mpage_writepage,
> >there is no way XFS can use this "generic" delayed allocation code.
> 
> I didn't say "generic", see Subject: :)

No, you didn't, but VFS level functionality implies that
functionality is both generic and able to be used by all
filesystems.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
