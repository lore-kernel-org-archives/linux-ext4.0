From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck 1.39 segfaults while fixing a corrupt inode
Date: Fri, 10 Aug 2007 10:03:41 -0400
Message-ID: <20070810140341.GA1093@thunk.org>
References: <a73860e00708100541v59628f6dn491327b6d3097e5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Kosta Kliakhandler <kostak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46605 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937224AbXHJODr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Aug 2007 10:03:47 -0400
Content-Disposition: inline
In-Reply-To: <a73860e00708100541v59628f6dn491327b6d3097e5b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 10, 2007 at 03:41:32PM +0300, Kosta Kliakhandler wrote:
> 
> I have a severe problem - I was a fool and made / (root) ext4 (at
> least not /home, thank god) and somehow some corruption occured.
> While running fsck, it keeps segfaulting, complaining about fast
> memory corruption (segfaults always at the same inode, always when I
> tell it to fix it). I *think* the issue was addressed in
> e2fsprogs-1.40.2 (from what I understood in the changelog)

What, you mean this one?

   A recent change to e2fsck_add_dir_info() to use tdb files to check
   filesystems with a very large number of filesystems had a typo which
   caused us to resize the wrong data structure.  This would cause a
   array overrun leading to malloc pointer corruptions and segfaults.
   Since we normally can very accurately predict how big the the dirinfo
   array needs to be, this bug only got triggered on very badly corrupted
   filesystems.

If so, it couldn't be, since the tdb support was only added in
e2fsprogs 1.40, and you're using the 1.39 patchset, right?  So it has
to be some other problem, and probably a bug which gets triggered when
it runs across a corrupted extent entry.

How big is your root filesystem image?  Unfortunately e2image hasn't
been updated support extents yet (there's a reason I keep telling
people ext4 isn't quite ready for prime time yet...), so we can't use
a compressed e2image file.

							- Ted
