From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/4 v3] ext3/4: enhance fsync performance when using CFQ
Date: Thu, 15 Apr 2010 09:05:33 -0400
Message-ID: <x498w8oj276.fsf@segfault.boston.devel.redhat.com>
References: <1271279826-30294-1-git-send-email-jmoyer@redhat.com>
	<20100415103345.GY27497@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	vgoyal@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100415103345.GY27497@kernel.dk> (Jens Axboe's message of "Thu,
	15 Apr 2010 12:33:45 +0200")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Wed, Apr 14 2010, Jeff Moyer wrote:
>> Hi,
>> 
>> The previous two postings can be found here:
>>   http://lkml.org/lkml/2010/4/1/344
>> and here:
>>   http://lkml.org/lkml/2010/4/7/325
>> 
>> The basic problem is that, when running iozone on smallish files (up to
>> 8MB in size) and including fsync in the timings, deadline outperforms
>> CFQ by a factor of about 5 for 64KB files, and by about 10% for 8MB
>> files.  From examining the blktrace data, it appears that iozone will
>> issue an fsync() call, and subsequently wait until its CFQ timeslice
>> has expired before the journal thread can run to actually commit data to
>> disk.
>> 
>> The approach taken to solve this problem is to implement a blk_yield call,
>> which tells the I/O scheduler not to idle on this process' queue.  The call
>> is made from the jbd[2] log_wait_commit function.
>> 
>> This patch set addresses previous concerns that the sync-noidle workload
>> would be starved by keeping track of the average think time for that
>> workload and using that to decide whether or not to yield the queue.
>> 
>> My testing showed nothing but improvements for mixed workloads, though I
>> wouldn't call the testing exhaustive.  I'd still very much like feedback
>> on the approach from jbd/jbd2 developers.  Finally, I will continue to do
>> performance analysis of the patches.
>
> This is starting to look better. Can you share what tests you did? I
> tried reproducing with fs_mark last time and could not.

Did you use the fs_mark command line I (think I) had posted?  What
storage were you using?

I took Vivek's iostest and modified the mixed workload to do buffered
random reader, buffered sequential reader, and buffered writer for all
of 1, 2, 4, 8 and 16 threads each.

The initial problem was reported against iozone, which can show the
problem quite easily when run like so:
  iozone -s 64 -e -f /mnt/test/iozone.0 -i 0 -+n

You can also just run iozone in auto mode, but that can take quite a
while to complete.

All of my tests for this round have been against a NetApp hardware
RAID.  I wanted to test against a simple sata disk as well, but have
become swamped with other issues.

I'll include all of this information in the next patch posting.  Sorry
about that.

Cheers,
Jeff
