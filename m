From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Don't overwrite allocation_context ac_status
Date: Wed, 17 Dec 2008 14:24:10 +0530
Message-ID: <20081217085410.GB7685@skywalker>
References: <1228914463-12716-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081212175922.GC26085@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [59.145.155.5] ([59.145.155.5]:41804 "EHLO e28smtp05.in.ibm.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbYLQJOw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Dec 2008 04:14:52 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id mBH8sBdE025704
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 14:24:11 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mBH8r3oB4067512
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 14:23:03 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id mBH8sAY1003104
	for <linux-ext4@vger.kernel.org>; Wed, 17 Dec 2008 19:54:11 +1100
Content-Disposition: inline
In-Reply-To: <20081212175922.GC26085@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 12, 2008 at 12:59:22PM -0500, Theodore Tso wrote:
> On Wed, Dec 10, 2008 at 06:37:43PM +0530, Aneesh Kumar K.V wrote:
> > We can call ext4_mb_check_limits even after successfull
> > allocation. Make sure we don't overwrite ac_status.
> > This fix the below lockdep warning
> 
> So the ext4_mb_check_limits() function isn't that well documented, but
> one of the things it is supposed to do is to make sure that blocks
> comprising the extent that was found is in fact still available.  This
> check patches this out.   Are we sure this does the right thing?

ext4_mb_check_limits does allocation in complex_scan. In complex scan
we loop through available free blocks and try to find the best extent.
We also want to make sure we doesn't loop too much. So
ext4_mb_check_limits  and ext4_mb_measure_extent does multiple things.


Now what we do in complex_scan is

for blocks in group:
	ext4_mb_find_extent();
	ext4_mb_measure_extents()

ext4_mb_check_limits(..., 1);

Now ext4_mb_measure_extents() can result in successfull
allocation. So we need to make sure we don't do further allocation in
ext4_mb_check_limits when we call ext4_mb_check_limits later with
finish_group = 1;


-aneesh

