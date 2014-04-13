From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Writing one file, observing two writes
Date: Sun, 13 Apr 2014 15:03:59 -0400
Message-ID: <20140413190359.GA8122@thunk.org>
References: <534AB1F3.2060700@seceng.informatik.tu-darmstadt.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Sebastian Biedermann
	<biedermann@seceng.informatik.tu-darmstadt.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53636 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbaDMTEG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 15:04:06 -0400
Content-Disposition: inline
In-Reply-To: <534AB1F3.2060700@seceng.informatik.tu-darmstadt.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 13, 2014 at 11:49:07AM -0400, Sebastian Biedermann wrote:
> Dear ext4 developers,
> 
> I'm working on a research project about side channel attacks to hard drives.
> My testbed runs Ubuntu Linux 12.04 with ext4 file system.
> 
> When writing a random file with dd command to my hard drive, I could see
> the process jbd2/sda1
> writing two times while it seems to wait a fixed period of time between
> these two writes.
> 
> I actually think that the process is first writing the data to the
> sectors and then updating the ext4 data base in a second step.
> Is that true or am I wrong? Why is it waiting some seconds between these
> two steps and on what is that delay depending?

What you're seeing is the ext4's journalling layer in action.  Ext4
uses a simple form of write-ahead logging when it modifies metadata
blocks.  For performance reasons we bundle multiple file system
operations into large transactions, where we close and commit the
transaction either (a) after an fsync() call, (b) when the free space
in the journal falls below a certain level, or (c) after 5 seconds.
If the system crashes, we replay the file system journal up to the
last valid commit block.  Metadata operations after that point are
lost.  Note that this only guarantees that the file system will be
consistent, the contents of recently written files are not guaranteed
to be preserved after a crash, *unless* the program issues an fsync(2)
system call.

The jbd2 process is responsible for updating the journal and writing
the commit block.

The above description applies to the metadata blocks.  Data blocks are
a slightly different story.  There you may be seeing the effects of
delayed allocation, where freshly written blocks are not pushed out to
disk unless (a) the program calls fsync(2) on the file descriptor, (b)
the system is under memory pressure and we need to clean pages in the
page cache before we can drop those pages to make room for other users
of the memory, or (c) after the 30 second writeback timer goes off.

Programs should of course not depend on this exact behavior; they can
be modified by adjusting various system tuning parameters, and if
"laptop mode" is enabled, writeback can be deferred for a very long
time, to try to save batter life --- with the trade off that if the
laptop suddenly loses power, data could be lost.  In general, if you
really care about data being on stable store after a crash or power
failure event, the program must use the fsync(2) system call.

Data writes typically take place from the context of either the
writeback daemon, the process executing the fsync(2) system call, or
the process which is attempting to allocate memory when the system is
under memory pressure (at which point the process which is trying to
dirty memory, and thus increase the memory pressure, may get impressed
into service to help clean pages so as to help aleviate the memory
pressure problem).

Note that since ext4 supports delayed allocation, the act of doing
writeback of data blocks to a newly created file may require blocks to
be allocated from the file system, which will result in metadata
blocks being modified and being added to a transaction, which in turn
means that five seconds layer, or possbly sooner, the jbd2 kernel
thread will get woken up to close off and commit the current jbd2
transaction.

Regards,

						- Ted






