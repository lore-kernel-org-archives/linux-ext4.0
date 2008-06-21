From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] delalloc: add quota handling
Date: Sat, 21 Jun 2008 16:37:27 +0530
Message-ID: <20080621110727.GC9584@skywalker>
References: <1214010878.27507.228.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:40679 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYFULHl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jun 2008 07:07:41 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5LB6ngv029230
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 21:06:49 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5LB7cOP244520
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 21:07:38 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5LB7b9p009625
	for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 21:07:38 +1000
Content-Disposition: inline
In-Reply-To: <1214010878.27507.228.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 20, 2008 at 06:14:38PM -0700, Mingming wrote:
> Correct quota handling in delayed allocation. With this patch,
> the quota for blocks are counted at block reservation time when
> the fs free blocks counter are updated, instead of at later 
> block allocation time.
> 

So what happens if we crash after quota update but before allocating
blocks ?  Will e2fsck fix it ?.


-aneesh
