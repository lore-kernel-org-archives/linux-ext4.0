From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs: remove fragment support (V3)
Date: Sun, 12 Aug 2007 17:29:55 -0400
Message-ID: <20070812212955.GD21719@thunk.org>
References: <46BC9CC3.9090005@suse.de> <20070812033129.GB21719@thunk.org> <46BF3656.4010108@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
To: Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56405 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbXHLVaf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 17:30:35 -0400
Content-Disposition: inline
In-Reply-To: <46BF3656.4010108@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Aug 13, 2007 at 12:33:26AM +0800, Coly Li wrote:
> Theodore,
> 
> Another question of mine is for the .po files: Once I modify a string from _(""), should I mofify
> all the corresponded strings from all .po files ?

No, don't bother.  Periodically I run "make update-pot" in the po
directory, which updates the e2fsprogs.pot file, followed by a "make
update-po" which remove the strings from the .po files.

> Oops, I thought that issues from my email client. OK, next time when
> I send patch I will use MIME-PGP.

Yeah, it's protecting the "-----BEGIN PGP SIGNED MESSAGE-----" header
line, so it has to add "- " to all lines that begin with "-".  Using
MIME-PGP means that we use the MIME message boundaries instead.

> > In addition, for now, I'd like to keep the code which checks the
> > remaining fragment fields in the inode and superblock since they act
> > as a safety check to make sure the filesystem is sane and we don't
> > have garbage there.  The checksum fields will obviate this need, but
> > keeping the checks there for ext2/ext3 filesystems seem like a good
> > idea.
> 
> My idea is:
> 1) Modify names of related fields of superblock and inode. to avoid others using these field in future.
> 2) Keep checking code for the modified fields. to make source code robust.

Comments in the header file is probably enough, I think.  Changing the
names fields just causes a lot of code churn....

> > Dropping the union is probably fine, since at this point it looks
> > pretty clear that both the Hurd and Masix is dead.  But let's do the
> > cleanups a little at a time, and I'd probably start with just removing
> > the cruft from the mke2fs options and man pages.
> 
> Sure, I agree with you :-)

I did some checking, and it looks like Hurd is still using basic ext2.
Some grad student did a ext3 driver for Hurd, but it's unstable and
was apparently last touched in 2005 (the Ph.D. thesis was done in 2003
iirc).  Sigh...

Unfortunately, I did some checking and it looks like there are some
crazy people that are still actively working on a Debian GNU/Hurd
project.  So let's leave the Hurd stuff in for now.  There may be some
issues where they will need to drop using ext2 for licensing reasons,
but let's save this cleanup for later.  It doesn't cost us much to
leave it in, after all.

					- Ted
