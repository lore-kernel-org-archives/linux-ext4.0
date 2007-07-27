From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] basic delayed allocation in VFS
Date: Fri, 27 Jul 2007 15:07:14 +1000
Message-ID: <20070727050714.GS12413810@sgi.com>
References: <46A8628D.6070103@clusterfs.com> <46A87858.40005@garzik.org> <46A878FC.5040600@clusterfs.com> <46A88DFD.7030609@garzik.org> <46A8A294.2070106@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Garzik <jeff@garzik.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46A8A294.2070106@clusterfs.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[please don't top post!]

On Thu, Jul 26, 2007 at 05:33:08PM +0400, Alex Tomas wrote:
> Jeff Garzik wrote:
> >The XFS one is proven and the work was already completed.
> >
> >What were the specific technical issues that made it unsuitable for ext4?
> >
> >I would rather not reinvent the wheel, particularly if the reinvention 
> >is less capable than the existing work.
>
> It duplicates fs/mpage.c in bio building and introduces new generic API
> (iomap, map_blocks_t, etc).

Using a new API for new functionality is a bad thing?

> In contrast, my trivial implementation re-use
> existing code in fs/mpage.c, doesn't introduce new API and I tend to think
> provides quite the same functionality. I can be wrong, of course ...

No, it doesn't provide the same functionality.

Firstly, XFS attaches a different I/O completion to delalloc writes
to allow us to update the file size when the write is beyond the
current on disk EOF. This code cannot do that as all it does is
allocation and present "normal looking" buffers to the generic code
path.

Secondly, apart from delalloc, XFS cannot use the generic code paths
for writeback because unwritten extent conversion also requires
custom I/O completion handlers. Given that __mpage_writepage() only
calls ->writepage when it is confused, XFS simply cannot use this
API.

Also, looking at the way mpage_da_map_blocks() is done - if we have
an 128MB delalloc extent - ext4 will allocate that will allocate it
in one go, right? What happens if we then crash after only writing a
few megabytes of that extent? stale data exposure? XFS can allocate
multiple gigabytes in a single get_blocks call so even if ext4 can't
do this, it's a problem for XFS.....

So without the ability to attach specific I/O completions to bios
or support for unwritten extents directly in __mpage_writepage,
there is no way XFS can use this "generic" delayed allocation code.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
