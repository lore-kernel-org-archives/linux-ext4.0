From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ext4: move headers out of include/linux
Date: Sun, 10 Feb 2008 15:17:53 +0100
Message-ID: <20080210141753.GA9843@lst.de>
References: <20080209093933.GA5882@lst.de> <20080210065222.GA22951@lst.de> <20080210125432.GA21729@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:42489 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYBJOTt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Feb 2008 09:19:49 -0500
Content-Disposition: inline
In-Reply-To: <20080210125432.GA21729@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Feb 10, 2008 at 07:54:32AM -0500, Theodore Tso wrote:
> No, none of this is shared with e2fsprogs; e2fsprogs stopped using the
> kernel header files about seven years ago. (May 2001, e2fsprogs 1.20).

Yeah, I know userspace stopped using the direct copy.  But for example
XFS has exact copies of some headers under fs/xfs also in the userspace
package.  But I assume your answer means you have a completely separate
set of headers for e2fsprogs, which makes sense given it supports ext2,
ext3 and ext4 all with one codebase.

> > > Note that I plan to submit similar patches for ext2 and ext3 aswell,
> > > so the diverging from them argument doesn't count.
> 
> There might be other programs like grub that may depend upon ext2_fs.h
> or ext3_fs.h....  <apt-get source / grep>   Nope, not grub.  So a few
> things might break, but they are all programs that should have been
> using the libraries shipped with e2fsprogs, and they wouldn't be 
> critical programs.  So no problems that I know of.

We might have to leave the user-space visible parts of ext2_fs.h
in place due to historical reasons, so I will leave that part out of
the first patch.  I don't think that argument is valid for ext3_fs.h
as ext3 only go into mainline at the same time as /usr/include/ext2fs/
started appearing even if ext3_fs.h is exported currently.

> Note Linus just accepted a pull from me (although it just missed the
> -git21 snapshot window --- <aside> it would be nice if that happend at
> 3am Pacific instead of midnight Pacific since very occasionally it's a
> little after midnight before Linus pushes his last set of changes to
> master.kernel.org</aside>) so this patch won't apply cleanly to the
> Linus's tip.  I'll take the patch DTRT so it can be placed in the ext4
> tree.

Updated patch is in the same location:
	
	http://verein.lst.de/~hch/ext4-move-headers

> Also, on the git list, Linus mentioned the -rc1 merge window would be
> closing soon, though, so I don't know if this will make 2.6.25.  If it
> doesn't, would you mind terribly if we put this on hold and *not* have
> this in the -mm tree until right before the next merge window opens.
> It's mostly a mechnical change, doesn't need much testing --- and it
> complicates patch management which I know has been making Andrew a bit
> grumpy as of late.

Yeah, if it's too late already we can defer it.
