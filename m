From: "George Spelvin" <linux@horizon.com>
Subject: Re: Exciting :-( adventures in metadata checksumming
Date: 8 Aug 2012 19:42:39 -0400
Message-ID: <20120808234239.4443.qmail@science.horizon.com>
References: <20120808223427.26158.qmail@science.horizon.com>
Cc: linux@horizon.com
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:10660 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753039Ab2HHXmk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Aug 2012 19:42:40 -0400
In-Reply-To: <20120808223427.26158.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Can someone find a workaround QUICKLY?  I can't keep this FS read-only
> for long.

I thought I had figured out a great workaround: Use 1.42.4, which doesn't
know how to check checksums.

But then I doscovered that it aborts and delivers a zero-length file
if there are filesystem inconsistencies, too!  So I get

e2image 1.42.4 (12-Jun-2012)
Illegal block number passed to ext2fs_mark_block_bitmap #3571066296 for in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #2895243190 for in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #3276895043 for in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #2488200263 for in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #2556839855 for in-use block map
... snip... (2671 total "Illegal block number passed" messages)
Illegal block number passed to ext2fs_mark_block_bitmap #3421917394 for in-use block map
Illegal block number passed to ext2fs_mark_block_bitmap #3469830505 for in-use block map
e2image: Illegal indirect block found while iterating over inode 85800474

I'm not sure this is The Right Thing To Do for a debugging tool.


The file system is a RAID-6, and repeated verifications have failed to find
RAID mismatches.

I am starting to suspect motherboard/RAM on this machine.  Already the bad
magic number error patterns looked odd to me, and I was just reminded that
we had to swap the RAM when it was first built so memtest8 would pass.
We ran it for many hours, but it *is* a consumer Intel box with no ECC.

And 8 GiB of RAM, and acting primarily as a file server, so FS metadata can
sit and bit-rot in RAM for a very long time.

I'm going to play with "hdparm -f" and drop_caches to see if I can make
the file system problems go away with no repair other than re-reading
from disk.

If so, That would confirm it as not ext4's problem.  Although it *would* be
a very cool debugging feature to re-check the checksum whenever a metadata
page is discarded from the buffer cache.

If the checksum matched when first read in, and doesn't when a supposedly
clean page is discarded, *something* is corrupting RAM.  (If you
assume that it's a single bit flip, then you can deduce the location
from the error syndrome.)


Anyway, thanks for the help!
