From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] fs: add FIEMAP_FLAG_DISCARD support
Date: Sun, 3 Nov 2013 18:42:00 -0500
Message-ID: <20131103234200.GE7376@thunk.org>
References: <1383435930-29295-1-git-send-email-tytso@mit.edu>
 <20131103231442.GM6188@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131103231442.GM6188@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 04, 2013 at 10:14:42AM +1100, Dave Chinner wrote:
> 
> FIEMAP is not the correct interface for data modifying operations.
> It is an interface that returns information about file metadata (i.e
> the layout of a file) - it is not an interface for modifying the
> contents of the file.

Well, it's been argued that FIEMAP was designed to be extensible, and
we should use it for other operations.  Where the bounds of that
stretches to is certainly an arguable point, and I can understand your
observation that something which causes a change to the contents of
the file might not be best choice.

> fallocate() is the interface used to modify file layout and
> manipulate the data within it and hence, IMO, is much better aligned
> to this operation. And to tell the truth, I'd much prefer such an
> interface is guaranteed to return zeros to users rather than rely on
> whether the underlying device supports discard or whatever they
> return after a discard. i.e. if the user is asking to destroy the
> data in the file, we better be able to ensure the data in the file
> is in a known state at the filesystem level regardless of the
> underlying storage capabilities....

There are two different things that a user might want to do:

* write zeros
* signal to the flash that the contents of the file are not needed

(There's also a "secure discard" which recently got added which
apparently adds a guarantee that for certain storage devices, all of
the previous locations on the flash which had been mapped by the FTL
would also get discarded --- from what I can tell this was some kind
of eMMC thing, but I'll ignore this for now.)

The specific feature request that I was given was to be a file-level
equivalent of the BLKDISCARD ioctl --- and in the patch I added
support for the BLKDISCARD ioctl to be applied to files, since that
was the desired request.

For other use cases, I agree that a file-level equivalent to the
BLKZEROOUT ioctl might be more appropriate --- but that's not what
would be most useful for the particular user application that I'm
trying to support.  (In fact, we're using flash where BLKDISCARDZEROS
returns false, since the discard might be a no-op under certain power
fail scenarios, since the flash doesn't force a stable write of the
FTL metadata when it receives a discard command, for performance
reasons.)


The reason why I found FIEMAP to more convenient from an
implementation perspective is that unlike fallocate(), we're not
actually modifying the logical->physical block map of the file.  We
just need to be able to ask the file system to iterate over the
extents in a particular logical block range.  And FIEMAP does that,
most conveniently, where as if we used fallocate(), each file system
would have to implement the code to issue the discard for the relevant
extent ranges in fs specific code --- or we would have to reimplement
the FIEMAP machinery in a more general fashion so that we could call
sb_issue_discard (or sb_issue_zeroout) from the VFS layer, after
receiving the extent ranges from the fs-specific layer.

Regards,

						- Ted
