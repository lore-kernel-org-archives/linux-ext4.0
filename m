From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Missing JBD2_FEATURE_INCOMPAT_64BIT in ext4
Date: Thu, 19 Apr 2007 23:03:43 -0600
Message-ID: <20070420050343.GP5967@schatzie.adilger.int>
References: <20070415161606.GG5967@schatzie.adilger.int> <1177010100.6703.8.camel@dyn9047017103.beaverton.ibm.com> <20070419211817.GO5967@schatzie.adilger.int> <1177029704.6703.46.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:36253 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422722AbXDTFDp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Apr 2007 01:03:45 -0400
Content-Disposition: inline
In-Reply-To: <1177029704.6703.46.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 19, 2007  17:41 -0700, Mingming Cao wrote:
> Any concerns about turn on META_BG by default for all new ext4 fs?
> Initially I thought we only need META_BG for support >256TB, so there is
> no rush to turn it on for all the new fs. But it appears there are
> multiple benefits to enable META_BG by default:

I would prefer not to have it default for the first 1TB or so of the
filesystem or so.  One reason is that using META_BG for all of the groups
give us only 2 backups of each group descriptor, and those are relatively
close together.  In the first 1TB we would get 17 backups of the group
descriptors, which should be plenty.

> - enable online resize >2TB

Actually, I don't think the current online resize support for META_BG.
There was a patch last year by Glauber de Oliveira Costa which added
support for online resizing with META_BG, which would need to be updated
to work with ext4.  Also, the usage of s_first_meta_bg in that patch is
incorrect.

> - support >256TB fs 

True, though not exactly pressing, and filesystems can be changed
to add META_BG support at any point.

> - Since metadatas(bitmaps, group descriptors etc) are not put at the
>   beginning of each block group anymore, the 128MB limit(block group size
>   with 4k block size) that used to limit an extent size is removed. 
> - Speed up fsck since metadata are placed closely. 

That isn't really true, even though descriptions of META_BG say this.
There will still be block and inode bitmaps and the inode table.
The ext3 code was missing support for moving the bitmaps/itable outside
their respective groups, and that has not been fixed yet in ext4.

The problem is that ext4_check_descriptors() in the kernel was never
changed to support META_BG, so it does not allow the bitmaps or inode
table to be outside the group.  Similarly, ext2fs_group_first_block()
and ext2fs_group_last_block() in lib/ext2fs also don't take META_BG
into account.

Also, since the extent format supports at most 2^15 blocks (128MB) it
doesn't really make much difference in that regard, though it does help
the allocator somewhat because it has more contiguous space to allocate
from.

> So I am wondering why not make it default?

It wouldn't be too hard to add in support for this I think, and there
is definitely some benefit.  Since neither e2fsprogs nor the kernel
handle this correctly, the placement of bitmaps and inode tables outside
of their respective groups may as well be a separate feature.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
