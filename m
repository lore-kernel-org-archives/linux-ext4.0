From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC V2] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Sat, 05 Sep 2009 18:45:35 +0200
Message-ID: <20090905164535.GL4197@webber.adilger.int>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56103 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbZIEQpg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Sep 2009 12:45:36 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n85GjckV029760
	for <linux-ext4@vger.kernel.org>; Sat, 5 Sep 2009 09:45:38 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPI00900BP2MM00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Sat,
 05 Sep 2009 09:45:38 -0700 (PDT)
In-reply-to: <4AA1D94F.8060703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 04, 2009  22:21 -0500, Eric Sandeen wrote:
> Today, the ext4 allocator will happily allocate blocks past
> 232 for indirect-block files, which results in the block
> numbers getting truncated, and corruption ensues.
>
> This patch limits such allocations to < 2^32, and adds
> WARN_ONs (maybe should be BUG_ONs) if we do get blocks
> larger than that.

Eric, thanks for making the patch.

> This should address RH Bug 519471, ext4 bitmap allocator must limit 
> blocks to < 2^32
>
> * ext4_find_goal() is modified to choose a goal < UINT_MAX,
>  so that our starting point is in an acceptable range.
>
> * ext4_xattr_block_set() is modified such that the goal block
>  is < UINT_MAX, as above.

Using UINT_MAX probably isn't wholly safe, as I know of systems
that have e.g. 64-bit ints (though I guess none that have Linux
kernel ports).  It should use (u32)~0 or ((1 << 32) - 1) directly.

> Perhaps an ext4-specific #define would be better than UINT_MAX?

I think yes, since we know the maximum value is tied specifically
to the u32 indirect block pointers, and not necessarily to an "int".

> static ext4_fsblk_t ext4_find_goal(struct inode *inode, ext4_lblk_t block,
> 				   Indirect *partial)
> {
> +	goal = ext4_find_near(inode, partial);
> +	goal = goal % UINT_MAX;
> +	return goal;

Using "% UINT_MAX" here will result in a 64-bit division on 32-bit
platforms, since ext4_fsblk_t is declared as an unsigned long long.
This should instead be "(u32)" or "& 0xffffffff".

> @@ -1943,6 +1943,11 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
> +	/* non-extent files are limited to low blocks/groups */
> +	if (!(EXT4_I(ac->ac_inode)->i_flags & EXT4_EXTENTS_FL))
> +		ngroups = min_t(unsigned long, ngroups,
> +				(UINT_MAX / EXT4_BLOCKS_PER_GROUP(sb)));

Since EXT4_BLOCKS_PER_GROUP() is a run-time variable, but is constant
for the life of the filesystem, this could be computed once and stored
in the superblock?

> +++ b/fs/ext4/xattr.c
> @@ -810,12 +810,22 @@ inserted:
> +			if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> +				goal = goal % UINT_MAX;

As above.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

