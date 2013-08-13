From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] e2fsprogs: Don't report uninit extents past EOF invalid
Date: Tue, 13 Aug 2013 12:31:12 -0400
Message-ID: <20130813163112.GA4990@wallace>
References: <20130721202849.GB2331@wallace>
 <52096DF5.9090700@redhat.com>
 <52096F9E.3060801@redhat.com>
 <52097153.4000600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ye0-f175.google.com ([209.85.213.175]:36711 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992Ab3HMQbS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Aug 2013 12:31:18 -0400
Received: by mail-ye0-f175.google.com with SMTP id m9so2389510yen.6
        for <linux-ext4@vger.kernel.org>; Tue, 13 Aug 2013 09:31:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <52097153.4000600@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Eric Sandeen <sandeen@redhat.com>:
> On 8/12/13 6:28 PM, Eric Sandeen wrote:
> > On 8/12/13 6:21 PM, Eric Sandeen wrote:
> >> On 7/21/13 3:28 PM, Eric Whitney wrote:
> >>> Commit d3f32c2db8 caused e2fsck misbehavior during xfstests runs.
> >>> It reported that uninitialized extents created by fallocate() at
> >>> the end of file with the FALLOC_FL_KEEP_SIZE flag were invalid.
> >>> Because FALLOC_FL_KEEP_SIZE does not increase the file size when
> >>> an extent is fallocated, an uninitialized extent can legally contain
> >>> blocks past the end of file.
> >>>
> >>> The information reported by ext2fs_extent_get() and used by the commit
> >>> to determine legal extent ranges is limited by the value of i_size
> >>> (determines end_blk in the root extent index), so block values greater
> >>> than that containing i_size were reported as invalid.
> >>>
> >>> To fix this, filter out possible invalid extent candidates if they are
> >>> uninitialized and extend past the block containing the end of file.
> >>>
> >>> Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> >>> ---
> >>>  e2fsck/pass1.c      |    4 +++-
> >>>  lib/ext2fs/ext2fs.h |    1 +
> >>>  lib/ext2fs/extent.c |    1 +
> >>>  3 files changed, 5 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> >>> index ba6025b..b84b0d0 100644
> >>> --- a/e2fsck/pass1.c
> >>> +++ b/e2fsck/pass1.c
> >>> @@ -1892,7 +1892,9 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
> >>>  			problem = PR_1_EXTENT_BAD_START_BLK;
> >>>  		else if (extent.e_lblk < start_block)
> >>>  			problem = PR_1_OUT_OF_ORDER_EXTENTS;
> >>> -		else if (end_block && last_lblk > end_block)
> >>> +		else if ((end_block && last_lblk > end_block) &&
> >>> +			 (!(extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT &&
> >>> +			    last_lblk > info.eof_blk - 1)))
> >>>  			problem = PR_1_EXTENT_END_OUT_OF_BOUNDS;
> >>>  		else if (is_leaf && extent.e_len == 0)
> >>>  			problem = PR_1_EXTENT_LENGTH_ZERO;
> >>> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> >>> index 311ceda..85f2ac8 100644
> >>> --- a/lib/ext2fs/ext2fs.h
> >>> +++ b/lib/ext2fs/ext2fs.h
> >>> @@ -409,6 +409,7 @@ struct ext2_extent_info {
> >>>  	int		bytes_avail;
> >>>  	blk64_t		max_lblk;
> >>>  	blk64_t		max_pblk;
> >>> +	blk64_t         eof_blk;
> >>>  	__u32		max_len;
> >>>  	__u32		max_uninit_len;
> >>>  };
> >>
> >> I just realized, this affects the ABI, doesn't it?  Hm.
> >>
> >> As a hack-around, can probably just use ehandle->path[0].end_blk directly
> >> in scan_extent_node and stash eof_blk locally?
> > 
> > Nope, we can't crack an extent handle, it's an opaque type.
> > 
> > Ned some V2 interfaces now?  :(
> > 
> 
> or maybe just:
> 
> +       eof_blk = (EXT2_I_SIZE(pctx->inode) + ctx->fs->blocksize - 1) >>
> +                  EXT2_BLOCK_SIZE_BITS(ctx->fs->super);
> 
> unless that's too ugly.
> 

Clearly, I wasn't thinking about the ABI at all - thanks for pointing out
that misstep.

So, I'd like to withdraw that patch, please, and will post a V2 in a bit.
Computing the eof_blk in that manner is better than an initial patch I had
that worked but which was pretty ugly.

Thanks,
Eric

