From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC 0/2] ext4: zero uninitialized inode tables
Date: Tue, 25 Nov 2008 00:32:27 -0500
Message-ID: <20081125053226.GE20928@mit.edu>
References: <20081121102309.182113793@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52770 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbYKYFdD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Nov 2008 00:33:03 -0500
Content-Disposition: inline
In-Reply-To: <20081121102309.182113793@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 11:23:09AM +0100, Solofo.Ramangalahy@bull.net wrote:
> . decide whether to keep it a module.
>   If not, decide how/when run the kernel thread
> . multiple threads (based on cpu/disks)

I would *not* do it as a module.  It's more than a little
aesthetically unclean that this has to be a module --- there are
people who by choice decide not to use modules, for example.  If
you're clever, doing it as a module allows you to shorten your
compile-edit-debug cycle, I suppose, so maybe it's a justification for
doing it that way, but if that's the main reason, I'd choose using
user mode linux or KVM as my main development vehicle to speed up the
development cycle....

Instead, what I would do is to have the mount system call, if the
filesystem is mounted read/write, and there are uninitialized block
groups, to create a kernel thread responsible for initializing the
filesystem in question.  Once it is complete, it can exit.

> . initialize some blocks (for example the non-empty ones) at mount
>   time, or somewhere else.
> . non-empty group case

I'm not sure why you are treating the non-empty group case any
different from the empty-group case.  The only difference is where you
start zeroing the inode table.  In both cases you do need to worry
about locking issues --- what happens if the filesystem tries to
allocate a new inode just as you are starting to zero the filesystem?

In your current patch, you are checking to see if the block group has
no inodes in ext4_thread_init_itable(), by calling has_no_inode(), but
there is no locking between when you check to see that a particular
part of the inode table is not in use, and when you call
ext4_zero_itable_blocks().  If an inode does get allocated, either
between the call to has_no_inode, and ext4_zero_itable_blocks(), or
while ext4_zero_itable_blocks() is running, the inode could get
zero'ed out, causing data loss.  So locking is critical.

My suggestion for how to do locking is is to add a field in
ext4_group_info, a data structure which was defined in mballoc.h, but
is going to be moved to ext4.h as part of a patch that is currently in
the ext4 patch queue.  This field would be protected by bg_sgl_lock()
(like the other fields in the bg descriptor), and would be called
inode_bg_unavail.  If non-zero, and the relative inode number (i.e.,
the inode number modulo the number of inodes per blockgroup) selected
by the inode allocator is greater than or equal to inode_bg_unavail,
the inode allocator should try to find another block group to allocate
the inode.

Now what the inode table initialization thread can do is for each
block group where EXT4_BG_INODE_ZERO is not set, it should first set
inode_bg_unavail to bg_itable_unused.  This will prevent the inode
allocator allocating any new inodes in that block group.  Since we are
going to zero out inode table blocks, being paranoid is a good thing;
we should check to make sure the bg_checksum is valid, and that inode
bitmap does not show any blocks past bg_unavail as being in use.  If
there are, the filesystem must have gotten corrupted and we should
call ext4_error() in that case.

We we start zero'ing the inode table, I would recommend doing so
without using the journal, and doing direct block i/o from the zero
page.  The ext4_ext_zeroout function does most of what you need,
although I'd generalize it so it doesn't take inode and and
ext4_extent structure, but rather a struct sb, starting physical block
number, and number of blocks.  This function would wait for the I/O to
complete, and once it completes you know the blocks are on disk and
you can make changes to the filesystem metadata that would be
journaled.  I would recommend doing the first 32k of the inode table
first, and once it completes, you can update inode_bg_unavaile so that
an additional (32k / EXT4_INODE_SIZE(sb)) inodes are available.  This
allows the inode allocator to allocate inodes in the block group while
the itable initializer is initializing the rest of the inode table in
that block group.  Once the entire block group's inode table has been
initialized, the itable initializer can then set the BG_ITABLE_ZERO
flag (and this would be a journaled update), and then move on to the
next block group.

Does that make sense?


In terms of how quickly the itable initializer should work, in between
each block group, as we discussed on the call, the simplest thing for
it do is to wait for some time period to go by (say, 5 seconds) before
working on the next block group.  The next, slightly more complicated
scheme would be to set a "last ext4 operation time" field in
EXT4_SB(sb) which is set any time the ext4 code paths are entered
(basically, any function in ext4's inode operations, super operations
or file operations).  The itable initalizer would sample that time,
and before starting to initialize the next block group where
BG_ITABLE_ZERO is not set, it would check the last ext4 operation time
field, and if there had been an ext4 operation in the last 5 seconds,
it would sleep 5 seconds and check again.  This would prevent the
itable initializer from running if the filesystem is in use, although
it will not detect the case where there is a lot of mmap'ed I/O going
on, but no other ext4 operations.

In the long run, we would really want some kind of I/O activity
indication from the block device elevator, but that would require
changes to the core kernel, and the last ext4 operation time is almost
just as good.

> . fix the resize inode case

Not sure what problem you were having here?

							- Ted
