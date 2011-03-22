From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 4/5] MMC: Adjust unaligned write accesses.
Date: Tue, 22 Mar 2011 14:56:31 +0100
Message-ID: <201103221456.32151.arnd@arndb.de>
References: <1299718449-15172-1-git-send-email-andreiw@motorola.com> <201103212005.37108.arnd@arndb.de> <7BE97618-725C-4BFA-9FE5-59C893BDA097@dilger.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrei Warkentin <andreiw@motorola.com>, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1CVN4j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Mar 2011 09:56:39 -0400
In-Reply-To: <7BE97618-725C-4BFA-9FE5-59C893BDA097@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday 22 March 2011, Andreas Dilger wrote:
> On 2011-03-21, at 8:05 PM, Arnd Bergmann wrote:
> > On Monday 21 March 2011 19:03:09 Andreas Dilger wrote:
> >> Note that mballoc was specifically designed to handle allocation
> >> requests that are aligned on RAID stripe boundaries, so it should
> >> be able to handle this for MMC as well.  What is needed is to tell
> >> the filesystem what the underlying alignment is.  That can be done
> >> at format time with mke2fs or afterward with tune2fs by using the
> >> "-E stripe_width" option.
> > 
> > Ah, that sounds useful. So would I set the stripe_width to the
> > erase block size, and the block group size to a multiple of that?
> 
> When you write "block group size" do you mean the ext4 block group? 

Yes.

> Then yes it would help.  You could also consider setting the flex_bg
> size to a multiple of this, so that the bitmap blocks are grouped as
> a multiple of this size.  However, they may not be aligned correctly,
> which needs extra effort that isn't obvious.  
> 
> I think it would be nice to have mke2fs take the stripe_width and/or
> flex_bg factor into account when sizing/aligning the bitmaps, but it
> doesn't yet.

A few more questions: 

* On cards that can only write to a single erase block at a time,
should I make the block group size the same as the as the erase
block? I suppose writing both block bitmaps, inode and data to
separate erase blocks would create multiple eraseblock
read-modify-write cycles for every single file otherwise.

* Is it guaranteed that inode bitmap, inode, block bitmap and
blocks are always written in low-to-high sector order within
one ext4 block group? A lot of the drives will do a garbage-collect
step (adding hundreds of miliseconds) every time you move back
inside of the eraseblock.

* Is there any way to make ext4 use effective blocks larger
than 4 KB? The most common size for a NAND flash page is 16
KB right (effectively, ignoring what the hardware does), so
it would be good to never write smaller.

* Calling TRIM on SD cards is probably counterproductive unless
you trim entire erase blocks. Is that even possible with ext4,
assuming that we use block group == erase block?

* Is there a way to put the journal into specific parts of the
drive? Almost all SD cards have an area in the second 4 MB
(more for larger cards) that can be written using random access
without forcing garbage collection on other parts.

> > Does this also work in (rare) cases where the erase block size is
> > not a power of two?
> 
> It does (or is supposed to), but that isn't code that is exercised
> very much (most installations use a power-of-two size).

Ok. Recently, cheap TLC (three-level cell, 3-bit MLC) NAND is
becoming popular. I've seen erase block sizes of 6 MiB, 1376 KiB
(4096 / 3, rounded up) and 4128 KiB (1376 * 3) because of this, in
place of the common 4096 KiB. The SD card standard specifies
values of 12 MB and 24 MB aside from the usual power-of-two values
up to 64 MB for large cards (>32GB), while smaller cards are allowed
only up to 4 MB erase blocks and need to be power-of-two. Many
cards do not use the size they claim in their registers.

	Arnd
