From: Alex Tomas <alex@clusterfs.com>
Subject: [RFC] delayed allocation, mballoc, etc
Date: Fri, 01 Dec 2006 03:15:06 +0300
Message-ID: <m3irgwv59d.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:12496 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1031632AbWLAARd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 19:17:33 -0500
Received: from bzzz.home.net (gw.home.net [127.0.0.1])
	by gw.home.net (8.13.7/8.13.4) with ESMTP id kB11IlRf005481
	for <linux-ext4@vger.kernel.org>; Fri, 1 Dec 2006 04:18:47 +0300
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Good day,

I'd like to ask the community to discuss and review few things
I've been working on. we propose set of patches with intention
to improve performance of ext4:

 * locality groups

   to achieve good performance writing many small files
   we need to allocate them closely each to other. the
   simplest way could be to allocate all small files using
   next block after the previous small file. and this would
   work well for a single-job case. for multi-job case (few
   untar's, for example) this would break job locality and
   cause performance penaly in subsequent access. locality
   groups idea may help here: let's group all files by some
   property. pgid, for example. now, every time the kernel
   ask filesystem to flush dirty pages, we flush inodes from
   1st group, then from 2nd and go on. this one we can form
   large contiguous allocations (for a whole group) achieving
   good throughput and preserve quite good locality.

 * scalable block reservation

   this is required to protect from -ENOSPC when pages enter
   pagecache w/o space allocation (delayed allocation). it
   also should scale well on high-end SMP as every cpu has
   one "pool" of block. when pool is empty, the filesystem
   rebalance free blocks between all cpus

 * mballoc v4

   multiblock allocator. it's supposed to be ablo to allocate
   many blocks at once saving cpu.

   with the following changes since v2 published before:

     a) per-inode preallocation
 
        every regular inode may have few preallocated chunks
        assigned to specific logical offset. it's intended to
        help applications like IOR and p2p

     b) per-locality-group preallocation

        a locality group may have few preallocated chunks

     c) buddy structures aren't stored on a disk, instead
        they are regenerated from on-disk bitmaps on demand

     d) has stride option to align requests (useful for arrays)

 * delayed allocation

   not that many changes have been done since the previous
   publication: few bugfixes and tweaks, adopted to new mballoc

as usual, there are tons of things yet to be done/fixed/tweaked.
I'm trying to keep them uptodate in TODOs.

few tests have been done. I'm sending the numbers (as well as
the patches) in the subsequent mails. please, have a look.

all the series can be found at
    ftp://ftp.clusterfs.com/pub/people/alex/2.6.19-rc6/

to enable the features, ext4 should be mounted with options:
   extents,mballoc,delalloc

any comments and questions are very welcome.

thanks, Alex

PS. I'd like to give thanks to CFS for help. especially to
    Peter Braam and Andreas Dilger who feed me with ideas.
