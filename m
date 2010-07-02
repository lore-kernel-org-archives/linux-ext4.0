From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/6 v6][RFC] jbd[2]: enhance fsync performance when using CFQ
Date: Fri,  2 Jul 2010 15:58:13 -0400
Message-ID: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
	tao.ma@oracle.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Running iozone or fs_mark with fsync enabled, the performance of CFQ is
far worse than that of deadline for enterprise class storage when dealing
with file sizes of 8MB or less.  I used the following command line as a
representative test case:

  fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096 -F

When run using the deadline I/O scheduler, an average of the first 5 numbers
will give you 529.44 files / second.  CFQ will yield only 106.7.

Because the iozone process is issuing synchronous writes, it is put
onto CFQ's SYNC service tree.  The significance of this is that CFQ
will idle for up to 8ms waiting for requests on such queues.  So,
what happens is that the iozone process will issue, say, 64KB worth
of write I/O.  That I/O will just land in the page cache.  Then, the
iozone process does an fsync which forces those I/Os to disk as
synchronous writes.  Then, the file system's fsync method is invoked,
and for ext3/4, it calls log_start_commit followed by log_wait_commit.
Because those synchronous writes were forced out in the context of the
iozone process, CFQ will now idle on iozone's cfqq waiting for more I/O.
However, iozone's progress is gated by the journal thread, now.

With this patch series applied (in addition to the two other patches I
sent [1]), CFQ now achieves 530.82 files / second.

I also wanted to improve the performance of the fsync-ing process in the
presence of a competing sequential reader.  The workload I used for that
was a fio job that did sequential buffered 4k reads while running the fs_mark
process.  The run-time was 30 seconds, except where otherwise noted.

Deadline got 450 files/second while achieving a throughput of 78.2 MB/s for
the sequential reader.  CFQ, unpatched, did not finish an fs_mark run
in 30 seconds.  I had to bump the time of the test up to 5 minutes, and then
CFQ saw an fs_mark performance of 6.6 files/second and sequential reader
throughput of 137.2MB/s.

The fs_mark process was being starved as the WRITE_SYNC I/O is marked
with RQ_NOIDLE, and regular WRITES are part of the async workload by
default.  So, a single request would be served from either the fs_mark
process or the journal thread, and then they would give up the I/O
scheduler.

After applying this patch set, CFQ can now perform 113.2 files/second while
achieving a throughput of 78.6 MB/s for the sequential reader.  In table
form, the results (all averages of 5 runs) look like this:

                 just    just
                fs_mark  fio        mixed	
-------------------------------+--------------
deadline        529.44   151.4 | 450.0    78.2
vanilla cfq     107.88   164.4 |   6.6   137.2
patched cfq     530.82   158.7 | 113.2    78.6

While this is a huge jump for CFQ, it is still nowhere near competing with
deadline.  I'm not sure what else I can do in this approach to address
that problem.  I/O from the two streams really needs to be interleaved in
order to keep the storage busy.

Comments, as always, are appreciated.  I think I may have explored this
alternative as far as is desirable, so if this is not a preferred method
of dealing with the problem, I'm all ears for new approaches.

Thanks!
Jeff

---

Changes from the last posting:
- Yielding no longer expires the current queue.  Instead, it sets up new
  requests from the target process so that they are issued in the yielding
  process' cfqq.  This means that we don't need to worry about losing group
  or workload share.
- Journal commits are now synchronous I/Os, which was required to get any
  sort of performance out of the fs_mark process in the presence of a
  competing reader.
- WRITE_SYNC I/O no longer sets RQ_NOIDLE, for a similar reason.
- I did test OCFS2, and it does experience performance improvements, though
  I forgot to record those.

Previous postings can be found here:
  http://lkml.org/lkml/2010/4/1/344
  http://lkml.org/lkml/2010/4/7/325
  http://lkml.org/lkml/2010/4/14/394
  http://lkml.org/lkml/2010/5/18/365
  http://lkml.org/lkml/2010/6/22/338

[1] http://lkml.org/lkml/2010/6/21/307

[PATCH 1/6] block: Implement a blk_yield function to voluntarily give up the I/O scheduler.
[PATCH 2/6] jbd: yield the device queue when waiting for commits
[PATCH 3/6] jbd2: yield the device queue when waiting for journal commits
[PATCH 4/6] jbd: use WRITE_SYNC for journal I/O
[PATCH 5/6] jbd2: use WRITE_SYNC for journal I/O
[PATCH 6/6] block: remove RQ_NOIDLE from WRITE_SYNC
