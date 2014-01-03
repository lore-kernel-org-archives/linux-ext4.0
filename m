From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 filesystem bad extent error review
Date: Fri, 3 Jan 2014 10:48:46 -0500
Message-ID: <20140103154846.GB31411@thunk.org>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
 <20140102184211.GC10870@thunk.org>
 <AE39A478622CF340ABEC2418D74074F61FC59AC406@SGPMBX05.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>
To: "Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45649 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaACPsv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 10:48:51 -0500
Content-Disposition: inline
In-Reply-To: <AE39A478622CF340ABEC2418D74074F61FC59AC406@SGPMBX05.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 03, 2014 at 11:16:02AM +0800, Huang Weller (CM/ESW12-CN) wrote:
> 
> It sounds like the barrier test. We wrote such kind test tool
> before, the test program used ioctl(fd, BLKFLSBUF, 0) to set a
> barrier before next write operation.  Do you think this ioctl is
> enough ? Because I saw the ext4 use it. I will do the test with that
> tool and then let you know the result.

The BLKFLSBUF ioctl does __not__ send a CACHE FLUSH command to the
hardware device.  It forces all of the dirty buffers in memory to the
storage device, and then it invalidates all the buffer cache, but it
does not send a CACHE FLUSH command to the hardware.  Hence, the
hardware is free to write it to its on-disk cache, and not necessarily
guarantee that the data is written to stable store.  (For an example
use case of BLKFLSBUF, we use it in e2fsck to drop the buffer cache
for benchmarking purposes.)

If you want to force a CACHE FLUSH (or barrier, depending on the
underlying transport different names may be given to this operation),
you need to call fsync() on the file descriptor open to the block
device.

> More information about journal block which caused the bad extents
> error: We enabled the mount option journal_checksum in our test.  We
> reproduced the same problem and the journal checksum is correct
> because the journal block will not be replayed if checksum is error.

How did you enable the journal_checksum option?  Note that this is not
safe in general, which is why we don't enable it or the async_commit
mount option by default.  The problem is that currently the journal
replay stops when it hits a bad checksum, and this can leave the file
system in a worse case than it currently is in.  There is a way we
could fix it, by adding per-block checksums to the journal, so we can
skip just the bad block, and then force an efsck afterwards, but that
isn't something we've implemented yet.

That being said, if the journal checksum was valid, and so the
corrupted block was replayed, it does seem to argue against
hardware-induced corruption.

Hmm....  I'm stumped, for the moment.  The journal layer is quite
stable, and we haven't had any problems like this reported in many,
many years.

Let's take this back to first principles.  How reliably can you
reproduce the problem?  How often does it fail?  Is it something where
you can characterize the workload leading to this failure?  Secondly,
is a power drop involved in the reproduction at all, or is this
something that can be reproduced by running some kind of workload, and
then doing a soft reset (i.e., force a kernel reboot, but _not_ do it
via a power drop)?

The other thing to ask is when did this problem first start appearing?
With a kernel upgrade?  A compiler/toolchain upgrade?  Or has it
always been there?  

Regards,

							- Ted
