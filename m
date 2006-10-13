From: Theodore Tso <tytso@mit.edu>
Subject: Re: Design alternatives for fragments/file tail support in ext4
Date: Fri, 13 Oct 2006 06:49:47 -0400
Message-ID: <20061013104947.GB5519@thunk.org>
References: <E1GXeYv-0006rP-RV@candygram.thunk.org> <20061013081002.GR6221@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33922 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1751059AbWJMKuF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Oct 2006 06:50:05 -0400
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061013081002.GR6221@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 13, 2006 at 02:10:02AM -0600, Andreas Dilger wrote:
> On Oct 11, 2006  09:55 -0400, Theodore Ts'o wrote:
> > Block allocation clusters
> > =========================
> > The basic idea is that we store in the superblock the size of a block
> > allocation cluster, and that we change the allocation algorithm and the
> > preallocation code to always try to allocate blocks so that whenever
> > possible, an inode will use contiguous clusters of blocks, which are
> > aligned in multiples of the cluster size.   
> 
> As mentioned in the weekly conference call - Alex has already implemented
> this as part of the mballoc code that CFS uses in conjunction with extents.
> There is a /proc tunable for the cluster size, which currently defaults to
> 1MB clusters (the Lustre RPC size) to optimize performance for RAID systems.
> The allocations are aligned with the LUN so that an integer number of RAID
> stripes are modified for a write.  Smaller allocation chunks are packed
> together.

I suggest this be tunable by superblock field, and not by a /proc
tunable.  This is the sort of thing which might be different
per-filesystem, and the algorithm will be most effective if the
filesystem always use the same cluster size from the time when it was
first created.  I'd be happy to assign a superblock field for this
purpose, and add the appropriate tune2fs support if we have general
agreement on this point.

> Alex is working to update the multi-block allocator for the 2.6.18 kernel,
> in conjunction with delayed allocation for ext4, and will hopefully have
> a patch soon.

Great!

							- Ted
