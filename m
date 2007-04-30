From: "Theodore Ts'o" <tytso@mit.edu>
Subject: e2fsprogs-1.39-tyt3
Date: Mon, 30 Apr 2007 11:22:25 -0400
Message-ID: <E1HiXhp-0002Fi-Mm@candygram.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44045 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423353AbXD3PW2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Apr 2007 11:22:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Per last week's conference call, I've included an update of the
e2fsprogs patchset to support extents.   It still needs more work before
it can be folded into mainline, but I'm including them so that people
can see which way I'm headed, and because debugfs has been enhaced to
show extents, which can be useful for developers.

One concern I still have is the fact that we're exposing a lot of
interfaces in libext2fs.so which are very specifically tied to the
current 48-bit physical/32-bit logical on-disk extent data structure.
If/when we add support for the 64/64-bit extent data structure, and some
kind of compressed/bit-packed extent format, those interfaces will have
to be extended.

Another problem is that while external extent blocks are getting byte
swapped, there is no byte swapping going on for the extents stored in
the inode.  I haven't tried it on a big endian system, such as Power
machine, but I'm pretty sure it's going to blow up spectacularly.

The patches can be found at:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs-interim/e2fsprogs-1.39-tyt3


						- Ted
