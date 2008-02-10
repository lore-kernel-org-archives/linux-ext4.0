From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: move headers out of include/linux
Date: Sun, 10 Feb 2008 07:54:32 -0500
Message-ID: <20080210125432.GA21729@mit.edu>
References: <20080209093933.GA5882@lst.de> <20080210065222.GA22951@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33921 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756013AbYBJNAr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2008 08:00:47 -0500
Content-Disposition: inline
In-Reply-To: <20080210065222.GA22951@lst.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 10, 2008 at 07:52:22AM +0100, Christoph Hellwig wrote:
> On Sat, Feb 09, 2008 at 10:39:33AM +0100, Christoph Hellwig wrote:
> > Move ext4 headers out of include/linux.  This is just the trivial move,
> > there's some more thing that could be done later.
> > 
> > Ted, is anything of these shared with e2fsprogs or can we rip out all
> > that #ifdef __KERNEL__ junk?

No, none of this is shared with e2fsprogs; e2fsprogs stopped using the
kernel header files about seven years ago. (May 2001, e2fsprogs 1.20).

> > Note that I plan to submit similar patches for ext2 and ext3 aswell,
> > so the diverging from them argument doesn't count.

There might be other programs like grub that may depend upon ext2_fs.h
or ext3_fs.h....  <apt-get source / grep>   Nope, not grub.  So a few
things might break, but they are all programs that should have been
using the libraries shipped with e2fsprogs, and they wouldn't be 
critical programs.  So no problems that I know of.

> Looks like the patch is to big for vger.  Here's a link instead:
> 
> http://verein.lst.de/~hch/ext4-move-headers

Note Linus just accepted a pull from me (although it just missed the
-git21 snapshot window --- <aside> it would be nice if that happend at
3am Pacific instead of midnight Pacific since very occasionally it's a
little after midnight before Linus pushes his last set of changes to
master.kernel.org</aside>) so this patch won't apply cleanly to the
Linus's tip.  I'll take the patch DTRT so it can be placed in the ext4
tree.

Also, on the git list, Linus mentioned the -rc1 merge window would be
closing soon, though, so I don't know if this will make 2.6.25.  If it
doesn't, would you mind terribly if we put this on hold and *not* have
this in the -mm tree until right before the next merge window opens.
It's mostly a mechnical change, doesn't need much testing --- and it
complicates patch management which I know has been making Andrew a bit
grumpy as of late.  (Some people submit patches against Linus's tip,
and they are sweeping changes that touch files in multiple maintainer
trees, like the iget() removal patch or the r/o bind patch, and life
gets hard.)

I think the general idea is good; it's just a matter of timing.

						- Ted
