From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Mon, 2 Jul 2007 09:39:03 -0500
Message-ID: <20070702093903.77e0f947@rx8>
References: <20070629170958.13b7700c@gara>
	<D5D3223C-4EB0-413B-A81A-05F6DDC0FEEB@bull.net>
	<20070630234011.38b4bb22@gara>
	<20070701163153.GB5419@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Laurent Vivier <Laurent.Vivier@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:54231 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbXGBOmB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jul 2007 10:42:01 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l62EfxIe014838
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jul 2007 10:41:59 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l62Efm24260318
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jul 2007 08:41:56 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l62EfbVo020365
	for <linux-ext4@vger.kernel.org>; Mon, 2 Jul 2007 08:41:37 -0600
In-Reply-To: <20070701163153.GB5419@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 1 Jul 2007 12:31:53 -0400
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Jun 30, 2007  23:40 -0500, Jose R. Santos wrote:
> > Yes, I think bigger block groups will benefit extents a great deal
> > since not only can we have larger extents, but I believe that as the
> > filesystem ages the chances of getting large number contiguous
> > block can be reduce with small block groups.
> 
> This turns out not to be true, and in fact we need to change the
> unwritten extents patch a tiny bit.  The reason is that we have
> limited the maximum extent size to 2^16-1 = 32767 blocks.  The
> current maximum for the number of blocks in a group is 65528, so that
> we can always fit the "free blocks" count into a __u16 if the bitmaps
> and inode table are moved out of the group.  Moving the bitmaps and
> itable will hit the max extent length.

I miss this while looking at the extent code.  I thought that the
extents limit was caused by being unable to allocate enough contiguous
blocks due to the small block groups.

Are there no plans to support very large extents?  It seems like this
would be a good reason to support either BIG_BG or xMETA_BG.  Aside
from some possible alignment issues with the structure, what else would
keep would keep ee_len from being larger?
 
> There are still other benefits to moving the metadata together.
> 
> Now, the one minor problem with the unwritten extent patches is that
> by using the high bit of the ee_len this limits the extent length to
> 2^15-1 blocks, but it would be MUCH better if this limit was 2^16
> blocks and it fit evenly into an empty group, consecutive extents
> were aligned, etc. It also doesn't make sense to have an
> uninitialized 0-length extent, so I think the unwritten extent
> (fallocate) patch needs to special case the ee_len = 65536 to be a
> "regular" extent instead of "unwritten"
> 
> > > With less groups, we load less group descriptors in memory, we
> > > have less I/O to read bitmap and inode array (because we manage
> > > less group descriptors again, because we load bigger bitmap and
> > > array in one time)
> > 
> > Presumably, we would still need to access the same amount data but
> > latencies should be reduce since we could do larger IO's and less
> > seeks to read the bitmaps.  I also wonder if there are benefits in
> > terms of locality to having the bitmaps closer to its blocks vs
> > having them far away like in xMETA_BG.
> 
> Having the bitmaps together will fix this independent of "BIG_BG".

I was referring to the locality of block bit maps and the actual free
blocks.  If we move the block bitmaps out of block group, wouldn't we 
be promoting larger seeks on operations that heavily write to both the
bitmaps and blocks?

This would not be a problem for inode bitmap and itables since those
would be move together in xMETA_BG.

Thanks

-JRS
