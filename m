From: Badari Pulavarty <pbadari@gmail.com>
Subject: Re: [PATCH][RFC]JBD2: Fix journal checksum kernel oops on NUMA
Date: Mon, 05 Nov 2007 10:07:33 -0800
Message-ID: <1194286053.17333.14.camel@dyn9047017100.beaverton.ibm.com>
References: <46D7097F.4020501@linux.vnet.ibm.com>
	 <1188552066.3781.15.camel@dhcp5.linsyssoft.com>
	 <1193964035.4014.23.camel@localhost.localdomain>
	 <20071102052031.GC18505@webber.adilger.int>
	 <1194021108.1547.14.camel@dyn9047017100.beaverton.ibm.com>
	 <20071103013621.GC2863@webber.adilger.int>
	 <1194278695.17333.3.camel@dyn9047017100.beaverton.ibm.com>
	 <20071105161529.GC2892@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>,
	Girish Shilamkar <girish@clusterfs.com>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:48846 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbXKESGf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2007 13:06:35 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA5I6QY2029511
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 13:06:26 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA5I6DBl102602
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 11:06:19 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA5I6BCN026639
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 11:06:13 -0700
In-Reply-To: <20071105161529.GC2892@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-11-06 at 00:15 +0800, Andreas Dilger wrote:
> On Nov 05, 2007  08:04 -0800, Badari Pulavarty wrote:
> > On Sat, 2007-11-03 at 09:36 +0800, Andreas Dilger wrote:
> > > But...  this implies that every user of bh->b_data needs to kmap, and I
> > > don't see that in the code anywhere else.  That makes me think something
> > > else is going wrong here.
> > 
> > Most cases, this is handled in ll_rw_block() code - when we submit the
> > buffer head for IO. If the page is in highmem, we will end up creating
> > a bounce bufer for it. 
> > 
> > In our case, JBD code is trying to look at the data to do checksum
> > on it. Thats why we have to kmap() the page before looking.
> 
> My point is that there is a LOT of code in ext[234] that dereferences
> bh->b_data without kmap() (e.g. group descriptors, bitmaps, superblock,
> inode tables, etc).  Does that imply that something is forcing those
> bh pages into lowmem, or is the journal bh page in question being
> allocated in some different way that allows it to be in highmem?

Yes. You are right. Its been a while since I had to deal with HIGHMEM.
All the meta-data should be in LOWMEM. I asked Mingming to verify
what the buffer-head is pointing to when it has HIGHMEM page.

Thanks,
Badari
