From: "Theodore Ts'o" <tytso@mit.edu>
Subject: E2fsprogs master branch now has all 64-bit patch applied
Date: Mon, 14 Jun 2010 09:39:32 -0400
Message-ID: <E1OO9sy-0006P1-Nr@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60675 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab0FNNjh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jun 2010 09:39:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


It's taken way too long, but I've finally finished integrating the
64-bit patches into e2fsprogs's mainline repository.  All of the
necessary patches should now be in the master branch for e2fsprogs.

The big change from before is that I replaced Val's changes for fixing
up how mke2fs picked the correct fs-type profile from mke2fs.conf with
something that I think works much better and leaves the code much
cleaner.  With this change you need to add the following to your
/etc/mke2fs.conf file if you want to enable the 64-bit feature flag
automatically for a big disk:

[fs_types]
	ext4 = {
		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
		auto_64-bit_support = 1   # <---- add this line
		inode_size = 256
	}

Alternatively you can change the features line to include the feature
"64bit"; this will force the use of the 64-bit fields, and double the
size of the block group descriptors, even for smaller file systems that
don't require the 64-bit support.  (This was one of my problems with
Val's implementation; it forced the mke2fs.conf file to always enable
the 64-bit feature flag, which would cause backwards compatibility
issues.)  This might be a good thing to do for debugging purposes,
though, so this is an option which I left open, but the better way of
doing things is to use the auto_64-bit-support flag.

Should the default for auto_64-bit-support be on or off?  For now I've
left it to be defaulted to "off", on the theory that it might be useful
for distributions that aren't quite ready to enable 64-bit support until
we do a lot more testing.  But I may very well change this default
before 1.42 ships, on the theory that people who want to disable this
just ship an edited mke2fs.conf file.  (Users can always explicit
request 64bit support by using "mke2fs -O 64bit", of course.)  Comments
on this would be appreciated.

The other support which I've added into mke2fs.conf handling is I've
added two additional automatically selected fs-types, which work like
"floppy" and "small".  These are "big" which is automatically selected
for filesystems >= 4TB, and and "huge" which is elected for filesystems
>= 16TB.  I'm not 100% sure this will be useful, but it seemed like
it might be useful to have these.  Again, comments appreciated it; the
names and the cutoff points may change before the 1.42 release.

What are things that are still left to be done before we 64-bit support
is completely supported?  Just a few things:

* Currently the badblocks list mechanism only supports 32-bit blocks.
  This may be OK, since running "badblocks" on a really large disk is
  probably a fool's errand.  But how we handle this is an open question;
  should we just refuse "mke2fs -c" or "e2fsck -c" for really big file
  systems?  Should we deprecate the badblocks inode altogether?

* The online resizing code, which relies on using a resize inode and
  indirect blocks, will not scale to 64-bit filesystems.  We have the
  beginnings of support for the "meta_bg" style of resizing, which is
  supported by the kernel and the e2fsprogs code --- but it hasn't been
  implemented in the kernel yet.  We need to add that.

  As a related note, currently the online resizing code doesn't
  understand about flex_bg, so the filesystem layout for filesystems
  which are grown using online resizing is definitely not optimized for
  flex_bg.  This is something that we would probably want to fix at the
  same time, since it means adding a new ioctl interface between the
  kernel and the resize2fs program.

							- Ted
