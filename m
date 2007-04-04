From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Ext4 benchmarks
Date: Wed, 04 Apr 2007 14:18:19 -0700
Message-ID: <1175721499.3777.32.camel@ibm-237399vnbgl.beaverton.ibm.com>
References: <45FFFBAA.6080404@bull.net> <4613DB20.1040605@bull.net>
	 <20070404192159.GS5967@schatzie.adilger.int>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Cordenner jean noel <jean-noel.cordenner@bull.net>,
	linux-ext4@vger.kernel.org,
	"AVANTIKA R. MATHUR" <mathur@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35039 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXDDVSY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Apr 2007 17:18:24 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l34LIL31030654
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 17:18:21 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l34LILYs191800
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 15:18:21 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l34LIKbQ022683
	for <linux-ext4@vger.kernel.org>; Wed, 4 Apr 2007 15:18:21 -0600
In-Reply-To: <20070404192159.GS5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-04-04 at 13:21 -0600, Andreas Dilger wrote:
> On Apr 04, 2007  19:06 +0200, Cordenner jean noel wrote:
> > here is the first results of the round:
> > http://www.bullopensource.org/ext4/20070404/
> 
> Jean Noel,
> thank you for the test results.  It is always nice to see that ext4 is
> doing so well compared to ext3 and XFS.
> 
> Ming Ming,
> it should be possible to just include the mballoc+delalloc patches that
> Jean Noel used into the upstream ext4 patch series.  When Alex or Christoph
> get a chance to do the VFS delalloc rewrite we can move to that new patch,
> but until then it seems pointless to not include this functionality which
> improves the performance so much.
> 
>From the bull website it said the test is based on 2.6.21-rc4 kernel +
delalloc patch. I don't think that includes the mballoc patch.

> Also, if we include those patches the mballoc and delalloc features (along
> with extents) should be enabled by default if INCOMPAT_EXTENTS is in the
> superblock unless:
> - "noextents", "nomballoc", or "nodelalloc" mount options are given

I just added noextents and nodelalloc mount options in the 2.6.21-rc5
version ext4 patch queue.

But we should keep delalloc with nomballoc.  The current delalloc patch
in ext4 tree plays well without mballoc.  We still could do multiple
block allocations with delayed allocation, though not as smart as Alex's
mballoc.

> - delalloc needs to be disabled if blocksize != PAGE_SIZE
> 
I believe the current ext4 delalloc code turns off delalloc in this case
already.

> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
