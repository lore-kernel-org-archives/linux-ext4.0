From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (March 7, 2007)
Date: Thu, 8 Mar 2007 16:03:26 -0700
Message-ID: <20070308230326.GI5823@schatzie.adilger.int>
References: <45F05099.5020506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:42599 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030856AbXCHXD2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Mar 2007 18:03:28 -0500
Content-Disposition: inline
In-Reply-To: <45F05099.5020506@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 08, 2007  10:06 -0800, Avantika Mathur wrote:
> - At the filesystem and storage workshop, it was decided that metadata 
> block groups will be turned on by default in Ext4 to support larger 
> filesystem size. With current format where group descriptors are saved in 
> the first block group, filesystem size is limited to 256 TB.

The one problem with the METABG feature is that if the last metagroup
only has a single group in it then we do not get a backup of that group
descriptor.

Also, I believe there are still parts of the kernel and e2fsprogs code
that don't handle METABG properly (e.g. ext3_check_group_descriptors(),
ext3_statfs(), online resize, etc), though I haven't checked recently.

Note that it isn't required to have METABG enabled all the time for ext4,
as it can be enabled for block groups beyond a certain limit (e.g. if
a filesystem is formatted or grows beyond 256TB).

> - Lustre had an additional request; that the i-version amount is updated by 
> a global counter.  Ted is concerned about bottlenecks on metadata intensive 
> benchmarks, because of the globally accessed incremental counter. 

It turns out that Lustre will be managing the inode version itself, so there
is no strong requirement that ext4 do this, so long as we can write the
64-bit version number into the inode.

One benefit of having a global version number is that this allows "make"
type comparisons between inodes always be ordered regardless of the
timestamp resolution.  This is one of the primary reasons why we have
nanosecond timestamps in the first place.

> - Aneesh Veetil has been working on a migration tool from block based to 
> extents allocation. He is looking at two options.
> 
>    - Offline Migration: Modify e2fsprogs code to actually be able to create 
>    extents. This involves a lot of duplication of ext4 code (btree).  
>    e2fsprogs has code for interpreting extents, but code for creating them 
>    would have to be duplicated.
> 
>    - Online Migration: Use existing filesystem code to convert to extents - 
>    similar to online defragmentation.

I would prefer to implement this using the same code as the online defrag.
To be useful, the online defrag has to work with block-mapped files anyways.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
