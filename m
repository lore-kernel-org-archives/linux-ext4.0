From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Sun, 20 Apr 2014 13:57:35 -0400
Message-ID: <20140420175735.GA29727@thunk.org>
References: <20140409223820.GU10985@gradx.cs.jhu.edu>
 <CAGagf4eEzY4+3cfNWSEENTo1PKe40nq1Ne6ZzOLGm-O78W7RcA@mail.gmail.com>
 <20140410050428.GV10985@gradx.cs.jhu.edu>
 <20140410140316.GD15925@thunk.org>
 <20140410163350.GW10985@gradx.cs.jhu.edu>
 <20140410221702.GD31614@thunk.org>
 <20140420163211.GT10985@gradx.cs.jhu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Rubin <mrubin@google.com>, Frank Mayhar <fmayhar@google.com>,
	admins@acm.jhu.edu, linux-ext4@vger.kernel.org
To: Nathaniel W Filardo <nwf@cs.jhu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50732 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbaDTR5k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Apr 2014 13:57:40 -0400
Content-Disposition: inline
In-Reply-To: <20140420163211.GT10985@gradx.cs.jhu.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 20, 2014 at 12:32:12PM -0400, Nathaniel W Filardo wrote:
> We just got
> 
> > [817576.492013] EXT4-fs (vdd): pa ffff88000dea9b90: logic 0, phys.  1934464544, len 32
> > [817576.492468] EXT4-fs error (device vdd): ext4_mb_release_inode_pa:3729: group 59035, free 14, pa_free 12

OK, so what this means ext4 had preallocated a 32 blocks (starting at
block #0) for a file that was being written.  When we were done
writing the file, and the file is closed (or truncated, or a number of
other cases), ext4 will release the unwritten blocks back to the file
system so they can be used for some other file.

According to the preallocation accounting data, there should have been
12 leftover blocks to be released to be the file system.  However,
when the function looked at the on-disk bitmap, it found 14 leftover
blocks.  The only way this could happen is (a) memory hardware error,
(b) storage device error, or (c) programming error.

> > [817576.492987] Aborting journal on device vdd-8.
> > [817576.493919] EXT4-fs (vdd): Remounting filesystem read-only

So this at this point we abort the journal and remount the file system
read-only in order avoid potential further corruption.

> Upon unmount, further
> 
> > [825457.072206] EXT4-fs error (device vdd): ext4_put_super:791: Couldn't clean up the journal

That's an error message which should be expected, because the journal
was aborted due to the fs error.  So that's not a big deal.

(Yes, some of the error messages could be improved to be less
confusing; sorry about that.  Something we should fix....)

> fscking generated
> 
> > fsck from util-linux 2.20.1
> > e2fsck 1.42.9 (4-Feb-2014)
> > /dev/vdd: recovering journal
> > /dev/vdd contains a file system with errors, check forced.
> > Pass 1: Checking inodes, blocks, and sizes
> > Pass 2: Checking directory structure
> > Pass 3: Checking directory connectivity
> > Pass 4: Checking reference counts
> > Pass 5: Checking group summary information
> > Block bitmap differences:  +(1934464544--1934464545)
> > Fix<y>? yes

These two blocks were actually in use (i.e., referenced by some inode)
but not marked as in use by the bitmap.  That matches up with the
ext4_error message described above.  Somehow, either the storage
device flipped the bits associated with blocks 1934464544 and
1934464545 on disk, or the request to set those bits never got set.

So fortunately, the file system was marked read-only, because
otherwise these two blocks could have gotten allocated and assigend to
some other file, and that would have meant two different files trying
to use the same blocks, which of course means at least one of the
files will have data loss.

> > Free blocks count wrong (1379876836, counted=1386563079).
> > Fix<y>? yes
> > Free inodes count wrong (331897442, counted=331912336).
> > Fix<y>? yes

These two messages are harmless; you don't need to worry about them.
We no longer update the total number of free blocks and free inodes
except when the file system is cleanly unmounted.  Otherwise, every
single CPU that tried to allocate or release blocks or inode would end
up taking a global lock on these fields, which would be a massive
scalability bottleneck.  Instead, we just maintain per-block group
counts for the free blocks and free inodes, and we generate the total
number of free blocks and inode on demand when the user executes the
statfs(2) system call (for commands like df), or when the file system
is unmounted cleanly.

Since the file system was forcibly remounted read-only due to the
problem that we had found, the summary free block/inode counts never
got updated.

> /dev/vdd is virtio on Ceph RBD, using write-through caching.  We have had a
> crash on one of the Ceph OSDs recently in a way that seems to have generated
> inconsistent data in Ceph, but subsequent repair commands seem to have made
> everything happy again, at least so far as Ceph tells us.
> 
> The guest `uname -a` sayeth
> 
> > Linux afsscratch-kvm 3.13-1-amd64 #1 SMP Debian 3.13.7-1 (2014-03-25) x86_64 GNU/Linux
> 
> And in case it's relevant, host QEMU emulator is version 1.7.0 (Debian
> 1.7.0+dfsg-3) [modified locally to include rbd]; guest ceph, librbd, etc.
> are Debian package 0.72.2-1~bpo70+1 .

No one else has reported any bugs like this, nor has anything like
this turned up in our stress tests.  It's possible that your workload
is doing something strange that no one else would experience, and
which isn't getting picked up by our stress tests, but it's also just
as likely (and possibly more so) that the problem is caused by some
portion of the storage stack below ext4 --- i.e., virtio, qemu, the
remote block device, etc.  And so that's why if you can find ways to
substitute out the rbd with a local disk, that would be a really good
first step in trying to bisect what portion of the system might be
causing the fs corruption.

Regards,

						- Ted
