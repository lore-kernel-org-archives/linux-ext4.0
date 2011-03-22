From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
Date: Tue, 22 Mar 2011 16:02:54 +0100
Message-ID: <EB125185-EDE4-4618-A94E-D1C71810D3AB@dilger.ca>
References: <1299718449-15172-1-git-send-email-andreiw@motorola.com> <201103212005.37108.arnd@arndb.de> <7BE97618-725C-4BFA-9FE5-59C893BDA097@dilger.ca> <201103221456.32151.arnd@arndb.de>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Andrei Warkentin <andreiw@motorola.com>, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:3081 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab1CVPJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2011 11:09:10 -0400
In-Reply-To: <201103221456.32151.arnd@arndb.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-03-22, at 2:56 PM, Arnd Bergmann wrote:
> On Tuesday 22 March 2011, Andreas Dilger wrote:
>> On 2011-03-21, at 8:05 PM, Arnd Bergmann wrote:
>>> So would I set the stripe_width to the erase block size, and the
>>> block group size to a multiple of that?
>> 
>> When you write "block group size" do you mean the ext4 block group? 
> 
> Yes.
> 
>> Then yes it would help.  You could also consider setting the flex_bg
>> size to a multiple of this, so that the bitmap blocks are grouped as
>> a multiple of this size.  However, they may not be aligned correctly,
>> which needs extra effort that isn't obvious.  
>> 
>> I think it would be nice to have mke2fs take the stripe_width and/or
>> flex_bg factor into account when sizing/aligning the bitmaps, but it
>> doesn't yet.
> 
> A few more questions: 
> 
> * On cards that can only write to a single erase block at a time,
> should I make the block group size the same as the as the erase
> block? I suppose writing both block bitmaps, inode and data to
> separate erase blocks would create multiple eraseblock
> read-modify-write cycles for every single file otherwise.

That doesn't seem like a very good idea.  It will significantly limit the size of the filesystem, and will cause a lot of overhead (two bitmaps per group for only a handful of blocks).

> * Is it guaranteed that inode bitmap, inode, block bitmap and
> blocks are always written in low-to-high sector order within
> one ext4 block group? A lot of the drives will do a garbage-collect
> step (adding hundreds of miliseconds) every time you move back
> inside of the eraseblock.

Generally, yes.  I don't think there is a hard guarantee, but the block device elevator will sort the blocks.

> * Is there any way to make ext4 use effective blocks larger
> than 4 KB? The most common size for a NAND flash page is 16
> KB right (effectively, ignoring what the hardware does), so
> it would be good to never write smaller.

You may be interested in Ted's bigalloc patchset.  This will force block allocation to be at a power-of-two multiple of the blocksize, so it could be 16kB or whatever.  However, this is inefficient if the average filesize is not large enough.

> * Calling TRIM on SD cards is probably counterproductive unless
> you trim entire erase blocks. Is that even possible with ext4,
> assuming that we use block group == erase block?

That is already the case, if the underlying storage reports the erase block size to the filesystem.

> * Is there a way to put the journal into specific parts of the
> drive? Almost all SD cards have an area in the second 4 MB
> (more for larger cards) that can be written using random access
> without forcing garbage collection on other parts.

That would need a small patch to mke2fs.  I've been interested in this also for other reasons, but haven't had time to work on it.  It will likely need only some small adjustments to ext2fs_add_journal_inode() to allow passing the goal block, and write_journal_inode() to use the goal block instead of its internal heuristic.  The default location of the journal inode was previously moved from the beginning of the filesystem to the middle of the filesystem for performance reasons, so this is mostly already handled.

>>> Does this also work in (rare) cases where the erase block size is
>>> not a power of two?
>> 
>> It does (or is supposed to), but that isn't code that is exercised
>> very much (most installations use a power-of-two size).
> 
> Ok. Recently, cheap TLC (three-level cell, 3-bit MLC) NAND is
> becoming popular. I've seen erase block sizes of 6 MiB, 1376 KiB
> (4096 / 3, rounded up) and 4128 KiB (1376 * 3) because of this, in
> place of the common 4096 KiB. The SD card standard specifies
> values of 12 MB and 24 MB aside from the usual power-of-two values
> up to 64 MB for large cards (>32GB), while smaller cards are allowed
> only up to 4 MB erase blocks and need to be power-of-two. Many
> cards do not use the size they claim in their registers.

Well, the large erase block size is not in itself a problem, but if the devices do not use the reported erase block size internally, there is nothing much that ext4 or the rest of the kernel can do about it, since it has no other way of knowing what the real erase block size is.

Cheers, Andreas





