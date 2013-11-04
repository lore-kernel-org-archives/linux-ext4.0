From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC] fs: add FIEMAP_FLAG_DISCARD support
Date: Tue, 5 Nov 2013 08:57:36 +1100
Message-ID: <20131104215736.GR6188@dastard>
References: <1383435930-29295-1-git-send-email-tytso@mit.edu>
 <20131103231442.GM6188@dastard>
 <20131103234200.GE7376@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131103234200.GE7376@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Nov 03, 2013 at 06:42:00PM -0500, Theodore Ts'o wrote:
> On Mon, Nov 04, 2013 at 10:14:42AM +1100, Dave Chinner wrote:
> > 
> > FIEMAP is not the correct interface for data modifying operations.
> > It is an interface that returns information about file metadata (i.e
> > the layout of a file) - it is not an interface for modifying the
> > contents of the file.
> 
> Well, it's been argued that FIEMAP was designed to be extensible, and
> we should use it for other operations.  Where the bounds of that
> stretches to is certainly an arguable point, and I can understand your
> observation that something which causes a change to the contents of
> the file might not be best choice.

Yes, I agree it is extensible, but it was never intended to be
extended into a data modification ioctl. It's for querying metadata
related to file data, not for modifying file data.

> > fallocate() is the interface used to modify file layout and
> > manipulate the data within it and hence, IMO, is much better aligned
> > to this operation. And to tell the truth, I'd much prefer such an
> > interface is guaranteed to return zeros to users rather than rely on
> > whether the underlying device supports discard or whatever they
> > return after a discard. i.e. if the user is asking to destroy the
> > data in the file, we better be able to ensure the data in the file
> > is in a known state at the filesystem level regardless of the
> > underlying storage capabilities....
> 
> There are two different things that a user might want to do:
> 
> * write zeros
> * signal to the flash that the contents of the file are not needed

What the user is really saying is "we don't need the contents of
this file anymore, but we want to keep it allocated for future use".

What you are doing is optimising hardware behaviour based on the
fact the user says "we don't need the data anymore". That's an
implementation goal, but that doesn't necessarily mean that it's the
right API.

>From a user API perspective, we want either the old contents remain
in the file, or if we modify the contents we guarantee that we don't
expose stale data from the underlying storage. If the hardware
cannot guarantee no stale data exposure, then the filesystem needs
to guarantee that. Hence the "convert to zeros" API specification -
we *guarantee at the API level* the behaviour the user can rely on.

> (There's also a "secure discard" which recently got added which
> apparently adds a guarantee that for certain storage devices, all of
> the previous locations on the flash which had been mapped by the FTL
> would also get discarded --- from what I can tell this was some kind
> of eMMC thing, but I'll ignore this for now.)
> 
> The specific feature request that I was given was to be a file-level
> equivalent of the BLKDISCARD ioctl --- and in the patch I added
> support for the BLKDISCARD ioctl to be applied to files, since that
> was the desired request.

Sure, but we don't leave underfined content in files that non-root
users are allowed to access. BLKDISCARD can leave undefined content
in the region of the block device that is being discarded, but we
don't expose that directly to users and so that isn't an issue at
all that BLKDISCARD needs to worry about.

> For other use cases, I agree that a file-level equivalent to the
> BLKZEROOUT ioctl might be more appropriate --- but that's not what
> would be most useful for the particular user application that I'm
> trying to support.  (In fact, we're using flash where BLKDISCARDZEROS
> returns false, since the discard might be a no-op under certain power
> fail scenarios, since the flash doesn't force a stable write of the
> FTL metadata when it receives a discard command, for performance
> reasons.)

Yup, another reason why for normal users that aren't google we have
layers of protection against stale data exposure. 

Google already has a flag in the fallocate API for saying "stale
data is acceptible" (i.e. FALLOC_FL_NO_HIDE_STALE) for telling the
filesystem that you don't care about stale data exposure and so
zeroing via any fallocate operation (be it preallocation, hole
punching, etc) doesn't need to be robust. Hence you already have a
method of working around any sort of strict API requirements we
decide on for guaranteeing the contents of the file after a
FALLOC_FL_ZERO_RANGE operation...

> The reason why I found FIEMAP to more convenient from an
> implementation perspective is that unlike fallocate(), we're not
> actually modifying the logical->physical block map of the file.  We
> just need to be able to ask the file system to iterate over the
> extents in a particular logical block range.

Which I think is polluting the API specification with implementation
details. As it is, fallocate() implementations already have to
iterate the extents in the range that is being modified in some way,
so I don't think that extent iteration is really a problem for
anyone. Also, it's definitely not a reason for chosing FIEMAP as a
user API because we can use fiemap internally in the kernel for
purposes other than implementing FIEMAP ioctls....

> And FIEMAP does that,
> most conveniently, where as if we used fallocate(), each file system
> would have to implement the code to issue the discard for the relevant
> extent ranges in fs specific code --- or we would have to reimplement
> the FIEMAP machinery in a more general fashion so that we could call
> sb_issue_discard (or sb_issue_zeroout) from the VFS layer, after
> receiving the extent ranges from the fs-specific layer.

Actually, sb_issue_zeroout() is unusuable for acceleration purposes
for XFS because if bdev_write_same() fails or discard fails because
of granularity/alignment mismatches, then we want to fall back to
conversion to unwritten extents rather than manual zero-out like
sb_issue_zeroout() does. Hence we can't use any sort of VFS-based
extent iteration and discard/zeroing like you are proposing, and
that brings us back to needing per-filesystem implementations here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
