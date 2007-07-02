From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Mon, 02 Jul 2007 10:12:57 -0400
Message-ID: <1183385577.3864.7.camel@localhost.localdomain>
References: <20070629170958.13b7700c@gara>
	 <20070630055125.GC5535@schatzie.adilger.int> <20070630233908.115ec78e@gara>
	 <20070701123054.GC28917@thunk.org> <20070701094833.47035331@gara>
	 <20070702154939.GC4720@thunk.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50833 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbXGBRM5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Jul 2007 13:12:57 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l62HCulK022519
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jul 2007 13:12:56 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l62HCuV2523178
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jul 2007 13:12:56 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l62HCu8b005761
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jul 2007 13:12:56 -0400
In-Reply-To: <20070702154939.GC4720@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-07-02 at 11:49 -0400, Theodore Tso wrote:
> On Sun, Jul 01, 2007 at 09:48:33AM -0500, Jose R. Santos wrote:
> > Is your concern due to being unable to find contiguous block in the
> > case that a bad disk area is in one of the bitmap blocks?  One thing we
> > can do is try to search for another set of contiguous blocks and if we
> > fail to find one, we can flag the block group and move to an indirect
> > block approach to allocating the bitmaps.  At this point, we do lose
> > some of the performance benefits of BIG_BG, but we would still be able
> > to use the block group.
> 
> Yes, my concern is what we might need to do if for some reason e2fsck
> needs to reallocate the bitmap blocks.  I don't think an indirect
> block scheme is the right approach, though; we're adding a lot of
> complexity for a case that probably wouldn't be used but very, very
> rarely.
> 
> My proposal (as we discsused) in the call, is to implement BIG_BG as
> meaning the following:
> 
> 	1) Implementations must understand and use the s_desc_size
> 	superblock field to determine whether block group descriptors
> 	are the old 32 bytes or the newer 64 bytes format.  
> 	
> 	2) Implementations must support the newer ext4_group_desc
> 	format in particular to support bg_free_blocks_count_hi and
> 	bg_free_inodes_count_hi
> 
> 	3) Implementations will relax constraints on where the
> 	superblock, bitmaps, and inode tables for a particular block
> 	group will be stored.
>

I agree.

> So with that, we can experiment with what size block groups really
> make sense, versus using the extended metablockgroup idea, or possibly
> doing both.
> 

How about incorporating some of the chunkfs ideas into this BIG_BG or
extended metablockgroups? The original block group size (128MB) is
probably too small that would results in many continous inodes. By
enlarging the size of groups via BIG_BG or extended metablockgroups, we
could add dirty/clean bit to allow partical/parallel fsck, and something
like that. Any thoughts on thhis?


Mingming
