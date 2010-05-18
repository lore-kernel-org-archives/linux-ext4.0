From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/4 v4] ext3/4: enhance fsync performance when using CFQ
Date: Tue, 18 May 2010 14:20:16 -0400
Message-ID: <1274206820-17071-1-git-send-email-jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, jens.axboe@oracle.com,
	vgoyal@redhat.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

In this, the fourth posting of this patch series, I've addressed the following
issues:
- cfq queue yielding is now done in select_queue instead of the dispatch routine
- minor patch review comments were addressed
- the queue is now yielded to a specific task

For those not familiar with this patch set already, previous discussions
appeared here:
  http://lkml.org/lkml/2010/4/1/344
  http://lkml.org/lkml/2010/4/7/325
  http://lkml.org/lkml/2010/4/14/394

This patch series addresses a performance problem experienced when running
io_zone with small file sizes (from 4KB up to 8MB) and including fsync in
the timings.  A good example of this would be the following command line:
  iozone -s 64 -e -f /mnt/test/iozone.0 -i 0
As the file sizes get larger, the performance improves.  By the time the
file size is 16MB, there is no difference in performance between runs
using CFQ and runs using deadline.  The storage in my testing was a NetApp
array connected via a single fibre channel link.  When testing against a
single SATA disk, the performance difference is not apparent.

fs_mark can also be used to show the performance problem using the following
example command line:
  fs_mark  -S  1  -D  100  -N  1000  -d  /mnt/test/fs_mark  -s  65536  -t  1  -w  4096

Following are some performance numbers from my testing.  The below numbers
represent an average of 5 runs for each configuration when running: 
        iozone -s 64 -e -f /mnt/test/iozone.0 -i 0
Numbers are in KB/s.

            |    SATA      |     %diff      ||      SAN      |     %diff
            |write |rewrite| write |rewrite || write |rewrite| write |rewrite
------------+--------------+----------------++-------------------------------
deadline    | 1452 |  1788 | 1.0   | 1.0    || 35611 | 46260 | 1.0   | 1.0
vanilla cfq | 1323 |  1330 | 0.91  | 0.74   ||  6725 |  7163 | 0.19  | 0.15
patched cfq | 1591 |  1485 | 1.10  | 0.83   || 35555 | 46358 | 1.0   | 1.0


Here are some fs_mark numbers from the same storage configurations:

            SATA | SAN
           file/s|file/s
----------+------+------
deadline  | 33.7 | 538.9
unpatched | 33.5 | 110.2
  patched | 35.6 | 558.9

It's worth noting that this patch series only helps a single stream of I/O in
my testing.  What I mean by that is, if you were to add a single sequential
reader into the mix, the performance of CFQ again drops for the fsync-ing
process.  I fought with that for a while, but I think it is likely the subject
for another patch series.

I'd like to get some comments and performance testing feedback from others
as I'm not yet 100% convinced of the merits of this approach.

Cheers,
Jeff

[PATCH 1/4] cfq-iosched: Keep track of average think time for the sync-noidle workload.
[PATCH 2/4] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
[PATCH 3/4] jbd: yield the device queue when waiting for commits
[PATCH 4/4] jbd2: yield the device queue when waiting for journal commits
