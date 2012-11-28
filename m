From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Errors from e2image
Date: Wed, 28 Nov 2012 16:29:03 -0500
Message-ID: <20121128212903.GB30650@thunk.org>
References: <CAP5prOhNaffwJaPQageP-jvHTccaEKhQCmwqVbMeSwPq-DUodg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Adam Huffman <adam.huffman@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35556 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab2K1V3H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Nov 2012 16:29:07 -0500
Content-Disposition: inline
In-Reply-To: <CAP5prOhNaffwJaPQageP-jvHTccaEKhQCmwqVbMeSwPq-DUodg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 28, 2012 at 06:32:24PM +0000, Adam Huffman wrote:
> Hello again
> 
> I've just run e2image, as you suggested and it doesn't look like it's
> ever going to complete.
> 
> There are lots of errors on the console like:
> 
> Illegal block number passed to ext2fs_mark_block_bitmap #822751537 for
> in-use block map

Hmmm.., can you send me the *complete* output of e2fsck -n on the file system image?

This is a very basic error caused by illegal block numbers in an inode
extent map (or indirect block).  E2fsck should have reported this, and
fixing this is not hard.  Yet nothing you sent me showed anything like
that --- but you've only sent me excerpts, and not the full e2fsck
output.....

> Is this something I need to leave running for a long time?

How big is your file system?  It shouldn't take that long, but the
illegal block numbers should not caused it to get it stuck in a loop.

> I tried it
> on the other problematic LV and the command did complete, though the
> qcow2 file it produced was empty.

Now *that's* just weird.  Just to be sure... can you try reinstalling
the e2fsprogs package on your system?  I'm wondering if the shared
libraries have gotten subtly corrupted somehow....  what you are
reporting just doesn't make any sense....

						- Ted
