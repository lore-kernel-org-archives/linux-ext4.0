From: Andreas Dilger <adilger@sun.com>
Subject: Re: Options for migrating existing files on ext2 partitions to ext4
Date: Thu, 12 Feb 2009 02:23:34 -0500
Message-ID: <20090212072334.GB3199@webber.adilger.int>
References: <d5ca277e0902111218l1b568724l2557315d2945637a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, ext4-team <ext4-team@google.com>
To: Xiang Wang <xiangw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62989 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587AbZBLHXs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2009 02:23:48 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n1C7NkQe013367
	for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 23:23:46 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KEX00B00Z2LDG00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Wed,
 11 Feb 2009 23:23:46 -0800 (PST)
In-reply-to: <d5ca277e0902111218l1b568724l2557315d2945637a@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 11, 2009  12:18 -0800, Xiang Wang wrote:
> Since we are thinking of switching into using the ext4 file systems on
> some of our machines with purely ext2 partitions, we face the problem
> of how to migrate all those existing files on ext2 partitions. Seems
> like there are two major directions to go:
> 
> 1) do a backup, umount, mke2fs into ext4, and restore
> In this approach, we may actually take advantage of the layout changes
> so as to benefit from some features of ext4.
> 
> 2) umount, tune2fs to add the 'extent' feature, mount back using type
> ext4,

Note that you can really stop at this point - new files will be created
with extents, old ones will be left alone.

> migrate the existing files(directories) one by one through the
> ioctl EXT4_IOC_MIGRATE

Note that you don't really need to do this.  If the filesystem is
offline to users you can just do "cp file file.tmp; mv file.tmp file"
and it will do the same thing, with exception of getting a new inode
number and requiring that files are not being modified at the time.

> Motivated by the ext4 ioctl interface for migration, we are also
> looking into this in-place approach. But we are mostly concerned with
> the fact that if the existing files are highly fragmented, will we
> still get benefit from the extents? Or will we even get hurt by
> turning the files into being extents-based?

The mballoc allocator is pretty good in conjunction with delalloc, so
I expect you would get mostly defragmented files as you migrate.  This
would depend on having some decent amount of free space in the filesystem
so that it is likely that there is enough contiguous free space for some
number of the >= average size files.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

