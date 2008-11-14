From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext2/ext3: allocate ->s_blockgroup_lock separately to
	avoid wasting space
Date: Fri, 14 Nov 2008 14:26:06 -0700
Message-ID: <20081114212606.GA16005@webber.adilger.int>
References: <Pine.LNX.4.64.0811141115100.29826@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, cl@linux-foundation.org,
	mpm@selenic.com, eduard.munteanu@linux360.ro
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61813 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYKNV02 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 16:26:28 -0500
In-reply-to: <Pine.LNX.4.64.0811141115100.29826@melkki.cs.Helsinki.FI>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 14, 2008  11:17 +0200, Pekka J Enberg wrote:
> As spotted by kmemtrace, struct ext2_sb_info is 17024 bytes and ext3_sb_info is
> 17152 bytes on 64-bit which makes them a very bad fit for SLAB allocators. In
> fact, both allocations are round up to the next available page size of 
> order 3 which is 32 KB.
> 
> The culprit if the wasted memory is the ->s_blockgroup_lock which can be as
> big as 16 KB when CONFIG_NR_CPUS is set to 32. As struct blockgroup_lock is a
> perfect fit for order 2 page in the worst case, allocate ->s_blockgroup_lock
> separately to avoid wasting space.
> 
> The change shrinks struct ext2_sb_info to 592 bytes and struct ext3_sb_info to
> 640 bytes which fits into a 1024 byte slab cache so now we allocate 16 KB + 1
> KB instead of 32 KB saving 15 KB of memory!
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

This looks very reasonable, with some minor comments below.
Could you please also include a patch for ext4.  Also, Andrew prefers that
the patches for ext2/ext3/ext4 are in separate emails.

> --- a/include/linux/blockgroup_lock.h
> +++ b/include/linux/blockgroup_lock.h
>  #define sb_bgl_lock(sb, block_group) \
> -	(&(sb)->s_blockgroup_lock.locks[(block_group) & (NR_BG_LOCKS-1)].lock)
> +	(&(sb)->s_blockgroup_lock->locks[(block_group) & (NR_BG_LOCKS-1)].lock)

How the struct is allocated seems like an implementation detail that doesn't
belong in blockgroup_lock.h at all, because "sb" is not "struct superblock"
but rather "struct ext[23]_sb_info".  In fact, changing this without also
patching ext4 would cause ext4 to break.

I would suggest to change this to take the s_blockgroup_lock as a parameter,

#define bgl_lock_ptr(bgl, block_group)
	(bgl->locks[(block_group) & (NR_BG_LOCKS - 1)].lock)

and then in ext[234]_fs_sb.h add a new helper in the same (first) patch:

#define sb_bgl_lock(sbi, block_group)
	bgl_lock_ptr(&sbi->s_blockgroup_lock, block_group)

and remove sb_bgl_lock() from blockgroup_lock.h entirely.  As part of the
later patches to change the s_blockgroup_lock allocations for each of
ext[234] this changes in ext[234]_fs_sb.h to:

#define sb_bgl_lock(sbi, block_group)
	bgl_lock_ptr(sbi->s_blockgroup_lock, block_group)


This allows each of the later patches to be landed separately without
breaking the build.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

