From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: Problem with delayed allocation
Date: Wed, 06 Aug 2008 17:49:52 -0700
Message-ID: <1218070193.6383.61.camel@mingming-laptop>
References: <E1KPNNn-0003IN-0B@closure.thunk.org>
	 <20080804163505.GE9397@skywalker> <20080805064428.GB8569@mit.edu>
	 <20080805065217.GF9397@skywalker> <20080805132133.GA15568@skywalker>
	 <20080806100553.GB31907@skywalker>  <20080806101154.GC31907@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50421 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYHGAtz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Aug 2008 20:49:55 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m770nsvb030122
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 20:49:54 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m770nrQL213736
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 20:49:53 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m770nq7f022320
	for <linux-ext4@vger.kernel.org>; Wed, 6 Aug 2008 20:49:52 -0400
In-Reply-To: <20080806101154.GC31907@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > Below changes fixed it for me. range_start was used in the loop in
> > generic_sync_sb_inodes and since we were checking for !range_start
> > we missed restoring wbc->range_start for range_start == 0.
> > 


I added this patch to patch queue for more testing. I will split the
journal credit fix patch and drop some of the original fix for the
writepages, that means this patch need to be update also ...but at least
add to the queue for  more testing

Mingming

