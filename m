From: Nicholas Miell <nmiell@comcast.net>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Date: Thu, 12 Apr 2007 18:33:00 -0700
Message-ID: <1176427980.3125.9.camel@entropy>
References: <20070412110550.GM5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, hch@infradead.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from alnrmhc14.comcast.net ([204.127.225.94]:46562 "EHLO
	alnrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXDMBdD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Apr 2007 21:33:03 -0400
In-Reply-To: <20070412110550.GM5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-04-12 at 05:05 -0600, Andreas Dilger wrote:
> I'm interested in getting input for implementing an ioctl to efficiently
> map file extents & holes (FIEMAP) instead of looping over FIBMAP a billion
> times.  We already have customers with single files in the 10TB range and
> we additionally need to get the mapping over the network so it needs to
> be efficient in terms of how data is passed, and how easily it can be
> extracted from the filesystem.
> 
> I had come up with a plan independently and was also steered toward
> XFS_IOC_GETBMAP* ioctls which are in fact very similar to my original
> plan, though I think the XFS structs used there are a bit bloated.
> 
> There was also recent discussion about SEEK_HOLE and SEEK_DATA as
> implemented by Sun, but even if we could skip the holes we still might
> need to do millions of FIBMAPs to see how large files are allocated
> on disk.  Conversely, having filesystems implement an efficient FIBMAP
> ioctl (or ->fiemap() method) could in turn be leveraged for SEEK_HOLE
> and SEEK_DATA instead of doing looping over ->bmap() inside the kernel
> as I saw one patch.
> 

I certainly hope not. SEEK_HOLE/SEEK_DATA is a poor interface and
doesn't deserve to spread.

OTOH, this is nicely done.

> 
> struct fibmap_extent {
> 	__u64 fe_start;			/* starting offset in bytes */
> 	__u64 fe_len;			/* length in bytes */
> }
> 
> struct fibmap {
> 	struct fibmap_extent fm_start;	/* offset, length of desired mapping */
> 	__u32 fm_extent_count;		/* number of extents in array */
> 	__u32 fm_flags;			/* flags (similar to XFS_IOC_GETBMAP) */
> 	__u64 unused;
> 	struct fibmap_extent fm_extents[0];
> }
> 
> #define FIEMAP_LEN_MASK		0xff000000000000
> #define FIEMAP_LEN_HOLE     	0x01000000000000
> #define FIEMAP_LEN_UNWRITTEN	0x02000000000000
> 


-- 
Nicholas Miell <nmiell@comcast.net>
