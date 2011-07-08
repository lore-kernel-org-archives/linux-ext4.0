From: Ted Ts'o <tytso@mit.edu>
Subject: bigalloc performance stats (was Re: [PATCH 00/23] New spin of the
 bigalloc patches)
Date: Fri, 8 Jul 2011 19:02:00 -0400
Message-ID: <20110708230200.GJ3331@thunk.org>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44398 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab1GHXCD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jul 2011 19:02:03 -0400
Content-Disposition: inline
In-Reply-To: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have some initial benchmark figures that may help provide some
insight into why I am especially interested in getting bigalloc into
ext4.

The following statistics were collected on a Google file server.  As
Michael Rubin mentioned in his talks at the LinuxCon this year, and at
the Kernel Summit two years ago, one of the things that we do our
servers is to really pack in a large number of jobs onto a single
machine, for cost and power efficiency.

As a result, we generally don't have machines which are *only* a file
server; that would leave wasted memory and CPU on the table.  I
believe the same thing will be found in people who are implementing
cloud computing using virtualization; the whole point is to do things
efficiently, which means a large number of guest OS's will be packed
onto a single physical machine, so memory and disk bandwidth will
often be at a premium.  This is the environment in which these figures
were captured.

I compared a stock ext4 file system, against ext4 file system with
bigalloc with 64k, 256k, and 1M clusters.  First, let's looked at the
average time needed to execute the fallocate system call and the inode
truncation portion of the ftruncate and unlink system calls (this data
was gathered using tracepoints, so the overhead of syscall entry and
exit are not included in these numbers):

                  ext4                64k            256k            1M
            time meta  max   time   meta max  time   meta  max  time meta   max
fallocate 14,262 1.1494 11 |  895  0.0417 2 |  318  0.0084  2 |  122 0.00077  1
truncate  12,944 0.8256 27 | 6911  0.4877 3 | 4541  0.2822  3 | 4558 0.2744   3

The time column is in microseconds (i.e., in this server, using stock
ext4, fallocate was taking 14.2 milliseconds on average); the "meta"
column indicates the average number of metadata reads were necessary
to complete the operation, and the "max" column indicates the maximum
number of metadata reads needed to complete the operation.

Note the improvement in the average time to execute the fallocate()
system call went down by over two orders of magnitude comparing ext4
against bigalloc with a 1M cluster size, using the same workload (from
14.2 ms to 122 usec).  And even the 64k and 256k cluster sizes did
quite well (factors of 16 and 45, respectively) compared to stock
ext4.

Also of interest was the percentage of direct I/O reads and writes
that took over 100ms:

                      ext4    64k     256k     1M
DIO reads > 100ms:   0.498%  0.228%  0.257%  0.269%
DIO writes > 100ms:  0.202%  0.134%  0.109%  0.0582%

Since we don't need to read or write the block allocation bitmaps when
we do our DIO (since we fallocate the files in advance), this
improvement must be largely due to improved fragmentation of the files
(we let the workload run for a couple of days on a set of disks so we
could get something closer "steady state" as opposed "freshly
formatted" results).  The reason why the DIO reads improve so much
more is because of the need to read in the extent tree blocks, which
would tend to be in memory already most of the time since the inode
would have been freshly fallocated while the DIO write was going on.

These are only initial results, but they were gathered on a production
workload --- but I hope this demonstrates why I consider bigalloc to
be especially interesting in environments where server resources
(especially memory) are constrained due to desire to use those
resources as efficiently as possible.

					- Ted
