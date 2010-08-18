From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Memory allocation failed, e2fsck: aborted
Date: Wed, 18 Aug 2010 14:20:13 -0600
Message-ID: <EDA85D20-C083-41FE-B561-8014C496C4CB@dilger.ca>
References: <20100818140422.GL27457@skl-net.de>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Marcus Hartmann <marcus.hartmann@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:51773 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0HRUUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Aug 2010 16:20:15 -0400
In-Reply-To: <20100818140422.GL27457@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-18, at 08:04, Andre Noll wrote:
> I'm having trouble with checking a corrupt ext3 file system resulting
> from a 3-disk failure on a 12 disk software raid6 array. The disk
> failure was due to an issue with the (3ware) controller and 11 disks
> appear to be fine. However, I had to --assemble --force the array
> because two of the 11 disks were not up to date after the crash.
> 
> e2fsck from today's git master branch aborts after a while with
> 
> 	./e2fsck -f -y -C 0 /dev/euclidean/snap_abt1_kristall_RockMakerStorage
> 	e2fsck 1.41.12 (17-May-2010)
> 	Backing up journal inode block information.
> 
> 	Pass 1: Checking inodes, blocks, and sizes
> 	Error storing inode count information (inode=245859898, count=2): Memory allocation failed
> 	e2fsck: aborted
> 
> This is an old 32 bit system with only 1G of ram and a 2.6.24 distro
> kernel. I added _lots_ of swap but this did not help.

Yeah, it is possible to have filesystems that are too large for the node they are running on.  There are low-priority discussions for how to reduce memory usage of e2fsck, but they have never been a priority to implement.

> Since the file system is corrupt anyway, it is maybe easiest
> to delete inode 245859898 with debugfs, but maybe there is
> a better option. Moreover, since this might be some kind of
> e2fsck-trusts-corrupt-data issue, you might be interested in looking
> at this.

No, I don't think this will help.  The problem is not with that inode, just that it is needing to allocate a structure because of nlinks=2 (this is normal).

In theory it might be possible to avoid allocating icount structures for every directory inode (which have icount == 2 normally), if we used the "fs->inode_dir_map" bit as "+1" for the inode link count.

In any case, this is a non-trivial fix.

> Further info: The ext3 file system lives on a lv within a vg whose
> single pv is the 12 disk raid6 array. The file system stores hard
> link based backups, so it contains _lots_ of hard links.

Ah, that is also a major user of memory, and not necessarily one that optimizing the internal bitmap will help significantly.  It may well be that your swap cannot be used if a single allocation is in the same neighbourhood as the total RAM size.

Every file with nlink > 1 will need an additional 8 bytes of data, and the insert_icount_el() function reallocates this structure every 100 elements, so it can use AT MOST 1/2 of all memory before the new copy and the old one fill all available memory.

It would probably make sense to modify the internal icount structure to hold a 2-level tree of arrays of e.g. 8kB chunks, or other advanced data structure so that it doesn't force reallocation and average .51 memory copies of the WHOLE LIST on every insert.  This is probably doable with some light understanding of e2fsprogs, since the icount interface is well encapsulated, but it isn't something I have time for now.

If you are interested to hack/improve e2fsprogs I'd be willing to guide you, but if not I'd just suggest connecting this array to another node to run e2fsck, and consider spending the $200 needed to get a 64-bit system with a few GB of RAM.

Cheers, Andreas





