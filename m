From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: Ext4 devel interlock meeting minutes (Nov. 17, 2006)
Date: Tue, 21 Nov 2006 16:37:17 +0530
Message-ID: <20061121110717.GA9863@in.ibm.com>
References: <455E30BC.9070705@us.ibm.com>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, shaggy@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:20691 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S934281AbWKULD4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Nov 2006 06:03:56 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALB3sfg027855
	for <linux-ext4@vger.kernel.org>; Tue, 21 Nov 2006 06:03:55 -0500
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALB3snR307000
	for <linux-ext4@vger.kernel.org>; Tue, 21 Nov 2006 04:03:54 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALB3rSC027088
	for <linux-ext4@vger.kernel.org>; Tue, 21 Nov 2006 04:03:53 -0700
To: Avantika Mathur LTC <mathur@us.ibm.com>
Content-Disposition: inline
In-Reply-To: <455E30BC.9070705@us.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


For this week's call, could we have a discussion on the API for
persistent preallocation ? Options suggested in the past have
included posix_fallocate, fadvise, fcntl/ioctl, ftruncate. 

Regards
Suparna

On Fri, Nov 17, 2006 at 01:59:24PM -0800, Avantika Mathur LTC wrote:
> Sorry they are a little late!  Here are minutes from the interlock call
> on Wednesday.
> 
> Thanks,
> Avantika
> ----
> 
> Ext4 Developer Interlock Call: 11/15/06 Minutes
> 
> Attendees: Dave Kleikamp, Ted Ts'o, Jean-Pierre Dion, Valirie Climent,
> Jean-Noel Cordenner, Mingming Cao, Suparna Bhattacharya, Eric Sandeen,
> Avantika Mathur
> 
> - WIKI: Decided that we need to maintain one Wiki for Ext4. Ted will
> request a new wiki on kernel.org.
> 
> - Shaggy had sent out an Ext4 roadmap after the last call, but need to
> continue to plan when each feature will be stable and when the disk
> format can be freezed. This should be kept up to date on the Wiki.
> 
> - Ted is reviewing extents patches to e2fsprogs. There have been many
> changes to mercurial in the past week.
> 
> - Defrag Schemes: Detailed discussion of the different defrag schemes
> being discussed on the mailing list, and what requirements are needed
> for Ext4.  A summary of this discussion is below:
> 
> 
> DEFRAG DISCUSSION
> =================
> 
> (Ted and Eric, this is what I remembered from the discussion, please
> fill in any gaps or correct any mistakes in the summary.)
> 
> Trying to establish a clear direction for defrag, there has been a lot
> of discussion on the mailing list.
> The issues discussed were:
> 
> -- How the interface to the defrag should be implemented. Current ideas
> are using ioctls, system calls, or implementing as a filesystem.  Using
> ioctls was the method generally favored by Ted and Eric in the discussion.
> 
> -- Whether the implementation should be extent based or block based. Ted
> feels that this should be extent based, using indirect blocks if necessary
> 
> -- Should the block allocation policy be driven by user space or kernel
> space?
> 
> Prefer a user space driven policy, so that files that are accessed
> concurrently during system boot, can be put close together to speed up
> the boot process.  In this design the user space interface can specify
> an inode and logical block sequence to be put in a certain block
> location; if the space is available, the kernel will copy data and inode
> pointers.
> The user space interface will access bitmaps to locate free space.  It
> should also have the interface to specify a certain region to be
> reserved, and that region would be freed on the disk, so user space can
> move other files to that space.
> 
> -- Implementation
> 
> Ted believes the defrag should be implemented by specifying a region
> space for a file on disk, storing file data in page cache and copying
> the data from the page cache to the new physical blocks.  Then changing
> the mappings from the logical blocks to these new physical blocks.
> 
> Eric's approach is to identify the region on disk, generate a secondary
> inode for the file and allocate this space to the secondary inode.  Then
> copy the data from the original file to the new blocks, and replace the
> inode.  All file writes will need to be restricted during this process.
> Ted's concerns with this approach is possible inconsistencies in the
> journal if the system crashes during this process, and also the
> inability to defrag files while they are being written to.
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India
