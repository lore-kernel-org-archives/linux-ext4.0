From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 filesystem bad extent error review
Date: Fri, 3 Jan 2014 12:51:11 -0500
Message-ID: <20140103175111.GA4336@thunk.org>
References: <AE39A478622CF340ABEC2418D74074F61FC567864C@SGPMBX05.APAC.bosch.com>
 <20140102184211.GC10870@thunk.org>
 <AE39A478622CF340ABEC2418D74074F61FC59AC406@SGPMBX05.APAC.bosch.com>
 <20140103154846.GB31411@thunk.org>
 <52C6F22A.4040202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Huang Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Juergens Dirk (CM-AI/ECO2)" <Dirk.Juergens@de.bosch.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45674 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaACRvT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jan 2014 12:51:19 -0500
Content-Disposition: inline
In-Reply-To: <52C6F22A.4040202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 03, 2014 at 11:23:54AM -0600, Eric Sandeen wrote:
> > The BLKFLSBUF ioctl does __not__ send a CACHE FLUSH command to the
> > hardware device.  It forces all of the dirty buffers in memory to the
> > storage device, and then it invalidates all the buffer cache, but it
> > does not send a CACHE FLUSH command to the hardware.  Hence, the
> > hardware is free to write it to its on-disk cache, and not necessarily
> > guarantee that the data is written to stable store.  (For an example
> > use case of BLKFLSBUF, we use it in e2fsck to drop the buffer cache
> > for benchmarking purposes.)
> 
> Are you sure?  for a bdev w/ ext4 on it:
> 
> BLKFLSBUF
> 	fsync_bdev
> 		sync_filesystem
> 			sync_fs
> 				ext4_sync_fs
> 					blkdev_issue_flush

This call chain only happens if the block device is mounted.

If you only have the block device opened, and doing read and writes
directly to the block device, then BLKFLSBUF will not result in
blkdev_issue_flush() being called.

Actually, BLKFLSBUF is really a bit of a mess, and it's because it
conflates multiple meanins of the word "flush" (which is ambiguous).
For ram disks, it actually destroys the ram disk (due to a
implementation detail about how the original ramdisk driver was
implemented).  The original meaning of the ioctl was to safely remove
all of the buffers from the buffer cache --- for example, to deal with
a 5.25" floppy disk being replaced, since there's no way for the
hardware to signal this to the OS, or for benchmarking purposes.

Adding things like the call to sync_fs() has made the BLKFLSBUF ioctl
more and more confused, and arguably we should add some new ioctl's
which separate out some of these use cases.  For example, there is
currently no way to force all dirty buffers for an unmounted block
devicein the buffer cache to be written to disk, without actually
dropping all of the clean buffers from the buffer cache (as would be
the case with BLKFLSBUF), and without causing a forced CACHE_FLUSH
command (as would be the case if you called fsync).

The main reason why we haven't is that it's rare that people would
want to do these things in isolation, but the real problem is that
exactly what the semantics are for BLKFLSBUF are a bit confused, and
hence confusing.  It's not even well documented --- I had to go diving
into the kernel sources to be sure, and even then, as you've pointed
out, what happens is variable depending on whether the block device is
mounted or not.

					- Ted
