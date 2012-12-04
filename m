From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [e2fsprogs] initdir: Writing inode after the initial write?
Date: Tue, 4 Dec 2012 15:36:34 -0500
Message-ID: <20121204203634.GF7790@thunk.org>
References: <92FEB3B3-D4EA-4E84-83F2-F9946D7BCE3B@dilger.ca>
 <50B990CB.3080607@infradead.org>
 <85A86E8F-EEB9-495C-AB10-EF3C871EE2B9@dilger.ca>
 <50BD017F.1070400@infradead.org>
 <E9A4182B-CEE4-419A-AE6B-F7133766ABC3@gmail.com>
 <50BE3639.7090704@infradead.org>
 <20121204190829.GA7790@thunk.org>
 <50BE51BF.6020208@infradead.org>
 <20121204200013.GD7790@thunk.org>
 <50BE58B8.6020909@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <aedilger@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Darren Hart <dvhart@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:36793 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab2LDUgk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Dec 2012 15:36:40 -0500
Content-Disposition: inline
In-Reply-To: <50BE58B8.6020909@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 04, 2012 at 12:10:32PM -0800, Darren Hart wrote:
> > 
> >>    [ ] Add meta-data mirroring
> > 
> > Not sure what what you mean by meta-data mirroring?
> 
> Sorry, just uid, gid, permissions... basically the inode. This could be
> done by updating the script to use the sif command, but having a -i or
> similar option to "write" (or maybe a new "copy" which did effectively
> the same thing) by reading stat and copying the data across would be a
> nice abstraction.

Oh, I see, grabbing the permissions from what's actually in the source
tree.  You may want to talk to some of the people who will actually be
using your script to see what they want.  I could easily imagine some
folks arguing that they don't want to use the mtimes from the source
code tree, but instead they want to set them all to some standard set
timestamp specified in some config file (in order to make the file
system image be stable across checkouts).

In addition, for setuid root programs, you won't be able to take the
uid/gid and permissions from the inode anyway --- so I had been
assuming that you would have some kind of control file, that would
perhaps be in the top-level of your initial_ directory, that would
list the default uid/gid/mod times to be used, and then exceptions on
a per-file basis.  (This was the control file where I was suggesting
that you _not_ use XML for your encoding; if you want a flexible, but
easy-to-use config file parser, I'll suggest you take a look at
e2fsck/profile.c, which is used for parsing /etc/e2fsck.conf and
/etc/mke2fs.conf.)

> Agreed on the hard link. However, things like mknod and write from
> debugfs seem like good candidates to be moved into libext2fs, then
> other tools can make use of the code.

For write from debugfs, you do realize we have lib/ext2fs/fileio.c,
right?  That's what debugfs uses already.

Maybe it would make sense to add a ext2fs_create_file() function which
takes a pathname, and it takes care of calling namei to get the target
directory, and then allocating the file, etc., and then leave it to
the calling application to fill in the inode structure with whatever
is neecessary to create a new regular file, or a new block/character
device, etc.

So that one new function would would kill multiple stones at once; it
would give you mknod, as well as refactoring most of what's in debugfs
today for writing a file to a filesystem that isn't in
lib/ext2fs/fileio.c.

The one gotcha with creating these convenience functions is that it
make may it much harder to properly report errors back to the user,
since a fundamental rule for functions in libext2fs is that they
should not use fprintf(stderr, ...) to report errors back to the user.
That's the other reason why I tended not push too much complexity into
libext2fs.

(In general use of stdio in libext2fs is strongly discouraged, since
that wouldn't be useful for an application written to uses gtk or even
ncurses, such as that old EVMS front end program that some former
colleagues of ours at IBM's LTC had written.  :-)  It's also
problematic for the ppcboot folks, since they are trying to write a
bootloader which would use libext2fs in a restricted environment that
doesn't even have stdio available to programs; that was actually a
problem for them caused by the recently merged mmp code, and I had to
help them with that.)

						- Ted
