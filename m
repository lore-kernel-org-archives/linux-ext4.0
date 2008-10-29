From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bugme-new] [Bug 11873] New: unable to mount ext3 root
	filesystem due to htree_dirblock_to_tree
Date: Tue, 28 Oct 2008 21:53:29 -0400
Message-ID: <20081029015329.GB8295@mit.edu>
References: <bug-11873-10286@http.bugzilla.kernel.org/> <20081028103122.728aa427.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	Jimmy.Jazz@gmx.net
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47358 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755242AbYJ2Bxd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Oct 2008 21:53:33 -0400
Content-Disposition: inline
In-Reply-To: <20081028103122.728aa427.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 28, 2008 at 10:31:22AM -0700, Andrew Morton wrote:
> > 
> > Since 2.6.28 mount command (busybox) is unable to mount the root file system.
> > The error returned is,
> > 
> > EXT3-fs error (device md_d0p2): htree_dirblock_to_tree: bad entry in directory
> > #2: rec_len % 4 != 0 - offset=0, inode=2109536318, rec_len=16058, name_len=111
> > 

That error means the ext3 filesystem detected an error when responding
to a readdir() request from user space.  So it seems rather strange
that this came from a mount command.  It looks like the mount
succeeded, and then something in userspace did the equivalent of "ls
/*" or "echo /*", and the first part of the directory was totally
garbaled.  (It should have been inode=2, rec_len=12, name_len=1 for
the '.' entry in the root directory.)

> > IMHO, it is a problem in mbcache or jbd.

Why do you think it is a problem with mbcache or jbd?  mbcache is only
used for extended attributes, and jbd would only get invoked once the
filesystem was getting modified.  If there was corruption in the
journal that was corrupting the filesystem when journal was recovered,
the directory corruption would be permanent, and not something that
would magically disappear when you mount the filesystem as ext2
read-only, and then remount as ext3.

This smells like ext3 is getting garbage when first reading in the
filesystem from the md device.  And then when you report that you're
also having mysterious md failures:

> > Also, there is an other problem with that kernel. After creating
> > the /dev node, loading md_mod and raid1, mdassemble start as usual
> > the md device, but the mount command doesn't recognize the /dev
> > node as valid and abort.  I need to stop the md device that has
> > been created earlier and reapply mdassemble or mdadm --assemble
> > --scan from initramfs file system. Afterwards mount command is
> > able to mount the file system but... like an ext2 file system.
> > I'm on step 2 again.
> > 

That smells like a problem with the md device, or the md setup code.

I suspect if you were to arrange to include dumpe2fs or debugfs in
your initrd, you would find that you are reading garbage from the md
device, and dumpe2fs and debugfs would be reporting, "huh?  there's no
ext3 filesystem image here".  I don't think this is a ext3 problem at
all.

							- Ted
