From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: 64bit + resize2fs... this is Not Good.
Date: Wed, 14 Nov 2012 18:38:54 -0500
Message-ID: <20121114233854.GD24980@thunk.org>
References: <20121114203942.GA23511@thunk.org>
 <20121114232633.18292.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:32929 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab2KNXjD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Nov 2012 18:39:03 -0500
Content-Disposition: inline
In-Reply-To: <20121114232633.18292.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 14, 2012 at 06:26:33PM -0500, George Spelvin wrote:
> 
> > The reason why you lost so badly when you did an off-line resize was
> > because you explicitly changed the resize limit default, via the -E
> > resize=NNN option.  (Can you explain to me your thinking about why you
> > specified this, just out of curiosity?)
> 
> Because I figured there was *some* overhead, and the documented
> preallocation of 1000x initial FS size was preposterously large.

It's actually not 1000x times.  It's a 1000x times up to a maximum of
1024 current and reserved gdt blocks (which is the absolute maxmimum
which can be supported using resize_inode feature).  Contrary to what
you had expected, it's simply not possible to have 2048 or 4096
reserved gdt blocks using the resize_inode scheme.  That's because it
stores in the reserved gdt blocks using an indirect/direct scheme, and
that's all the sapce that we have.  (With a 4k block, and 4 bytes per
blocks --- the resize_inode scheme simply completely doesn't work if
above 16TB since it uses 4 byte block numbers --- 4k/4 = 1024 block group
descriptors.)

> > Normally the default is 1000 times the size of the original file system,
> > or for a file system larger than 16GB, enough so that the file system
> > can be resized to the maximum amount that can be supported via the
> > resize_inode scheme, which is 16TB.  In practice, for pretty much any
> > large file system, including pretty much any raid arrays, the default
> > allows us to do resizes without needing to move any inode table blocks.
> 
> Um, but on a 64bit file system, flex_bg *can* grow past 16 TB.

Currently, only using the online resizing patches which are in 3.7-rc1
and newer kernels --- and that's using the meta_bg scheme, *not* the
resize_inode resizing scheme.

> One source of the problem is that I asked for a 64 TiB grow limit
> *and didn't get it*.  Even if mke2fs had done its math wrong and only
> preallocated 32 * (64 TiB/128 MiB) = 16 MiB (4096 blocks) of GDT space,
> I would have been fine.

It can't preallocate that many GDT blocks.  There simply isn't room in
the indirect block scheme.  I agree it should have given an error
message in that case.  Unfortunately using the extended resize=NNN
option is not one that has gotten much attention or use, and so there
are bugs hiding there that have been around for years and years.  :-(

> Of course, fixing the resizer to handle flex_bg probably isn't that hard.
> Assuming standard layout, all the blocks of a given type are contiguous,
> and the only difference between a flex_bg group and simply a larger
> block group is the layout of the inode bitmaps.
> 
> Just treat it as a block group with (in this case) 128 pages of inodes,
> 8 pages of block bitmap, and 8 pages of inode bitmap, and bingo.

Except that with the flex_bg feature, the inode table blocks can be
anywhere.  Usually they are contiguous, but they don't have to be ---
if there are bad blocks, or depending on how the file system had been
previously resized, it's possible that the inode tables for the block
groups might not be adjacent.

Probably the best thing to do is to just find some new space for the
block group's inode table, and try not to keep it contiguous.
Ultimately, the best thing to do is to just let mke2fs use the
defaults, resize up to 16TB without needing to move any inode table
blocks, and then switch over to the meta_bg scheme, and add support
for meta_bg resizing in resize2fs.

I just simply haven't had time to work on this.  :-(

> > # lvcreate -L 32g -n bigscratch /dev/closure
> > # mke2fs -t ext4 -E resize=12582912 /dev/closure/bigscratch
> > # lvresize -L 64g /dev/closure/bigscratch
> > # e2fsck -f /dev/closure/bigscratch
> > # resize2fs -p /dev/closure/bigscratch
> > # e2fsck -fy /dev/closure/bigscratch
> 
> Yeah, I see how that would cause problems, as you ask for 51.5G of
> resize range.  What pisses me off is that I asked for 64 TiB!
> (-E resize=17179869184)

Yes, mke2fs should have issued an error message to let you know
there's no way it could honor your request.

Again, I'm really sorry; you were exploring some of the less well
tested code paths in e2fsprogs/resize2fs.  :-(

     	     	       	     	   	- Ted
