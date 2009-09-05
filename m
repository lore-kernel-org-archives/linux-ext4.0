From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC V2] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Sat, 05 Sep 2009 13:16:38 -0500
Message-ID: <4AA2AB06.6040809@redhat.com>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com> <20090905164535.GL4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([209.173.210.139]:13162 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbZIESQi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Sep 2009 14:16:38 -0400
In-Reply-To: <20090905164535.GL4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On Sep 04, 2009  22:21 -0500, Eric Sandeen wrote:
>> Today, the ext4 allocator will happily allocate blocks past
>> 232 for indirect-block files, which results in the block
>> numbers getting truncated, and corruption ensues.
>>
>> This patch limits such allocations to < 2^32, and adds
>> WARN_ONs (maybe should be BUG_ONs) if we do get blocks
>> larger than that.
> 
> Eric, thanks for making the patch.
> 
>> This should address RH Bug 519471, ext4 bitmap allocator must limit 
>> blocks to < 2^32
>>
>> * ext4_find_goal() is modified to choose a goal < UINT_MAX,
>>  so that our starting point is in an acceptable range.
>>
>> * ext4_xattr_block_set() is modified such that the goal block
>>  is < UINT_MAX, as above.
> 
> Using UINT_MAX probably isn't wholly safe, as I know of systems
> that have e.g. 64-bit ints (though I guess none that have Linux
> kernel ports).  It should use (u32)~0 or ((1 << 32) - 1) directly.
> 
>> Perhaps an ext4-specific #define would be better than UINT_MAX?
> 
> I think yes, since we know the maximum value is tied specifically
> to the u32 indirect block pointers, and not necessarily to an "int".

yep, I had considered that, I should have just done it :)  (esp 
considering the patch I sent a while back to get rid of similar things) :)

>> static ext4_fsblk_t ext4_find_goal(struct inode *inode, ext4_lblk_t block,
>> 				   Indirect *partial)
>> {
>> +	goal = ext4_find_near(inode, partial);
>> +	goal = goal % UINT_MAX;
>> +	return goal;
> 
> Using "% UINT_MAX" here will result in a 64-bit division on 32-bit
> platforms, since ext4_fsblk_t is declared as an unsigned long long.
> This should instead be "(u32)" or "& 0xffffffff".

whoops good point.  I wasn't thinking of 32-bit boxes, thinking they 
can't go past 16T but for smaller blocks we still could go past 2^32 
blocks... and it is a 64-bit modulo regardless.

>> @@ -1943,6 +1943,11 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
>> +	/* non-extent files are limited to low blocks/groups */
>> +	if (!(EXT4_I(ac->ac_inode)->i_flags & EXT4_EXTENTS_FL))
>> +		ngroups = min_t(unsigned long, ngroups,
>> +				(UINT_MAX / EXT4_BLOCKS_PER_GROUP(sb)));
> 
> Since EXT4_BLOCKS_PER_GROUP() is a run-time variable, but is constant
> for the life of the filesystem, this could be computed once and stored
> in the superblock?

ok.

>> +++ b/fs/ext4/xattr.c
>> @@ -810,12 +810,22 @@ inserted:
>> +			if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
>> +				goal = goal % UINT_MAX;
> 
> As above.

Thanks for the review, will fix those up.

-Eric

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

