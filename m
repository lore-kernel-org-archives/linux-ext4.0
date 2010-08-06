From: Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: Raid FFSB Benchmark results for 2.6.35-rc5
Date: Fri, 06 Aug 2010 14:21:59 -0700
Message-ID: <1281129719.7357.30.camel@keith-laptop>
References: <1281121633.7357.26.camel@keith-laptop>
	 <20100806191439.GD24583@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:40043 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab0HFVWD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2010 17:22:03 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o76LDNrX023347
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 15:13:23 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o76LLvVn061262
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 15:21:59 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o76LLvIm011851
	for <linux-ext4@vger.kernel.org>; Fri, 6 Aug 2010 15:21:57 -0600
In-Reply-To: <20100806191439.GD24583@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2010-08-06 at 15:14 -0400, Ted Ts'o wrote:
> On Fri, Aug 06, 2010 at 12:07:13PM -0700, Keith Mannthey wrote:
> > This is a collection of benchmark runs with the FFSB test suite. The
> > results are comparable to other raid results on the boxacle server. 
> > 
> > The latest results can be found at: 
> > http://btrfs.boxacle.net/repository/raid/2.6.35-rc5/2.6.35-rc5/2.6.35-rc5.html
> > 
> > I added XFS without barriers and EXT3 with barriers into the mix since
> > my last data set. 
> 
> Thanks, it's good to know there haven't been any major regression on
> the ext4 side.
> 
> If you could have a chance to run a set of benchmark runs with the
> jbd2 scalability patches, I'd be hugely interested to see how much
> difference they make.

Yes I am running with those today.  As the system is only a 16-way or so
it will be interesting to see the impact. 

I also have a few barrier reduction patchset test runs as well.  I will
work to put them all together and publish some ext4 only relevant run in
the next few days.  

Thanks,
  Keith 


> Thanks again!
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

