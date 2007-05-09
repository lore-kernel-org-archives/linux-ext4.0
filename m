From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Ext4 devel interlock meeting minutes (May 7, 2007)
Date: Wed, 09 May 2007 11:10:32 -0700
Message-ID: <1178734232.3815.25.camel@dyn9047017103.beaverton.ibm.com>
References: <4641FE96.6010603@linux.vnet.ibm.com>
	 <20070509173740.GQ6375@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:50838 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbXEISKg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 14:10:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l49IAYuI023483
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 14:10:34 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49IAYbq143676
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 12:10:34 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49IAXtJ022119
	for <linux-ext4@vger.kernel.org>; Wed, 9 May 2007 12:10:33 -0600
In-Reply-To: <20070509173740.GQ6375@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-05-09 at 10:37 -0700, Andreas Dilger wrote:
> On May 09, 2007  10:02 -0700, Avantika Mathur wrote:
> > Metablock Groups:
> > 
> > - Mingming mentioned that in the metablock group feature, the inode 
> > metadata is not moved with the rest of the metadata.  Ted will check 
> > this, as he thought this had been implemented.
> > 
> > - Online resize does not use metablock groups, and is currently limited 
> > to 2TB.
> > 
> > - Also need to remove sanity checks in the mount code
> > 
> > - Once these issues are fixed, the metablock group feature can be turned 
> > on by default for ext4 filesysytems
> 
> In my recent investigation of META_BG, it appears that BOTH the kernel
> and e2fsprogs do NOT handle group metadata (bitmaps, itable) outside the
> group.
> 
> In the kernel ext[234]_check_descriptors() requires the bitmaps and itable
> to be inside the group even though META_BG is supported for a long time.
> 
> In e2fsck/super.c check_super_block() also requires that the bitmaps and
> itable be inside the group even though e2fsck has claimed META_BG for a
> long time.
> 
> That means it is virtually impossible to allow the group metadata to move
> under the META_BG feature.

Understand it's not straightforward to turn on this feature by default.
Just try to understand, why the kernel and e2fsprogs issues you
mentioned above are not possible to fix to support full META_BG
feature? 

>   It might be possible to predicate this change
> under both 64BIT and META_BG, though this is somewhat non-standard.
> 
> Alternately, we could allow the relocation of bitmaps and itables under
> BIG_BG, which is itself covers the relocation aspects and also allows
> the ability to change the group size.
> 

Well, I think the previous discussion about BIG_BG feature leads us to
believe that turn on META_BG feature is good enough to support larger fs
and reduce fragmentation(which is the new BIG_BG feature is trying to
address).  After all the relocation of metadata (bitmaps, itables and
group descriptors) is what META_BG feature means.


Regards,
Mingming
