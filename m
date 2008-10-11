From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Use an rb tree for tracking blocks freed during
	transaction.
Date: Sat, 11 Oct 2008 23:38:00 +0530
Message-ID: <20081011180800.GA9662@skywalker>
References: <1223566329-29434-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081011042738.GC8145@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43787 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639AbYJKSIS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Oct 2008 14:08:18 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9BI7MA4020645
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 05:07:22 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9BI8G124309020
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 05:08:16 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9BI8GZN020582
	for <linux-ext4@vger.kernel.org>; Sun, 12 Oct 2008 05:08:16 +1100
Content-Disposition: inline
In-Reply-To: <20081011042738.GC8145@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 11, 2008 at 12:27:38AM -0400, Theodore Tso wrote:
> On Thu, Oct 09, 2008 at 09:02:07PM +0530, Aneesh Kumar K.V wrote:
> > With this patch we track the block freed during a transaction using
> > rb tree. We also make sure contiguos blocks freed are collected
> > in one rb node.
> 
> Thanks, I've added your recent set of patches to the ext4 patch queue.
> I'm pretty sure I grabbed the correct (most recent) patches from the
> mailing list, but please double check for me.
> 

I verified the patch queue. It looks fine. I also tested the latest
patchqueue (I commented out the defrag patch because they were giving
error during apply) on ABAT and all the tests PASSED.

-aneesh
