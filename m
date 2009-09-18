From: Theodore Tso <tytso@mit.edu>
Subject: Re: howto downgrade ext4 to ext3
Date: Fri, 18 Sep 2009 18:58:34 -0400
Message-ID: <20090918225834.GC28781@mit.edu>
References: <4AB39EC5.6070107@it-sudparis.eu> <20090918175851.GH26991@mit.edu> <4AB3D060.2020101@redhat.com> <20090918193456.GA27303@mit.edu> <4AB3F9C4.1010702@it-sudparis.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: jehan procaccia <jehan.procaccia@it-sudparis.eu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43580 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbZIRW6x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 18:58:53 -0400
Content-Disposition: inline
In-Reply-To: <4AB3F9C4.1010702@it-sudparis.eu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 18, 2009 at 11:21:08PM +0200, jehan procaccia wrote:
> I would love to test that option (-o nodelalloc) instead of move back to  
> ext3.
> however I don't understand what it is ... Am I taking risk in term of  
> integrity of data if I set it ?, or just losing performances ?
> anyway, I'am not sure it is available, when I search it in "man mount",  
> I can't find it, is it an undocumennted option ?

The mount man page is part of the util-linux package, and so it tends
to get updated a bit slower than the kernel.  The ext4 mount options
are fully documented in the kernel documentation; so if you install
the kernel-doc RPM, and look in the Documentation/filesystems/ext4.txt
you'll get a comprehensive list of ext4 mount options.  (Well, as
comprehensive as we can make it; occasionally we forget to update it,
but in general we've been pretty good at documenting everything.)

(Checking....)

Ugh, the description for nodelalloc in ext4.txt is pretty horrible;
it doesn't even parse as a valid English sentence.  I don't know how
that slipped by me (Mingming, Eric; can either of you see if your
respective companies can snag us a tech writer resource for a day or
two?), but I'll get that one fixed up.

Anyway, delayed allocation is a feature of ext4 which allow us to
delay allocating blocks until the very last minute --- when the VM
page writeback routine decides it times to write dirty pages to disk
(aka "cleaning pages", or "when the page cleaner runs" --- yeah, OS
programmers sometimes like to perpetuate some really horrible puns),
or when a program explicitly forces a file to be written to disk via
the fsync() system call.  This allows the block allocator to make more
intelligent decisions, which tends to avoid disk fragmentation and
tends to increase performance.  Delayed allocation is one of the
reasons why simply mounting an uncoverted ext2 or ext3 filesystem
using the ext4 file system driver can result in better performance.

The problem is that in older kernel programs, we didn't properly
account for quota.  Since we don't attempt to allocate files until
when the page cleaner runs, which could potentially be well after the
program which wrote the program has exited, the out-of-quota error
only gets noticed when the delayed allocation writepages function is
trying to clean up dirty pages.  This is a "should never happen
situation", and to avoid causing the VM to loop forever to write pages
where the write operation would never succeed, the writepages program
prints an extremely scary message and --- and then throws away the
user's data.

By using the nodelalloc mount option, ext4 will try to allocate blocks
while processing each and every write(2) system call.  This allows
quota to be checked right away, and if the user is over quota, the
write system call will return an error right away.  This is less
efficient in terms of CPU usage, and the block allocater will not be
able to do as good of a job, since it doesn't know how big the file
will ultimately be when it is doing block-by-block allocation.
However, it avoids the nasty bug that happens when the user has a
over-quota situation in the delalloc writepage function --- and it's
no worse than what ext3 does.

In more modern kernels, we've added quota checking in the write(2)
system call such that if we're not allocating the blocks right away,
so we don't know where the block will be located on disk, we charge
the block against user's quota right away, so the write(2) system call
can signal the over quota situation to the user program.
Unfortunately, these patches aren't present in the version of ext4
that was backported to RHEL 5.4.

> but now, how can I check that there's no more pb on that specific  
> partition( /disk00)?
> when kernel complains this way for example:
> Sep 16 18:06:45 gizeh kernel: mpage_da_map_blocks block allocation  
> failed for inode 39419 at logical offset 0 with max blocks 2 with error  
> -122
> Sep 16 18:06:45 gizeh kernel: This should not happen.!! Data will be lost
> I've no indication from which partition that inode is. there's so many  
> error message like this that is won't be easy to tell that none  comes  
> from /disk00 .

Well, error code 122 is EDQUOT, or "Quota exceeded".  So it's very
likely that this some other partition.  This is a bug; we really
should print the disk that was involved, and not just inode number.
I'll fix that in future kernels (but of course that won't help you for
RHEL 5.4).  What you can do to prove this is to check a quota report,
and see which users are over quota.  You can then check all of your
ext4 partitions to see which has an inode 39419 which is owned by one
of your over-quota users, using debugfs:

   debugfs -c -R "stat <39419>" /dev/sdXXX

Hope this helps you understand what's going on.

							- Ted
