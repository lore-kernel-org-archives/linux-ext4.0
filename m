From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Sun, 1 Jul 2007 09:48:33 -0500
Message-ID: <20070701094833.47035331@gara>
References: <20070629170958.13b7700c@gara>
	<20070630055125.GC5535@schatzie.adilger.int>
	<20070630233908.115ec78e@gara>
	<20070701123054.GC28917@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48187 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbXGAOtu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jul 2007 10:49:50 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l61Enl6D019179
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jul 2007 10:49:47 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l61EnjcP546058
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jul 2007 10:49:47 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l61Enj0M006455
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jul 2007 10:49:45 -0400
In-Reply-To: <20070701123054.GC28917@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 1 Jul 2007 08:30:54 -0400
Theodore Tso <tytso@mit.edu> wrote:
> It was the intention that META_BG include allowing the bitmap and
> inode tables to range anywhere outside of the block group, but that
> never got coded.  It would be confusing though if we relaxed it
> withotu adding a feature bit, and I agree that we might as well use
> overload the BIG_BG group to indicate this feature.
> 
> The fact that BIG_BG requires contiguous blocks for the bitmaps when
> they exceed blocksize*8 blocks still concerns me a minor amount, and

Is your concern due to being unable to find contiguous block in the
case that a bad disk area is in one of the bitmap blocks?  One thing we
can do is try to search for another set of contiguous blocks and if we
fail to find one, we can flag the block group and move to an indirect
block approach to allocating the bitmaps.  At this point, we do lose
some of the performance benefits of BIG_BG, but we would still be able
to use the block group.

> given the hopeful inclusion of kernel patches that allow blocksize >

One thing that concerns me about blocksize larger than page size is
that it requires to much planing from the person creating the
filesystem.  While larger blocksizes does address some of the issues of
the block group size limits, it does so in a less flexible manner.
With something like BIG_BG, we can provide larger extents for large
files while still keeping disk space consumption under control with
small files.
 
> pagesize.  Furthermore, I still wonder whether we will want to make
> blockgroups that much bigger (since reducing the allocation groups is
> not necessarily a smart thing; we will need to do some benchmarks with
> filesystem aging to see how this affects antifragmentation efforts),
> but the complexity engenered by adding BIG_BG isn't that bad (again,
> my only concern is with the contiguous bitmap blocks requirements).

Point take...  I'll do some aged filesystem test to see how if are some
real benefits to be gain in reducing fragmentation.  

> 
> 						- Ted

-JRS
