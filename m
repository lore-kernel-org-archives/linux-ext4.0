From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck.ext4 -D corrupts fs?
Date: Sun, 23 Aug 2009 10:52:11 -0400
Message-ID: <20090823145211.GF23677@mit.edu>
References: <h6hmcr$hqi$1@ger.gmane.org> <20090820024419.GA7076@mit.edu> <h6k9cp$pe5$1@ger.gmane.org> <h6hmcr$hqi$1@ger.gmane.org> <20090820024419.GA7076@mit.edu> <m27hwykgqh.fsf@vador.mandriva.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Thierry Vignaud <tvignaud@mandriva.com>,
	Marcin Miroslaw <spam_trap@kolekcja.mejor.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:49544 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933589AbZHWOwS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Aug 2009 10:52:18 -0400
Content-Disposition: inline
In-Reply-To: <h6k9cp$pe5$1@ger.gmane.org> <m27hwykgqh.fsf@vador.mandriva.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 20, 2009 at 10:54:30AM +0200, Thierry Vignaud wrote:
> > Yeah, I really should get a new release of e2fsprogs out.  It's fixed
> > in the maint branch.
> 
> /me wait for your announce :-)

I've released e2fsprogs 1.41.9.

						- Ted

E2fsprogs 1.41.9 (August 22, 2009)
==================================

Fix a bug in e2fsck routines for reallocating an inode table which
could cause it to loop forever on an ext4 filesystem with the FLEX_BG
filesystem feature with a relatively rare (and specific) filesystem
corruption.  This fix causes e2fsck to try to find space for a new
portion of the inode table in the containing flex_bg, and if that
fails, the new portion of the inode table will be allocated in any
free space available in the filesystem.

Make e2fsck less annoying by only asking for permission to relocate a
block group's inode table once, instead of for every overlapping
block.  Similarly, only ask once to recompute the block group
checksums, instead of once for each corrupted block group's checksum.

Fix filefrag to avoid print the extent header if the FIEMAP ioctl is
not present, and it needs to fall back to using the FIBMAP ioctl.

Fix filefrag to correctly print the number of extents for zero-length
files.  (Addresses Debian Bug: #540376)

Filefrag now has a -B option which forces the use of the FIBMAP ioctl
to more easily debug the FIBMAP code.

Fixed filefrag for non-extent based files.

Add a new program, e2freefrag, which displays information about the
free space fragmentation in an ext2/3/4 filesystem.

Fix inode resizing via tune2fs -I so that it works correctly in the
face of non-empty bad blocks inodes, and if the filesystem was
formatted using the "mke2fs -E stride=N" option for RAID arrays.

Fix regression in ext2fs_extent_set_bmap() caused e2fsck -fD to fail
and corrupt large directories if the directory needs to shrink by more
than one block.  (Addresses Debian Bug: #537510)
    
Fix e2fsck's buggy_init_scritps=1 so that the if the last write and/or
last mount times are in the future, they are corrected even if
buggy_init_scripts is set.  This is needed because otherwise resize2fs
will refuse to resize the filesystem, even after running "e2fsck -f".
(Addresses Launchpad bug: #373409)

E2fsck will now print much fuller information when the last mount time
or last written time is in the future, since most people can't seem to
believe their distribution has buggy init scripts, or they have a
failed CMOS/RTS clock battery.

Enhance dumpe2fs to dump the extent information via the 'stat'
command, and more detailed extent information via the new command
'dump_extents'.
    
Update French, Polish, Czech, and Sweedish translation from the
Translation Project.

Fixed various Debian packaging issues --- see debian/changelog for
details.

Programmer's Notes
------------------

Fixed miscellaneous gcc -Wall warnings.

Fixed memory leak in error path in ext2fs_block_iterate2()

Fixed non-Linux build of the intl directory by adding support for the
E/Q/V macros.

The bitmap read/write functions now treat uninitialized bitmaps as
unallocated; this fixes a number of problems in all e2fsprogs for ext4
filesystems when there is a need to allocate new blocks or inodes, and
there aren't any free blocks or inodes in the already-used block
groups.

Improve ext2fs_extent_set_bmap() to avoid creating new extents which
get inserted into the extent tree when they are not needed.
    
