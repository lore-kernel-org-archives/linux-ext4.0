From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: More ext4 corruption
Date: Sat, 4 Apr 2009 21:22:26 +1030
Message-ID: <20090404105226.GC5436@kulgan>
References: <20090403221508.GA5436@kulgan> <49D69AD8.6070808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:57527 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbZDDKwi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Apr 2009 06:52:38 -0400
Content-Disposition: inline
In-Reply-To: <49D69AD8.6070808@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 03, 2009 at 06:25:12PM -0500, Eric Sandeen wrote:
> Kevin Shanahan wrote:
> > Hi,
> > 
> > I'm seeing some more corruption on our ext4 filesystems. Last night's
> > backup job had these errors:
> > 
> ...
> 
> > rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200410_01.htm" failed: Input/output error (5)
> > rsync: readlink "/srv/samba/local/apps/CIM8/Release-Notes/rc_200709_01.pdf" failed: Input/output error (5)
> > IO error encountered -- skipping file deletion
> > skipping non-regular file "apps/CIM8/Release-Notes/rb_200803_02.pdf"
> > rsync error: some files could not be transferred (code 23) at main.c(1524) [generator=3.0.3]
> > setfacl: apps/CIM8/Release-Notes/rb_200803_02.pdf: No such file or directory
> > 
> > The "apps/Gestalt.Net/..." error is an old one and I need to chase
> > that up some more[1]. The corruption in the "Release-Notes" directory
> > is new last night.
> > 
> > My initial information gathering is below. Let me know what else might
> > be helpful, but I'll have to fsck before Monday.
> 
> Any kernel messages this time?  You could also run e2fsck -n and provide
> that output (it should not actually modify anything)

Yes, similar to before:

Apr  4 00:06:02 hermes /USR/SBIN/CRON[10898]: (root) CMD (   /usr/local/bin/rsync-backup-all.sh)
Apr  4 00:06:26 hermes kernel: attempt to access beyond end of device
Apr  4 00:06:26 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648
Apr  4 00:06:26 hermes kernel: init_special_inode: bogus i_mode (114362)
Apr  4 00:06:26 hermes kernel: attempt to access beyond end of device
Apr  4 00:06:26 hermes kernel: dm-0: rw=0, want=1066184788148360, limit=2147483648
Apr  4 00:06:27 hermes kernel: attempt to access beyond end of device
Apr  4 00:06:27 hermes kernel: dm-0: rw=0, want=946232834916360, limit=2147483648
Apr  4 00:06:27 hermes kernel: attempt to access beyond end of device
Apr  4 00:06:27 hermes kernel: dm-0: rw=0, want=1066184788148360, limit=2147483648

e2fsck not looking so good either...

hermes:~# e2fsck -nfv /dev/dm-0
e2fsck 1.41.3 (12-Oct-2008)
Pass 1: Checking inodes, blocks, and sizes
Inode 369 is in use, but has dtime set.  Fix? no

Inode 369 has a extra size (11147) which is invalid
Fix? no

Inode 369 has compression flag set on filesystem without compression support.  Clear? no

Inode 369 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 369 has an invalid root node.
Clear HTree index? no

Inode 369, i_size is 8584410553169684654, should be 0.  Fix? no

Inode 369, i_blocks is 469458281, should be 0.  Fix? no

Inode 370 is in use, but has dtime set.  Fix? no

Inode 371 is in use, but has dtime set.  Fix? no

Inode 371 has imagic flag set.  Clear? no

Inode 371 has a extra size (8644) which is invalid
Fix? no

Inode 372 is in use, but has dtime set.  Fix? no

Inode 372 has a extra size (18912) which is invalid
Fix? no

Inode 373 is in use, but has dtime set.  Fix? no

Inode 373 has a extra size (16777) which is invalid
Fix? no

Inode 374 is in use, but has dtime set.  Fix? no

Inode 374 has a extra size (50665) which is invalid
Fix? no

Inode 375 is in use, but has dtime set.  Fix? no

Inode 375 has a extra size (36893) which is invalid
Fix? no

Inode 375 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 375 has an invalid root node.
Clear HTree index? no

Inode 375, i_size is 14681128715225296171, should be 0.  Fix? no

Inode 375, i_blocks is 2975024509, should be 0.  Fix? no

Inode 376 is in use, but has dtime set.  Fix? no

Inode 376 has a extra size (57416) which is invalid
Fix? no

Error while reading over extent tree in inode 376: Corrupt extent header
Clear inode? no

Segmentation fault
hermes:~#

Cheers,
Kevin.
