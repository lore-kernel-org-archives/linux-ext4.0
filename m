From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] mballoc update
Date: Tue, 8 Jan 2008 17:13:57 +0530
Message-ID: <20080108114357.GB11659@skywalker>
References: <20080108063114.GA6615@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Alex Tomas <bzzz@sun.com>, Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:56893 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbYAHLoE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jan 2008 06:44:04 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m08BhaKZ017369
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 22:43:36 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m08BldC2210156
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 22:47:39 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m08Bi1Is028083
	for <linux-ext4@vger.kernel.org>; Tue, 8 Jan 2008 22:44:02 +1100
Content-Disposition: inline
In-Reply-To: <20080108063114.GA6615@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 08, 2008 at 12:01:14PM +0530, Aneesh Kumar K.V wrote:
> Hi,
> 
> This is the update for mballoc patch. The changes are result of merging
> with the lustre cvs version of mballoc. I liked this patch better because
> it is simple. I also the updated the commit message. The update commit
> message is also attached below. We only have one FIXME!! in the commit
> message now to explain the inode buddy cache  allocator.
> 
> Let me know what you think.
> 
> This is not yet for patch queue. I will update the mballoc-core.patch
> and send it the full patch later.

The patch for patch queue can be found at

http://www.radian.org/~kvaneesh/ext4/jan-8-2008/mballoc-core.patch

-aneesh
