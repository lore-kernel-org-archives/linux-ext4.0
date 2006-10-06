From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Fri, 6 Oct 2006 00:48:56 -0600
Message-ID: <20061006064856.GK22010@schatzie.adilger.int>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005213133.2c4cd82d.akpm@osdl.org> <20061006055829.GH22010@schatzie.adilger.int> <20061005231056.174ee381.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:3547 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S932641AbWJFGs5
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Oct 2006 02:48:57 -0400
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20061005231056.174ee381.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 05, 2006  23:10 -0700, Andrew Morton wrote:
> On Thu, 5 Oct 2006 23:58:29 -0600
> Andreas Dilger <adilger@clusterfs.com> wrote:
> > but the patches have not been changed for ext4 (which should really
> > default to using extents on a filesystem with the INCOMPAT_EXTENT feature
> > set unless told otherwise).  That is a necessity for filesystems larger
> > than 2^32 blocks, since there is no way to create old block-mapped files
> > past that limit.
> 
> That's news to me.  So we only use 48-bit block numbers for extents and
> not for old-style indirect blocks?

Correct.  The block-mapped {d,t,}indirect blocks chewed up enough space
as it was (0.1% of the file size) without doubling the block pointers.
Things like truncate hurt pretty badly because of that, as does the
increased IO load to read them and memory pressure due to keeping them
in RAM.

> How much performance improvement do they get, btw?  CPU or IO? I'm not
> noticing any difference.

As mentioned in my other email, the big performance win will come from
the multi-block allocation (mballoc) and delayed allocation (delalloc)
from Alex.

The mballoc patch allows a 1MB write to get a 1MB-aligned and contiguous
chunk of disk, instead of the next 256 blocks that might be free.
Having 1MB alignment is good for 10% or more on some RAID systems to
avoid writing partial stripes (which also requires a read).

Delalloc allows the filesystem to actually submit 1MB writes at once
without doing the block allocation in prepare_write().  Better for
picking free space, and avoids needless extent tree insertion/rebalancing.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

