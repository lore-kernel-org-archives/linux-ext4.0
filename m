From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: group descriptor contents and LAZY_BG
Date: Mon, 26 Mar 2007 01:03:38 -0600
Message-ID: <20070326070338.GA13762@schatzie.adilger.int>
References: <20070324214056.GL5967@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Girish Shilamkar <girish@linsyssoft.com>,
	Kalpak Shah <kalpak@clusterfs.com>
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:38223 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640AbXCZHDk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Mar 2007 03:03:40 -0400
Content-Disposition: inline
In-Reply-To: <20070324214056.GL5967@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mar 24, 2007  15:40 -0600, Andreas Dilger wrote:
> For the GDT_CSUM feature, we are using the LAZY_BG feature to not initialize
> the bitmaps and inode table.  However, setting the bg_free_*_count to zero
> is troublesome because it means we always need to check the GDT_CSUM feature
> flag to know whether a group actually has free blocks/inodes, and e2fsck
> is also getting confused about the number of free blocks/inodes in the groups
> and filesystem (we have to have a double accounting for "real" free blocks
> and "uninitialized" free blocks.
> 
> What do you think for the GDT_CSUM feature that we initialize the group
> descriptors as if the group had actually been formatted?  I think our
> use of the LAZY_BG feature is actually misguided - while they share some
> components (e.g. UNINIT flags, mke2fs code, some e2fsck code), since the
> GDT_CSUM feature is RO_COMPAT there isn't much reason to even enable
> LAZY_BG at format time...

FYI, I changed the patch to just make bg_itable_unused a hint for e2fsck
(leaving the meaning of the other bg_* fields the same as a normal fs)
and this has simplified the e2fsprogs and kernel code a lot.

I also had mke2fs deal differently with GDT_CSUM compared to LAZY_BG
when setting the bg_free_{blocks,inodes}_count.  With LAZY_BG the
*_UNINIT flag also set the corresponding bg_free_*_count values to zero,
while if GDT_CSUM is set then they are left as they would otherwise be.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
