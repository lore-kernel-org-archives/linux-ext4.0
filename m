From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: A proposal for making ext4's journal more SMR (and flash)
 friendly
Date: Fri, 10 Jan 2014 11:32:33 -0500
Message-ID: <20140110163233.GA19485@thunk.org>
References: <nsxfvozavl2.fsf@lambda.thunk.org>
 <20140108221430.GB21663@quack.suse.cz>
 <20140108233752.GD17750@thunk.org>
 <20140110060429.GA26378@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47360 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbaAJQcj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jan 2014 11:32:39 -0500
Content-Disposition: inline
In-Reply-To: <20140110060429.GA26378@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 10, 2014 at 07:04:29AM +0100, Jan Kara wrote:
> > I think there are two interfaces that should handle nearly all of our
> > journal block mapping needs.  The functions that issue bio requests
> > directly tend to use ext4_get_block*() functions, and functions which
> > use the buffer cache uses submit_bh() (typically via ext4_getblk).
> > There will probably be a few exceptions, but I don't think this should
> > be an intractable problem.
>
>   Surely not intractable :) It was just ugly. But you are right that
> hooking in ext4_map_blocks() and then special-casing the few cases where we
> get the block number by different means (xattrs, inode table, group
> descriptor, superblock, traversal of extent tree & indirect block tree)
> should be reasonably elegant.

Yeah, what makes this tricky is that you want to use the "real" block
number for writing (but then write the block into the journal and not
the final location on disk), but the "journal" block for reading.
Whether we put the phys->journal block mapping function in
ext4_map_blocks() triggered via Yet Another Ext4_Map_BlocksFlag, or
via a separate function is a reasonable question (although you can
probably guess I favor the latter).  But that's at the low level.  

In terms of what's above the ext4_map_blocks() layer, that's why I
suggested the ext4_get_block*() functions --- which are used almost
exclusively for reads and direct I/O (for DIO writes we will want to
force the blocks to their final location on disk, I suspect, since
otherwise we will break any journal checksum feature we might have
enabled.  OTOH, DIO writes are for files that are being modified via a
random write pattern, and these are going to be disastrous for SMR
disks anyway) --- and submit_bh() for most of the ext4 metadata
read/writes calls.

						- Ted
