From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] e2fsprogs: New bitmap and inode table allocation for
 FLEX_BG v2
Date: Mon, 31 Mar 2008 11:41:08 -0500
Message-ID: <20080331114108.5710ab1e@gara.konoha.net>
References: <20080213204750.5666a560@gara>
	<20080324134650.GA13621@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@MIT.EDU>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60922 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbYCaQlT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 12:41:19 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m2VGfHKc019988
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2008 12:41:17 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2VGfH5E247820
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2008 12:41:17 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2VGfGDw023115
	for <linux-ext4@vger.kernel.org>; Mon, 31 Mar 2008 12:41:16 -0400
In-Reply-To: <20080324134650.GA13621@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 24 Mar 2008 09:46:50 -0400
Theodore Tso <tytso@MIT.EDU> wrote:
> This turns out to be a kludge whose short comings show other problems.
> The real problem is that most of the libext2fs isn't BLOCK_UNINIT
> aware.  So for example, if debugfs is used to write a file into the
> filesystem, and the block group doesn't have an initialized bitmap,
> the Wrong Thing will happen.  More to the point, if you use mke2fs to
> a 1k blocksize filesystem, and the journal is bigger than 16 megs, (or
> with a 4k blocksize filesystem, if the journal is bigger than 512
> megs), you could easily end up allocating the journal into a block
> group with BG_BLOCK_UNINIT.  Oops.
> 
> This wasn't that much of a big deal since up until now lazy_bg was
> only used for debugging really big filesystems, and not much else.  It
> was a quick hack for debugging purposes only.  But given that
> uninititalized blockgroups are intended for more general use, we have
> to make sure all of these corner cases are handled correctly.
> 
> Just looking at it quickly, it seems like the right thing to do is
> split setup_lazy_bg() into two parts.  The first part sets
> EXT2_BG_BLOCK_UNINIT for all block groups, and then we modify the
> block allocation functions in lib/ext2fs to clear the BLOCK_UNINIT
> flag --- and then later on, we update the bg_free_blocks_count and
> s_free_blocks_count for the lazy_bg case.  

It seems that libext2fs is BLOCK_UNINIT aware since the only time we
would need to update the BLOCK_UNINIT flag is if we update the group
descriptors bg_free_blocks_count.  In ext2fs_block_alloc_stats(), the
EXT2_BG_BLOCK_UNINIT flag is unset when this happens.  Having said
that, I think there is a bug in this code if we do not use GDT_CSUM
since setup_lazy_bg() would set bg_free_block_count to zero and this
routine does nothing to set the right number of free blocks.  If
GDT_CSUM is not used, s_free_blocks_count would also need to be updated
as well.

Other than fixing ext2fs_block_alloc_stats(), I don't see anywhere else
in libext2fs where we would need to add awareness to unset the 
BLOCK_UNINIT flag.

-JRS
