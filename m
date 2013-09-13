From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Java Stop-the-World GC stall induced by FS flush or many large
 file deletions
Date: Fri, 13 Sep 2013 14:36:17 -0400
Message-ID: <20130913183617.GA15366@thunk.org>
References: <CALQm4jhE8aRjOsK2HpSuqNCzNqZm5RU9QOJi0q0SwgR=1JKZsQ@mail.gmail.com>
 <20130912190251.GB28067@thunk.org>
 <CALQm4jiEiKqKRwB8FEp2ojrVcw=-H8zh_+_guh_xmwiLx12syg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Cuong Tran <cuonghuutran@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59778 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab3IMSgT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Sep 2013 14:36:19 -0400
Content-Disposition: inline
In-Reply-To: <CALQm4jiEiKqKRwB8FEp2ojrVcw=-H8zh_+_guh_xmwiLx12syg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 13, 2013 at 08:25:30AM -0700, Cuong Tran wrote:
> I did strace and some stalls can be correlated to GC thread writing to
> the log but others are not.

Something else which just came to mind --- depending on the kernel
version which you are using, you may be getting hit by stable page
writebacks.  This is where a process tries to modify a mmap'ed page
while it is being written back to disk.  With stable page writeback,
the an attempt to modify a page which is being written back to disk
will cause a page fault, and that process will block until the page is
written back to disk.

This is a feature which is required for certain block devices such as
iSCSI, SAS drives with DIF and RAID 5, since if the page changes out
from under the writeback, the checksum (or parity strip in the case of
RAID 5) of the page will be broken.  However, it can cause random
process stalls.

Some of us (Google and Tao Bao) have hacked kernels which forcibly
disables stable page writeback, because it causes latency problems.
(Since we weren't using any of the block devices that require this
feature, it was OK.)  In the most recent kernels, there are some
changes which will automatically disable stable page writebacks for
those block devices that don't need it.

> I turned on the  jbd2_run_stats trace point, and this is sample trace
> of creating and deleting 300 100MB files in  a loop. (My desktop is
> running low on disk space!). No Java test is running. I also turned on
> jbd2_checkpoint_stats. Not sure if the count "running" in 5000s or
> frequency of jbd2_checkpoint_stats has any relevance.
> 
>            <...>-534   [003] 64044.506552: jbd2_checkpoint_stats: dev
> sda1 tid 5433920 chp_time 0 forced_to_close 0 written 0 dropped 6

The check point time is zero, so we don't have any problems here.
That's fine.

>            <...>-534   [003] 64044.506555: jbd2_run_stats: dev sda1
> tid 5433921 wait 0 running 5003 locked 0 flushing 0 logging 13
> handle_count 1587 blocks 6 blocks_logged 7

The "run time" is the time between the previous transaction and when
the current transaction starts committing.  Five seconds (all of the
times in jbd2_run_stats are in milliseconds) is the default commit
time.  This implies that the transaction was committed because of the
commit timeout, and not because either (a) an fsync() or fdatasync()
or (b) the number of changed blocks was too big, such that we forced
the commit to start.

So for this test, all of the jbd2_run_stats don't show anything
interesting.  We are spending 13-15ms writing a half-dozen or so
blocks to the journal.  The handle count is the number of individual
file system operations in the commit, but all of these handles are
touching only 6 metadata blocks.  I'm guessing this means you are
writing those 100MB files in relatively small chunks, which explains
why there are 1500+ handles started but so few metadata blocks
(primarily bitmap allocation blocks and inode table blocks) being
modified in those 5 seconds.


>            <...>-534   [000] 64707.948801: jbd2_run_stats: dev sda1
> tid 5434034 wait 0 running 5002 locked 0 flushing 0 logging 73
> handle_count 8416 blocks 1475 blocks_logged 1480

OK, this is a bit more typical; in this five second range, we modified
1475 metadata blocks across 8416 file system operations.  Note that
the commit operation only took a total of 73 milliseconds, though.
(That's because the write to the journal is a sequential write, which
tends to be fairly efficient for HDD's.)

The bottom line is that it doesn't look like the journal commits is
actually taking that long.  I certainly don't see anything to explain
GC stalls in the one second range.

Regards,

						- Ted
