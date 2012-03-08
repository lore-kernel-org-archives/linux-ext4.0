From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] fadvise: add more flags to provide a hint for block
 allocation
Date: Thu, 8 Mar 2012 18:07:20 +1100
Message-ID: <20120308070720.GP3592@dastard>
References: <20120305125029.GA5121@gmail.com>
 <20120307005130.GH3592@dastard>
 <A2E616B7-79A5-4ECF-872F-A62ACA338C54@dilger.ca>
 <yq1k42xhulg.fsf@sermon.lab.mkp.net>
 <20120307121138.GK3592@dastard>
 <yq1vcmfhga2.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <aedilger@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1vcmfhga2.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 07, 2012 at 11:23:49PM -0500, Martin K. Petersen wrote:
> >>>>> "Dave" == Dave Chinner <david@fromorbit.com> writes:
> 
> Dave> From what I've seen of the proposed SMR device standards, we're
> Dave> going to have to redesign filesystem allocation policies
> 
> [...]
> 
> The initial proposal involved SMR disks having a sparse LBA map carved
> into 2GB chunks.

2TB chunks, IIRC - the lower 32 bits of the 48bit LBA was intended
to be the relative offset into the region (RBA), with the upper 16
bits being the region number.

> However, that was shot down pretty hard.

That's unfortunate - it maps really well to how XFS uses allocation
groups. XFS already uses sparse regions for breaking up allocation
to enable parallelism. XFS could map to this sort of layout pretty
easily by placing an allocation group per region. That immediately
separates the SMR regions into discrete regions in the filesystem,
and just requires some tweaking to make use of the different
characteristics of the regions.

For example, use of the standard btree freespace allocator for the
random write regions, and use of the bitmap allocator (used by the
realtime device) for regions that are sequential write because it's
metadata is held externally to the region it is tracking. i.e. it
can be located in the random write regions. This could all be
handled by mkfs.xfs, including setting up the regions on the SMR
drives....

IOWs, XFS already has most of the allocation infrastructure to
handle the proposed region based SMR devices, and would only need a
bit of modification and extension to fully support sequential write
regions along with random write regions.  The allocation policy
stuff (deciding what sort of region to allocate from and aggregating
writes appropriately) is where all the new complexity lies, but that
we have to do that anyway to handle all the different sorts of
access hints we are likely to see.

> The approach currently being worked uses either dynamic (flash, tiered
> storage) or static hints (SMR) to put things in an appropriate area
> given the nature of the I/O.
> This puts the burden of virtual to physical LBA management on the device
> rather than in the filesystem allocators. And gives us the benefit of
> having a single interface that can be used for many different device
> types.

So the current proposal hides all the physical characteristics of
the devices from the file system and remaps the LBA internally based
on the IO hint? But that is the opposite direction to what we've
been taking over the past couple of years - we want more visibility
of device characteristics at the filesystem level so we can optimise
the filesystem better, not less.

> That said, the current proposal is crazy complex and clearly written
> with Windows in mind. They are creating different access profiles for
> .DLLs, .INI files, apps in the startup folder, and so on.

I'll pass judgement when I see it. 

To tell the truth, I'd much prefer that we have direct control of
physical layout in the filesystem rather than have the storage
device virtualise it with some unknown algorithm. Every device will
have different algorithms, so we won't get relatively conistent
behaviour across devices from different manufacturers like we have
now.  If that is all hidden in the drive firmware and is different
for each different device we see, then we've got no hope of being
able to diagnose why two files with identical filesystem layouts at
adjacent LBAs have vastly different performance for the same access
pattern....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
