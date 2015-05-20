From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unused block group, but all blocks not free?
Date: Wed, 20 May 2015 11:10:07 -0400
Message-ID: <20150520151007.GK2871@thunk.org>
References: <555BDEF4.1020704@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47879 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbbETPKL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 May 2015 11:10:11 -0400
Content-Disposition: inline
In-Reply-To: <555BDEF4.1020704@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 19, 2015 at 09:10:12PM -0400, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> I broke out the old e2defrag for an experiment today ( wondering why
> resize2fs refuses to shrink a volume below half its size even though
> it is only 33% used; thought I would try packing all files as far to
> the left as possible and try again ) and it bailed out because the
> free block count listed in the superblock does not match what the
> block allocation bitmaps indicate.  It turns out this is due to some
> block groups that are unused, and thus have uninitialized allocation
> bitmaps, yet somehow claim to not have all of their blocks free.  The
> stats output from debugfs shows this:
> 
>  Group 25: block bitmap at 524297, inode bitmap at 524313, inode table
> at 528928
>            32383 free blocks, 8192 free inodes, 0 used directories,
> 8192 unused inodes
>            [Inode not init, Block not init, Checksum 0x45a8]
> 
> 
> How on earth can this be?  The block allocation bitmap is
> uninitialized, therefore all bits are assumed to be clear.  Yet the
> free blocks count is only 32383 instead of 32768.  How can a block
> group be totally unused, and yet not have all of its blocks free?

Have you checked to see if the metadata for other block groups are
taking up space in the block group.  This can happen when using the
flex_bg layout.  (And without flex_bg, then *all* block groups will
always have blocks in use, for their own metadata blocks.)

						- Ted
