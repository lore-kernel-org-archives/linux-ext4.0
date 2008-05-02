From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] ext4: Group meta-data blocks together.
Date: Fri, 2 May 2008 23:42:33 +0530
Message-ID: <20080502181233.GA12049@skywalker>
References: <1209466647-26681-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080502174901.GC2950@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:54308 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYEBSMp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 May 2008 14:12:45 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m42ICgmw027950
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 23:42:42 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m42ICZYY1380378
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 23:42:35 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m42ICfF2016563
	for <linux-ext4@vger.kernel.org>; Fri, 2 May 2008 18:12:42 GMT
Content-Disposition: inline
In-Reply-To: <20080502174901.GC2950@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 02, 2008 at 10:49:01AM -0700, Andreas Dilger wrote:
> On Apr 29, 2008  16:27 +0530, Aneesh Kumar K.V wrote:
> > I haven't yet tested this. Let me know what you think.
> > 
> > -aneesh
> > 
> > This adds a per inode meta-block prealloc space from which
> > meta-data block requests are served. This help in making
> > sure meta-data block are closer. This is needed to speedup
> > unlink of the file. Any new prealloc space is allocated near
> > the goal block specified. The goal block is the last block
> > allocated for the file. So we don't keep the data-block and
> > meta-data block far apart.
> 
> Does this code use the mballoc "group allocator" mechanism that it
> already uses for small files?  It would be convenient to re-use
> this code by creating a "metadata allocation group" instead of creating
> another mechanism to aggregate small IO allocations.
> 

That is mostly what it does. Except that the allocation space is hanging
from the inode rather than per-cpu.

-aneesh
