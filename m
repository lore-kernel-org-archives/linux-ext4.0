From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
Date: Tue, 22 Mar 2011 16:44:03 +0100
Message-ID: <201103221644.03832.arnd@arndb.de>
References: <1299718449-15172-1-git-send-email-andreiw@motorola.com> <201103221456.32151.arnd@arndb.de> <EB125185-EDE4-4618-A94E-D1C71810D3AB@dilger.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrei Warkentin <andreiw@motorola.com>, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:65054 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab1CVPoJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2011 11:44:09 -0400
In-Reply-To: <EB125185-EDE4-4618-A94E-D1C71810D3AB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 22 March 2011, Andreas Dilger wrote:
> On 2011-03-22, at 2:56 PM, Arnd Bergmann wrote:
> > On Tuesday 22 March 2011, Andreas Dilger wrote:
> >> On 2011-03-21, at 8:05 PM, Arnd Bergmann wrote:
> > 
> > * On cards that can only write to a single erase block at a time,
> > should I make the block group size the same as the as the erase
> > block? I suppose writing both block bitmaps, inode and data to
> > separate erase blocks would create multiple eraseblock
> > read-modify-write cycles for every single file otherwise.
> 
> That doesn't seem like a very good idea.  It will significantly limit
> the size of the filesystem, and will cause a lot of overhead (two bitmaps
> per group for only a handful of blocks).

I'm willing to spend a little space overhead in return for one
or two orders of magnitude in performance and life expectancy
for the card ;-)

A typical case is that a single-page (16KB) write to the currently
open erase block takes 1ms, but since writing to another erase block
requires a garbage-collection (erase-rewrite 4 MB), it takes 500 ms,
just like the following access to the first erase block, which
has now been closed.

Every erase cycle ages the drive, and on some cheap ones, you only
have about 2000 guaranteed erases per erase block!

> > * Is it guaranteed that inode bitmap, inode, block bitmap and
> > blocks are always written in low-to-high sector order within
> > one ext4 block group? A lot of the drives will do a garbage-collect
> > step (adding hundreds of miliseconds) every time you move back
> > inside of the eraseblock.
> 
> Generally, yes.  I don't think there is a hard guarantee,
> but the block device elevator will sort the blocks.

Ok. 
 
> > * Is there any way to make ext4 use effective blocks larger
> > than 4 KB? The most common size for a NAND flash page is 16
> > KB right (effectively, ignoring what the hardware does), so
> > it would be good to never write smaller.
> 
> You may be interested in Ted's bigalloc patchset.  This will force
> block allocation to be at a power-of-two multiple of the blocksize,
> so it could be 16kB or whatever.  However, this is inefficient if
> the average filesize is not large enough.

Is it just a performance/space tradeoff, or is there also a
performance overhead in this?

> > * Calling TRIM on SD cards is probably counterproductive unless
> > you trim entire erase blocks. Is that even possible with ext4,
> > assuming that we use block group == erase block?
> 
> That is already the case, if the underlying storage reports the
> erase block size to the filesystem.

Ok, I should try to find out how this is done on SD cards.
The hardware interface allows erasing 512 byte sectors, so
we might be reporting that instead.
 
> > * Is there a way to put the journal into specific parts of the
> > drive? Almost all SD cards have an area in the second 4 MB
> > (more for larger cards) that can be written using random access
> > without forcing garbage collection on other parts.
> 
> That would need a small patch to mke2fs.  I've been interested in
> this also for other reasons, but haven't had time to work on it. 
> It will likely need only some small adjustments to 
> ext2fs_add_journal_inode() to allow passing the goal block, and
> write_journal_inode() to use the goal block instead of its internal
> heuristic.  The default location of the journal inode was previously
> moved from the beginning of the filesystem to the middle of the
> filesystem for performance reasons, so this is mostly already handled.

Ok. It was previously suggested to put an external journal on a
4 MB partition for experimenting with this. I hope I can back this
up with performance numbers soon.

> Well, the large erase block size is not in itself a problem, but
> if the devices do not use the reported erase block size internally,
> there is nothing much that ext4 or the rest of the kernel can do
> about it, since it has no other way of knowing what the real erase
> block size is.

For SDHC cards, the typical case is that they are reasonably efficient
when you use the reported size, because they are tested that way.
A lot of cards use 2MiB internally but report 4MiB, which is fine
as long as you write the 4MB consecutively and don't alternate
between the two halves.

The split into three erase blocks of (4 MiB / 3) is on low-end
SanDisk cards, and I believe it has mostly advantages and will
work well if we use the reported 4 MB.

The 4128 KiB erase blocks are on a USB stick, and those devices
do not report any erase block size at all.

I have written a tool to detect the actual erase block size,
and perhaps that could be integrated into mke2fs and similar
tools.

	Arnd
