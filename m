From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Design alternatives for fragments/file tail support in ext4
Date: Fri, 13 Oct 2006 02:10:02 -0600
Message-ID: <20061013081002.GR6221@schatzie.adilger.int>
References: <E1GXeYv-0006rP-RV@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:25756 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1750832AbWJMIKE
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Oct 2006 04:10:04 -0400
To: Theodore Ts'o <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <E1GXeYv-0006rP-RV@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 11, 2006  09:55 -0400, Theodore Ts'o wrote:
> Block allocation clusters
> =========================
> The basic idea is that we store in the superblock the size of a block
> allocation cluster, and that we change the allocation algorithm and the
> preallocation code to always try to allocate blocks so that whenever
> possible, an inode will use contiguous clusters of blocks, which are
> aligned in multiples of the cluster size.   

As mentioned in the weekly conference call - Alex has already implemented
this as part of the mballoc code that CFS uses in conjunction with extents.
There is a /proc tunable for the cluster size, which currently defaults to
1MB clusters (the Lustre RPC size) to optimize performance for RAID systems.
The allocations are aligned with the LUN so that an integer number of RAID
stripes are modified for a write.  Smaller allocation chunks are packed
together.

Alex is working to update the multi-block allocator for the 2.6.18 kernel,
in conjunction with delayed allocation for ext4, and will hopefully have
a patch soon.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

