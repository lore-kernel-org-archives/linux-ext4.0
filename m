From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 17/29] ext4: Better estimate credits needed for
 ext4_da_writepages()
Date: Tue, 7 May 2013 16:17:38 +0200
Message-ID: <20130507141738.GA3154@quack.suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
 <1365456754-29373-18-git-send-email-jack@suse.cz>
 <20130507063347.GA19271@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab3EGORm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 May 2013 10:17:42 -0400
Content-Disposition: inline
In-Reply-To: <20130507063347.GA19271@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 07-05-13 14:33:47, Zheng Liu wrote:
> On Mon, Apr 08, 2013 at 11:32:22PM +0200, Jan Kara wrote:
> > We limit the number of blocks written in a single loop of
> > ext4_da_writepages() to 64 when inode uses indirect blocks. That is
> > unnecessary as credit estimates for mapping logically continguous run of
> > blocks is rather low even for inode with indirect blocks. So just lift
> > this limitation and properly calculate the number of necessary credits.
> > 
> > This better credit estimate will also later allow us to always write at
> > least a single page in one iteration.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> A minor comment below.  Otherwise the patch looks good to me.
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
> 
> > ---
> >  fs/ext4/ext4.h    |    3 +-
> >  fs/ext4/extents.c |   16 ++++++--------
> >  fs/ext4/inode.c   |   58 ++++++++++++++++++++--------------------------------
> >  3 files changed, 30 insertions(+), 47 deletions(-)
> ...
> >  static int ext4_da_writepages_trans_blocks(struct inode *inode)
> >  {
> > -	int max_blocks = EXT4_I(inode)->i_reserved_data_blocks;
> > -
> > -	/*
> > -	 * With non-extent format the journal credit needed to
> > -	 * insert nrblocks contiguous block is dependent on
> > -	 * number of contiguous block. So we will limit
> > -	 * number of contiguous block to a sane value
> > -	 */
> > -	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) &&
> > -	    (max_blocks > EXT4_MAX_TRANS_DATA))
> > -		max_blocks = EXT4_MAX_TRANS_DATA;
> > +	int bpp = ext4_journal_blocks_per_page(inode);
> >  
> > -	return ext4_chunk_trans_blocks(inode, max_blocks);
> > +	return ext4_meta_trans_blocks(inode,
> > +				MAX_WRITEPAGES_EXTENT_LEN + bpp - 1, bpp);
> 
> FWIW, MAX_WRITEPAGES_EXTENT_LEN is defined at patch 18/29.  So after
> applied this patch, we will get a build error.  So that would be great
> if MAX_WRITEPAGES_EXTENT_LEN can be define in this commit.
  Good catch. Thanks! I've fixed that up.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
