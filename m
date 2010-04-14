From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/4 v3] ext3/4: enhance fsync performance when using CFQ
Date: Wed, 14 Apr 2010 17:17:02 -0400
Message-ID: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	vgoyal@redhat.com
To: jens.axboe@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab0DNVRL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 17:17:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

The previous two postings can be found here:
  http://lkml.org/lkml/2010/4/1/344
and here:
  http://lkml.org/lkml/2010/4/7/325

The basic problem is that, when running iozone on smallish files (up to
8MB in size) and including fsync in the timings, deadline outperforms
CFQ by a factor of about 5 for 64KB files, and by about 10% for 8MB
files.  From examining the blktrace data, it appears that iozone will
issue an fsync() call, and subsequently wait until its CFQ timeslice
has expired before the journal thread can run to actually commit data to
disk.

The approach taken to solve this problem is to implement a blk_yield call,
which tells the I/O scheduler not to idle on this process' queue.  The call
is made from the jbd[2] log_wait_commit function.

This patch set addresses previous concerns that the sync-noidle workload
would be starved by keeping track of the average think time for that
workload and using that to decide whether or not to yield the queue.

My testing showed nothing but improvements for mixed workloads, though I
wouldn't call the testing exhaustive.  I'd still very much like feedback
on the approach from jbd/jbd2 developers.  Finally, I will continue to do
performance analysis of the patches.

Cheers,
Jeff

[PATCH 1/4] cfq-iosched: Keep track of average think time for the sync-noidle workload.
[PATCH 2/4] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
[PATCH 3/4] jbd: yield the device queue when waiting for commits
[PATCH 4/4] jbd2: yield the device queue when waiting for journal commits
