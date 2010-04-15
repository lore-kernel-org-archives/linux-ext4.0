From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/4 v3] ext3/4: enhance fsync performance when using CFQ
Date: Thu, 15 Apr 2010 12:33:45 +0200
Message-ID: <20100415103345.GY27497@kernel.dk>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	vgoyal@redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52899 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab0DOKdq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Apr 2010 06:33:46 -0400
Content-Disposition: inline
In-Reply-To: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 14 2010, Jeff Moyer wrote:
> Hi,
> 
> The previous two postings can be found here:
>   http://lkml.org/lkml/2010/4/1/344
> and here:
>   http://lkml.org/lkml/2010/4/7/325
> 
> The basic problem is that, when running iozone on smallish files (up to
> 8MB in size) and including fsync in the timings, deadline outperforms
> CFQ by a factor of about 5 for 64KB files, and by about 10% for 8MB
> files.  From examining the blktrace data, it appears that iozone will
> issue an fsync() call, and subsequently wait until its CFQ timeslice
> has expired before the journal thread can run to actually commit data to
> disk.
> 
> The approach taken to solve this problem is to implement a blk_yield call,
> which tells the I/O scheduler not to idle on this process' queue.  The call
> is made from the jbd[2] log_wait_commit function.
> 
> This patch set addresses previous concerns that the sync-noidle workload
> would be starved by keeping track of the average think time for that
> workload and using that to decide whether or not to yield the queue.
> 
> My testing showed nothing but improvements for mixed workloads, though I
> wouldn't call the testing exhaustive.  I'd still very much like feedback
> on the approach from jbd/jbd2 developers.  Finally, I will continue to do
> performance analysis of the patches.

This is starting to look better. Can you share what tests you did? I
tried reproducing with fs_mark last time and could not.

-- 
Jens Axboe

