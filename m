From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] BIG_BG vs extended META_BG in ext4
Date: Sun, 1 Jul 2007 12:31:53 -0400
Message-ID: <20070701163153.GB5419@schatzie.adilger.int>
References: <20070629170958.13b7700c@gara> <D5D3223C-4EB0-413B-A81A-05F6DDC0FEEB@bull.net> <20070630234011.38b4bb22@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laurent Vivier <Laurent.Vivier@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:50680 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXGAQb4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jul 2007 12:31:56 -0400
Content-Disposition: inline
In-Reply-To: <20070630234011.38b4bb22@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 30, 2007  23:40 -0500, Jose R. Santos wrote:
> Yes, I think bigger block groups will benefit extents a great deal
> since not only can we have larger extents, but I believe that as the
> filesystem ages the chances of getting large number contiguous block can
> be reduce with small block groups.

This turns out not to be true, and in fact we need to change the unwritten
extents patch a tiny bit.  The reason is that we have limited the maximum
extent size to 2^16-1 = 32767 blocks.  The current maximum for the number
of blocks in a group is 65528, so that we can always fit the "free blocks"
count into a __u16 if the bitmaps and inode table are moved out of the
group.  Moving the bitmaps and itable will hit the max extent length.

There are still other benefits to moving the metadata together.

Now, the one minor problem with the unwritten extent patches is that by
using the high bit of the ee_len this limits the extent length to 2^15-1
blocks, but it would be MUCH better if this limit was 2^16 blocks and
it fit evenly into an empty group, consecutive extents were aligned, etc.
It also doesn't make sense to have an uninitialized 0-length extent, so
I think the unwritten extent (fallocate) patch needs to special case
the ee_len = 65536 to be a "regular" extent instead of "unwritten".

> > With less groups, we load less group descriptors in memory, we have  
> > less I/O to read bitmap and inode array (because we manage less group  
> > descriptors again, because we load bigger bitmap and array in one time)
> 
> Presumably, we would still need to access the same amount data but
> latencies should be reduce since we could do larger IO's and less seeks
> to read the bitmaps.  I also wonder if there are benefits in terms of
> locality to having the bitmaps closer to its blocks vs having them far
> away like in xMETA_BG.

Having the bitmaps together will fix this independent of "BIG_BG".

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
