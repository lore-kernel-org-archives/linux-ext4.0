From: Tao Ma <tao.ma@oracle.com>
Subject: Re: [PATCH 0/6 v6][RFC] jbd[2]: enhance fsync performance when using
 CFQ
Date: Tue, 06 Jul 2010 14:27:49 +0800
Message-ID: <4C32CCE5.2090907@oracle.com>
References: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, vgoyal@redhat.com,
	"ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:22377 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0GFG3e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jul 2010 02:29:34 -0400
In-Reply-To: <1278100699-24132-1-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jeff,

On 07/03/2010 03:58 AM, Jeff Moyer wrote:
> Hi,
>
> Running iozone or fs_mark with fsync enabled, the performance of CFQ is
> far worse than that of deadline for enterprise class storage when dealing
> with file sizes of 8MB or less.  I used the following command line as a
> representative test case:
>
>    fs_mark -S 1 -D 10000 -N 100000 -d /mnt/test/fs_mark -s 65536 -t 1 -w 4096 -F
>
I ran the script with "35-rc4 + this patch version" for an ocfs2 volume, 
and get no hang now. Thanks for the work. I also have some number for 
you. See below.
>
> Because the iozone process is issuing synchronous writes, it is put
> onto CFQ's SYNC service tree.  The significance of this is that CFQ
> will idle for up to 8ms waiting for requests on such queues.  So,
> what happens is that the iozone process will issue, say, 64KB worth
> of write I/O.  That I/O will just land in the page cache.  Then, the
> iozone process does an fsync which forces those I/Os to disk as
> synchronous writes.  Then, the file system's fsync method is invoked,
> and for ext3/4, it calls log_start_commit followed by log_wait_commit.
> Because those synchronous writes were forced out in the context of the
> iozone process, CFQ will now idle on iozone's cfqq waiting for more I/O.
> However, iozone's progress is gated by the journal thread, now.
>
> With this patch series applied (in addition to the two other patches I
> sent [1]), CFQ now achieves 530.82 files / second.
>
> I also wanted to improve the performance of the fsync-ing process in the
> presence of a competing sequential reader.  The workload I used for that
> was a fio job that did sequential buffered 4k reads while running the fs_mark
> process.  The run-time was 30 seconds, except where otherwise noted.
>
> Deadline got 450 files/second while achieving a throughput of 78.2 MB/s for
> the sequential reader.  CFQ, unpatched, did not finish an fs_mark run
> in 30 seconds.  I had to bump the time of the test up to 5 minutes, and then
> CFQ saw an fs_mark performance of 6.6 files/second and sequential reader
> throughput of 137.2MB/s.
>
> The fs_mark process was being starved as the WRITE_SYNC I/O is marked
> with RQ_NOIDLE, and regular WRITES are part of the async workload by
> default.  So, a single request would be served from either the fs_mark
> process or the journal thread, and then they would give up the I/O
> scheduler.
>
> After applying this patch set, CFQ can now perform 113.2 files/second while
> achieving a throughput of 78.6 MB/s for the sequential reader.  In table
> form, the results (all averages of 5 runs) look like this:
>
>                   just    just
>                  fs_mark  fio        mixed	
> -------------------------------+--------------
> deadline        529.44   151.4 | 450.0    78.2
> vanilla cfq     107.88   164.4 |   6.6   137.2
> patched cfq     530.82   158.7 | 113.2    78.6
Just some updates from the test of ocfs2.
                   fs_mark
  ------------------------
  deadline        386.3
  vanilla cfq     59.7
  patched cfq     366.2

So there is really a fantastic improvement at least from what fs_mark 
gives us. Great thanks.

Regards,
Tao
