From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Recovery after mkfs.ext4 on a ext4
Date: Sun, 15 Jun 2014 09:20:26 -0400
Message-ID: <20140615132026.GC2180@thunk.org>
References: <539D555E.3050707@scarlet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Killian De Volder <killian.de.volder@scarlet.be>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39607 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaFONU2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Jun 2014 09:20:28 -0400
Content-Disposition: inline
In-Reply-To: <539D555E.3050707@scarlet.be>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 15, 2014 at 10:12:14AM +0200, Killian De Volder wrote:
> Excuse me for requesting this information,
> but I could not find any good leads on how to deal with this issue.
> Any help would be appreciated.
> 
> This is what happened:
> I accidentally exported the wrong block-device to a virtual machine.
> I ran mkfs.ext4 on this, already mounted ext4, block-device.
> As soon as I noticed the error,I stopped it.
> It got to "Writing superblocks and file system accounting information".
> (After Writing inode tables, and creating journal).

Ouch.  There are safety measures to prevent mke2fs from running on a
mounted file system.  However, these don't apply when you've exported
the block device via KVM.  It could be perhaps argued that qemu should
add this safety check, and at least warn before you exported a block
device already in use as a file system.  It's probably worth taking
that up with the qemu folks.

If it's any consolation the very latest version of e2fsprogs has a
safety check that might have caught the problem:

# mke2fs -t ext4 /dev/heap/scratch
mke2fs 1.42.10 (18-May-2014)
/dev/heap/scratch contains a ext4 file system labelled 'Important Stuff'
		  last mounted on Tue Jun  3 16:12:01 2014
Proceed anyway? (y,n) n

> Would it be better if I ran mkfs.ext4 -S ?

Probably note.  This is useful when the superblock and block group
descriptors have been destroyed, and that's not the case here.  The
fact that the volume name is the original means that you have at least
the original superblock, and the real problem here is that damage that
was caused by the portions of the inode table that were wiped out.  

> Can e2fsck recover the directory structure and/or files in this scenario?

Well, maybe.  The problem is what got destroyed....  given some of the
errors you have described, it looks like more than the inode table got
wiped.  It's quite possible that version of mke2fs used to create the
original file system is older than the one used in the guest OS.  For
example, we changed where we placed the journal at one point.  That
would explain some of the file system errors.

> Can I use debugfs to start at a directory inode and then use rdump ?

Again, maybe.  The problem is that if a particular subdirectory is
destroyed, then you won't find it via rdump.  E2fsck can relocate
files and subdirectories contained in damaged directories to
lost+found, which rdump obviously can't cope with.

> Should I just revert to file recovery tools like photorec ?

Sorry, I keep saying maybe.  Photorec will definitely recover more
files; however, you won't have the filename data, which may be quite
problematic.  If the files are self identifying via things like EXIF
tags, or MP3 tags, or other in-file metadata, then photorec works
really well. 

But if you are stiching together lots of small source files, or
component .tex files from several dozen different directories, it's
photorec may not be that much more useful.

> Is there a way to reduce the memory usage during e2fsck in this scenario ?

Sorry, not really.

Good luck,

						- Ted
