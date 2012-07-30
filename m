From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Minimal configuration for e2fsprogs
Date: Mon, 30 Jul 2012 17:45:32 -0400
Message-ID: <20120730214531.GE10343@thunk.org>
References: <20120615042421.GA7021@thor.bakeyournoodle.com>
 <20120627112117.GA15231@thor.bakeyournoodle.com>
 <20120627125443.GA32356@thunk.org>
 <20120628024356.GB17989@thor.bakeyournoodle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42122 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab2G3Vpe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 17:45:34 -0400
Content-Disposition: inline
In-Reply-To: <20120628024356.GB17989@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 28, 2012 at 12:43:56PM +1000, Tony Breeds wrote:
> 
> Okay so I think you want somethign like:

Yep!

> What I did was remove dblist.o from my libext2fs.a and I now get:
> /home/tony/src/e2fsprogs/../e2fsprogs-root/lib/libext2fs.a(gen_bitmap64.o): In function `ext2fs_alloc_generic_bmap':
> /home/tony/src/e2fsprogs-build/lib/ext2fs/../../../e2fsprogs/lib/ext2fs/gen_bitmap64.c:112: undefined reference to `ext2fs_get_num_dirs'
> 
> So it looks like dblist.o is being pulled in for ext2fs_get_num_dirs()
> in that case a EXT2FS_BMAP64_AUTODIR bmap type has been asked for.
> 
> How would you feel about moving ext2fs_get_num_dirs from dblist.c to
> blknum.c?

Sure, no problem.

Take a look at this set of patches (see attached).  With this and the
set of ext2fs functions that I understand yaboot is using, I think it
solves the concern that you have.  This will be in the next branch of
the e2fsprogs.

Regards,

					- Ted
