From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 19:00:10 +0200
Message-ID: <87prpf9j6t.fsf@frosties.localdomain>
References: <87bq10w8gv.fsf@frosties.localdomain>
	<20080714234616.GD3382@mit.edu> <87y743vh3q.fsf@frosties.localdomain>
	<20080715123632.GA16704@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:44356 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbYGORAM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 13:00:12 -0400
In-Reply-To: <20080715123632.GA16704@mit.edu> (Theodore Tso's message of "Tue,
	15 Jul 2008 08:36:32 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso <tytso@mit.edu> writes:

> On Tue, Jul 15, 2008 at 07:42:01AM +0200, Goswin von Brederlow wrote:
>> Is that a problem for the kernel or for the user space? I notices that
>> mke2fs 1.39 used over a gigabyte memory to format a >16TiB disk. While
>> being a lot that is not really a problem here.
>
> Userspace.  The kernel demand-loads bitmap blocks as needed, but
> e2fsprogs keeps bitarrays in user memory.  The problem is e2fsck; it
> needs in the worst case something like 5 different blocks bitmaps and
> 3 or 4 inode bitmaps.  (I don't remember the exact numbers, but it's
> that order of magnitude.)  So if it's something like a gigabyte of
> memory for mke2fs, it might be 6-7 gigs of memory for e2fsck.  If this
> is before swap has been enabled, it might not work at all, and even
> with swap, we're talking serious slowdown if e2fsck is constantly
> paging to disk.

That problem I know. That is why I always make / small and then swap
can be enabled.

Normaly I would suggest just mmaping the blocks from the disk. But
with a 32bit cpu and 6-7 gigs that won't work. But that is not a use
case for me anyway. Nobody buys 32bit systems here and especially not
with that much storage. 4-8 cores and 8-32Gig ram are quite normal and
they won't have a problem. So fixing the in memory maps to demand
loading or compressed wouldn't be a priority for me.

>> Will there be filesystem changes as well? The above mentioned
>> run-length encoding sounds a bit like a new bitmap format or is that
>> only supposed to be the in memory format in userspace?
>
> No, it will only be a memory format in userspace.  And I anticipate
> multiple backend storage formats for the bitmaps, depending on what
> they will be used for.  For example, e2fsck uses one inode bitmap to
> detect directory loops when following the parent '..' entry; this is a
> super-sparse array, with at most N bits set in the entire array, where
> N is the deepest directory in the filesystem.  Simply storing a sorted
> list of bits that are "on" is the most efficient representation for
> that particular bitmap.  Other bitmaps will be much better off stored
> in memory using perhaps an extent of "on" bits in a red-black tree,
> etc.  At least initially I will implement the "dumb and stupid" fixed
> bitarray, but I need to make sure the we have the right dispatching to
> support the rest.

Makes sense.

>> what is the plan of how to add 64-bit support to the shared lib now?
>> Will you introduce a do_foo64() function in parallel to do_foo() to
>> maintain abi compatibility? Will you add versioned symbols? Or will
>> there be an abi break at some point?
>
> There's a pretty good description of my plans here:
>
> 	http://thread.gmane.org/gmane.comp.file-systems.ext4/2845
>
> So no versioned symbols, new functions where we go from
> ext2fs_block_iterator2() to ext2fs_block_iterate3(), etc.  All new
> interfaces that I have been adding have all been 64-bit clean to begin
> with.  So for example all of the extents code use blk64_t.  The
> io_manager has been switched over to support 64-bit block numbers,
> etc.

The get_size() function (actual name is a bit longer) does use a blk_t
* to store the disks size and returns EFBIG if the disk exceeds 2^32
blocks. So now you have three choices:

1) break abi:  get_size(blk64_t *size)
2) extend abi: get_size64(blk64_t *size);
3) versioned symbols: get_size_old(blk_t *size) + get_size_new(blk64_t
*size) and versioned to use the right one.

That function is pretty much the only thing I looked at so far because
that is where mkfs.ext4 stops with >16TiB.

>> The reason I ask all this is because I'm willing to spend some time
>> patching and testing. A single >16TiB filesystem instead of multiple
>> smaller ones would be a great benefit for us.
>
> Jose Santos has been working on some patches, and I've been working on
> the 64-bit bitmap support (when I have time, which means it's been
> sporadic).  My primary priority for ext4 has been on getting last
> major bits of the patches into mainline and getting e2fsprogs 1.41 out
> the door so that basic testing, bug fixing, and stablization could
> begin.  We still have some bugs that need to squash, such as the
> summary statistics and/or checksums in the block group descriptors
> getting corrupted.  Nothing so far that can't be fixed with e2fsck,
> but getting ext4 stable is just *much* higher priority for me right
> now.
>
> That being said, if you want to join the ext4 development efforts,
> please subscribe to the linux-ext4@vger.kernel.org mailing list
> (standard majordomo subscription interface, like all of the kernel.org
> lists).  The wiki at http://ext4.wiki.kernel.org has some good stuff,
> but there's also stuff which is out of date there.  But stuff like the
> ext4 irc channel is there, and the "getting started page" is
> reasonably up to date.

Already done.

MfG
        Goswin
