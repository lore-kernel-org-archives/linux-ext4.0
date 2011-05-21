From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch
 Hole Test Routines
Date: Sat, 21 May 2011 13:57:04 +1000
Message-ID: <20110521035704.GW32466@dastard>
References: <4DD43300.6010908@linux.vnet.ibm.com>
 <20110519013144.GF32466@dastard>
 <4DD560CF.3040706@linux.vnet.ibm.com>
 <20110519235601.GL32466@dastard>
 <4DD5C242.3010708@linux.vnet.ibm.com>
 <4DD70B5B.6090400@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39872 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218Ab1EUD5L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 May 2011 23:57:11 -0400
Content-Disposition: inline
In-Reply-To: <4DD70B5B.6090400@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 20, 2011 at 05:46:19PM -0700, Allison Henderson wrote:
> On 5/19/2011 6:22 PM, Allison Henderson wrote:
> >Also, there was one more test that I meant to be a part of this
> >collection, but I was not finished with it at the time I submitted the
> >patch for feedback. Basically it checks to see if a hole can still be
> >punched out when the disk is full. In ext4 this is allowable because
> >reserved space is used to allow the operation to proceed where it would
> >have otherwise failed. I'm not sure if this is also ext4 specific
> >though. Would this be another candidate for adding to 252? Thx!
> 
> I just didnt want this question to get washed away in the traffic.
> I am working on an updated patch set, should I include the extra
> test case?  Thx!

Yes, though probably not in the _generic_test_punch function. And
extra case specific to 252 that does something like:

	umount SCRATCH_DEV
	make a small filesystem
	scratch_mount
	prealloc to ENOSPC
	punch


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
