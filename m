From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v5 0/5] add support for a lazytime mount option
Date: Fri, 28 Nov 2014 10:07:08 -0500
Message-ID: <20141128150708.GJ14091@thunk.org>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
 <CA+icZUUaXTVKczXHaxJbVgRpd9FaN+csraOsgaqoV72Dc=+OLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57023 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaK1PHM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Nov 2014 10:07:12 -0500
Content-Disposition: inline
In-Reply-To: <CA+icZUUaXTVKczXHaxJbVgRpd9FaN+csraOsgaqoV72Dc=+OLw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 28, 2014 at 09:55:19AM +0100, Sedat Dilek wrote:
> Some questions... on how to test this...
> 
> [ Base ]
> Is this patchset on top of ext4-next (ext4.git#dev)? Might someone
> test on top of Linux v3.18-rc6 with pulled in ext4.git#dev2?

Yes and yes.  I've been doing xfstest runs using the dev2 branch, and
my laptop has been running mainline with the ext4.git#dev plus
lazytime patches (i.e., ext4.git#dev2) pulled in.

> [ Userland ]
> Do I need an updated userland (/sbin/mount)? IOW, adding "lazytime" to
> my ext4-line(s) in /etc/fstab is enough?

There is some temporary infrastructure for ext4 so that adding
"lazytime" to the ext4 line should be enough.

> [ Benchmarks ]
> Do you have numbers - how big/fast is the benefit? On a desktop machine?

For a typical desktop machine workload, I doubt you will notice a
difference.  The tracepoints allow you to see how much work can get
delayed.  What I've been doing on my laptop:

	for i in / /u1 /build ; do mount -o remount,lazytime $i; done
	cd /sys/kernel/debug/tracing
	echo fs:fs_lazytime_defer > set_event
	echo fs:fs_lazytime_iput > set_event
	echo fs:fs_lazytime_flush > set_event
	echo ext4:ext4_other_inode_update_time >> set_event
	cat trace_pipe

The place where this will show a big benefit is where you are doing
non-allocating writes to a file --- for example, if you have a large
database (or possibly a VM image file) where you are sending random
writes to the file.  Without this patch, every five seconds the
inode's mtime field will get updated on every write (if you are using
256 byte inodes, and thus have fine-grained timestamps) or once a
second (if you are using 128 byte inodes).  These inode timestamp
updates will be sent to disk once every five seconds, either via
ext4's journaling mechanisms, or if you are running in no-journal
mode, via the dirty inode writeback.

How does this manifest in numbers?  Well, if you have journalling
enabled, the metadata updates are journalled, so if you are running a
sufficiently aggressive workload on a large SMP system, you can see
the journal lock contention.  If you were to set up a benchmarking
configuration with a ramdisk on a 16+ core machine, and used a fio job
writing to a large file on said ramdisk from all the cores in
parallel, I'm sure you would see the effects.

For people who care about long tail latency, interference effects from
journal commits (especially if you have other file system traffic
happening at the same time), or from the journal checkpoint would also
be measurable.  Dmitry has measured this and had been looking at this
as a performance bug using some kind of an AIO workload, but I don't
have more details about this.

If you aren't using the journal, and you care about long tail latency
very much, it turns out that HDD's do have an effect similar to the
SSD write disturb effect, where random writes to the same block will
eventually cause the HDD to need to rewrite a number of tracks around
a particular area of disk which is constantly getting hammered.  This
is around 100ms, and is very easily measurable if you have a set up
that is looking for long-tail latency effects and are trying to
control them.   (This is what originally inspired this patch set.)

>From my usage on my desktop, looking at the tracepoint data, you will
also see fs_lazytime_defer traces from relatime updates (where the
atime is older than a day, or when atime <= mtime), and from compile
runs where the linker writes the ELF header after writing every thing
else --- it turns out the libbfd linker has a terrible random write
pattern, good for stress testing NFS servers and delayed allocation
algorithms.  :-)

In the latter case, upon closer inspection the mtime in memory is a
millisecond or so newer than the time on disk (since if you do an
allocating write which changes i_size or i_blocks, the contents of the
inode will be sent to disk, including the mtime at the time).
However, whether you look at the on-disk or in-memory mtime for said
generated foo.o file, either will be newer than the source foo.c file,
so even if we crash without the slightly stale mtime not getting saved
to disk, it shouldn't cause any problem in actual practice.  (The
safety question has come up in some internal discussions, so I've
looked at this question fairly carefully.)

[ I can imagine an ext4 optimization where as part of the commit
  process, we check all of the inode tables about to be commited, and
  capture the updated inode times from any lazily updated timestamps,
  which would avoid this issue.  This would be an even more aggressive
  optimization than what is currently in the patch set which does this
  whenever an adjacent inode in the same inode table block is updated.
  I'm not sure trying to do the commit-time optimization is worth it,
  however. ]

Anyway, the deferred relatime updates are thus the main real benefit
you would see on a desktop workload (since the mtime updates from the
final linker write would typically end up in the same commit, so it
really doesn't avoid a HDD write op).  And while these random writes
from the relatime updates aren't _nice_ for a SSD in terms of
performance or write endurance, for most desktop workloads the effect
isn't going to be great enough to be measurable.  Things might be
different on a drive-managed SMR disk, or on eMMC flash or SD cards
with a really crappy flash translation layer, but I haven't had a
chance to look at the effect on those types of storage media to date.

Cheers,

							- Ted
