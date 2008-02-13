From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Wed, 13 Feb 2008 13:33:05 -0700
Message-ID: <20080213203305.GE3029@webber.adilger.int>
References: <1202923172.3508.3.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"cmm@us.ibm.com" <cmm@us.ibm.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49356 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154AbYBMUdJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2008 15:33:09 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1DKX8Rp017187
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2008 12:33:08 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JW700A0127R3800@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 13 Feb 2008 12:33:08 -0800 (PST)
In-reply-to: <1202923172.3508.3.camel@ext1.frec.bull.fr>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 13, 2008  18:19 +0100, Valerie Clement wrote:
> From: Valerie Clement <valerie.clement@bull.net>
> 
> With the flex_bg feature enabled, a large file creation oopses the
> kernel.
> The BUG_ON is:
> 	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
>
> As the allocation of the bitmaps and the inode table can be done
> outside the block group with flex_bg, this allows to allocate up to
> EXT4_BLOCKS_PER_GROUP blocks in a group.

Caution is needed here.  In the past we were limited to BLOCKS_PER_GROUP()
blocks per extent (32768 blocks at most, regardless of blocksize I think)
but now an extent might be larger.

Can you please verify that the extent-length limits for "initialized" vs.
"uninitialized" extents are being hit so that extents don't accidentally
grow to be > 32768 blocks long and suddenly get marked as short uninitialized
extents.

Note that the assertion can still be hit if groups are created with fewer
blocks, or with blocksize < 4096.  For example, if we have blocksize = 1024
this gives BLOCKS_PER_GROUP=8192, but an extent can be up to 32768 blocks.

I think the right assertion is now:

	BUG_ON(len > EXT4_INIT_MAX_LEN);

if FLEX_BG is active.  I'm not sure if we want to keep the stricter assertion:

	BUG_ON(len > EXT4_HAS_INCOMPAT_FEATURE_FLEX_BG(sb) ? EXT4_INIT_MAX_LEN :
						EXT4_BLOCKS_PER_GROUP(sb));

but it might be worthwhile at least initially, and I don't think the CPU cost
is very high.

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index b0f84b4..0275150 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -907,7 +907,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
>  	unsigned short chunk;
>  	unsigned short border;
>  
> -	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
> +	BUG_ON(len > EXT4_BLOCKS_PER_GROUP(sb));
>  
>  	border = 2 << sb->s_blocksize_bits;
>  
> @@ -3286,7 +3286,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>  	}
>  	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
>  			start > ac->ac_o_ex.fe_logical);
> -	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> +	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));

Please separate this into two BUG_ON() statements, so it is clear which
one is being hit.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
