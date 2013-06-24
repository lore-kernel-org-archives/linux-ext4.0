From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Date: Mon, 24 Jun 2013 12:44:59 +1000
Message-ID: <20130624024459.GJ29376@dastard>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
 <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
 <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	Namjae Jeon <linkinjeon@gmail.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a.sangwan@samsung.com" <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:28971 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262Ab3FXCpF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Jun 2013 22:45:05 -0400
Content-Disposition: inline
In-Reply-To: <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 23, 2013 at 08:32:32PM -0400, Eric Sandeen wrote:
> On Jun 23, 2013, at 12:01 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> 
> > On 2013-06-23, at 0:07, Namjae Jeon <linkinjeon@gmail.com> wrote:
> > 
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >> 
> >> This patch series introduces 2 new ioctls for ext4.
> >> 
> >> Truncate_block_range ioctl truncates blocks from source file.
> > 
> > How is this different from fallocate(FALLOC_FL_PUNCH_HOLE)?  That is already in existing kernels, and portable across multiple filesystems. 
> > 
> Same question.  Punch hole should do this already...

Hole punch doesn't change the offsets of subsequent extents in the
file - it leaves a hole. This doesn't leave a hole at all - all the 
extents above the range are shifted down to offset where the extents
being punched out started.

> >> Transfer_block_range ioctl transfers data blocks from source file
> >> and append them at the end of destination file.
> > 
> > There is already a similar ioctl for defragmenting files. Is it possible to use that, or does it have different semantics?
> > 
> >> Ioctl1:        EXT4_IOC_TRUNCATE_BLOCK_RANGE:
> >> This ioctl truncates a range of data blocks from file.
> >> It is useful to remove easily and quickly the garbage data
> >> at the middle of file.
> >> 
> >> e.g. we have a movie file and there is long advertisement in movie file.
> >> user want to remove only advertisement range.
> > 
> > While this works in theory, there is very little chance that the movie data will align exactly to filesystem block boundaries. 
> > 
> Or more importantly on compression codec boundaries.   Wouldn't this look like corruption at playback time?

Not necessarily. Video codecs are encapsulated in a container that
can be used to link key frames together so you can do this sort of
manipulation of the file contents and just change an
offset-to-next-keyframe value in the container and it all just
works. Non linear editting (NLE) software has been doing this
manually for 15 years by copying data around - this just optimises
the operation by manipulating the extent mapping rather than needing
to physically copy the data.

FWIW, I've heard persistent rumors going back several years of
various DVR companies shipping equivalent ioctl-based functionality
for XFS filesystems to both insert and remove chunks in video
streams, but I've never been able to find the code for it anywhere.

Hence, at minimum, this should be a fallocate() operation, not a ext4
specific ioctl as it is relatively trivial to implement on most
extent based filesystems.

However, My conditions for merging such functionality into fallocate
are:
	1. it needs xfs_io support [to provide]
	2. comprehensive xfstests coverage, similar to the current
	   hole punch coverage we have.

> >> #define EXT4_IOC_TRUNCATE_BLOCK_RANGE  _IOW('f', 18, struct truncate_range)
> >> struct truncate_range {
> >>      __u32 start_block;
> >>      __u32 length;
> >> };

And have 64 bit file size support, please!

Also FALLOC_FL_COLLAPSE_RANGE is probably a better name for the
operation being done ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
