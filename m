From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Missing JBD2_FEATURE_INCOMPAT_64BIT in ext4
Date: Thu, 19 Apr 2007 17:41:43 -0700
Message-ID: <1177029704.6703.46.camel@dyn9047017103.beaverton.ibm.com>
References: <20070415161606.GG5967@schatzie.adilger.int>
	 <1177010100.6703.8.camel@dyn9047017103.beaverton.ibm.com>
	 <20070419211817.GO5967@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:52311 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXDTAls (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Apr 2007 20:41:48 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3K0fjrK007370
	for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2007 20:41:45 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3K0fj4m165552
	for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2007 18:41:45 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3K0fjFc019644
	for <linux-ext4@vger.kernel.org>; Thu, 19 Apr 2007 18:41:45 -0600
In-Reply-To: <20070419211817.GO5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2007-04-19 at 15:18 -0600, Andreas Dilger wrote:
> On Apr 19, 2007  12:15 -0700, Mingming Cao wrote:
> > On Sun, 2007-04-15 at 10:16 -0600, Andreas Dilger wrote:
> > > Just a quick note before I forget.  I thought there was a call in ext4
> > > to set JBD2_FEATURE_INCOMPAT_64BIT at mount time if the filesystem has
> > > more than 2^32 blocks?
> > 
> > Question about the online resize case. If the fs is increased to more
> > than 2^32 blocks, we should set this JBD2_FEATURE_INCOMPAT_64BIT in the
> > journal. What about existing transactions that still stores 32 bit block
> > numbers?  I guess the journal need to commit them all so that revoke
> > will not get confused about the bits for block numbers later.  After
> > that done then JBD2 can set this feature safely.
> 
> Well, there are two options here:
> 1) refuse resizing filesystems beyond 16TB
>    - this is required if they were not formatted as ext4 to start with, as
>      the group descriptors will not be large enough to handle the "_hi"
>      word in the bitmap/inode table locations
>    - this is also a problem for block-mapped files that need to allocate
>      blocks beyond 16TB (though this could just fail on those files with
>      e.g. ENOSPC or EFBIG or something similar)

I agree for fs not formatted as ext4(block-map based ext3 but mounted as
ext4), resize fs to >16TB is not possible

This concern is mostly for new formated ext4, which by default is
extents based. 


> 2) flush the journal (like ext4_write_super_lockfs()) while resizing beyond
>    16TB.  

Ah. thanks for point this out.

> This would also require changing over to META_BG at some point,
>    because there cannot be enough reserved group descriptor blocks (the
>    resize_inode is set up for a maximum of 2TB filesystems I think)
>    

Any concerns about turn on META_BG by default for all new ext4 fs?
Initially I thought we only need META_BG for support >256TB, so there is
no rush to turn it on for all the new fs. But it appears there are
multiple benefits to enable META_BG by default:

- enable online resize >2TB
- support >256TB fs 
- Since metadatas(bitmaps, group descriptors etc) are not put at the
beginning of each block group anymore, the 128MB limit(block group size
with 4k block size) that used to limit an extent size is removed. 
- Speed up fsck since metadata are placed closely. 

So I am wondering why not make it default?

Mingming
