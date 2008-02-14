From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Thu, 14 Feb 2008 09:43:01 +0530
Message-ID: <20080214041300.GA7835@skywalker>
References: <1202923172.3508.3.camel@ext1.frec.bull.fr> <20080213203305.GE3029@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"cmm@us.ibm.com" <cmm@us.ibm.com>
To: Andreas Dilger <adilger@sun.com>,
	Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:46270 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753123AbYBNENJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2008 23:13:09 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1E4D6Zt007542
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 09:43:06 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1E4D6lK1069112
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 09:43:06 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1E4D549014308
	for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2008 04:13:06 GMT
Content-Disposition: inline
In-Reply-To: <20080213203305.GE3029@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 13, 2008 at 01:33:05PM -0700, Andreas Dilger wrote:
> On Feb 13, 2008  18:19 +0100, Valerie Clement wrote:
> > From: Valerie Clement <valerie.clement@bull.net>
> > 
> > With the flex_bg feature enabled, a large file creation oopses the
> > kernel.
> > The BUG_ON is:
> > 	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
> >
> > As the allocation of the bitmaps and the inode table can be done
> > outside the block group with flex_bg, this allows to allocate up to
> > EXT4_BLOCKS_PER_GROUP blocks in a group.
> 
> Caution is needed here.  In the past we were limited to BLOCKS_PER_GROUP()
> blocks per extent (32768 blocks at most, regardless of blocksize I think)
> but now an extent might be larger.
> 
> Can you please verify that the extent-length limits for "initialized" vs.
> "uninitialized" extents are being hit so that extents don't accidentally
> grow to be > 32768 blocks long and suddenly get marked as short uninitialized
> extents.


in ext4_ext_get_blocks we make sure the max blocks requested is not more
than EXT_INIT_MAX_LEN for initialized extent and EXT_UNINIT_MAX_LEN for
uninit extent. So mballoc always get block request less than this size.

After getting the request block when we try to insert the extent we try
to merge the extent with already existing one and there also we make
sure extent length doesn't overflow (ext4_can_extents_be_merged). So i
guess with respect to extent length we make sure we are safe.




> 
> Note that the assertion can still be hit if groups are created with fewer
> blocks, or with blocksize < 4096.  For example, if we have blocksize = 1024
> this gives BLOCKS_PER_GROUP=8192, but an extent can be up to 32768 blocks.
> 
> I think the right assertion is now:
> 
> 	BUG_ON(len > EXT4_INIT_MAX_LEN);
> 
> if FLEX_BG is active.  I'm not sure if we want to keep the stricter assertion:
> 
> 	BUG_ON(len > EXT4_HAS_INCOMPAT_FEATURE_FLEX_BG(sb) ? EXT4_INIT_MAX_LEN :
> 						EXT4_BLOCKS_PER_GROUP(sb));
> 

The first hunk in ext4_mb_mark_free_simple is called when generating the
buddy. The len there indicate that length of contiguous free blocks available in a
group. With Flex BG we can have upto EXT4_BLOCKS_PER_GROUP(sb). so i
guess the first hunk is correct. It is not checking for extent length
here.



> but it might be worthwhile at least initially, and I don't think the CPU cost
> is very high.
> 
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index b0f84b4..0275150 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -907,7 +907,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
> >  	unsigned short chunk;
> >  	unsigned short border;
> >  
> > -	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
> > +	BUG_ON(len > EXT4_BLOCKS_PER_GROUP(sb));
> >  
> >  	border = 2 << sb->s_blocksize_bits;
> >  
> > @@ -3286,7 +3286,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
> >  	}
> >  	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
> >  			start > ac->ac_o_ex.fe_logical);
> > -	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
> > +	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));

I am not sure about this. Here size is the normalized request len. 
Did we hit this BUG_ON ?


-aneesh
