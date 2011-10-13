From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 15/28] ext4: Calculate and verify block bitmap checksum
Date: Thu, 13 Oct 2011 00:16:31 -0700
Message-ID: <20111013071631.GQ12447@tux1.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075522.20506.22239.stgit@elm3c44.beaverton.ibm.com> <AE869D1A-2A06-4849-8752-74924B0C05BD@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AE869D1A-2A06-4849-8752-74924B0C05BD@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 12, 2011 at 06:00:40PM -0600, Andreas Dilger wrote:
> On 2011-10-08, at 1:55 AM, Darrick J. Wong wrote:
> > Compute and verify the checksum of the block bitmap; this checksum is
> > stored in the block group descriptor.
> > 
> > @@ -353,11 +360,26 @@ ext4_read_block_bitmap(struct super_block *sb, ext4_group_t block_group)
> > 	/*
> > 	 * file system mounted not to panic on error,
> > +	 * -EIO with corrupt bitmap
> > 	 */
> > +	ext4_lock_group(sb, block_group);
> > +	if (!ext4_valid_block_bitmap(sb, desc, block_group, bh) ||
> > +	    !ext4_block_bitmap_csum_verify(sb, block_group, desc, bh,
> > +					   EXT4_BLOCKS_PER_GROUP(sb) / 8)) {
> > +		ext4_unlock_group(sb, block_group);
> > +		put_bh(bh);
> > +		ext4_error(sb, "Corrupt block bitmap - block_group = %u, "
> > +			   "block_bitmap = %llu", block_group, bitmap_blk);
> > +		return NULL;
> > +	}
> > +	ext4_unlock_group(sb, block_group);
> > +	set_buffer_verified(bh);
> 
> I've been thinking a while that we should add per-group error flags
> for the block and inode bitmaps.  That way, if we detect errors with
> either one, we can set the flag in the group descriptor and avoid
> using it for any allocations in the future.  Otherwise, we try to
> read the bitmap in repeatedly.

I think there's some code in ext4 somewhere that does that.  I also wonder if
the possibility that we're seeing a transient corruption error is worth
rechecking the block until it fails?  (I suspect not, but I decided to throw
that out there anyway.)

> > @@ -803,6 +842,11 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
> > 	if (groups_per_page == 0)
> > 		groups_per_page = 1;
> > 
> > +	csd = kzalloc(sizeof(struct ext4_csum_data) * groups_per_page,
> > +		      GFP_NOFS);
> > +	if (csd == NULL)
> > +		goto out;
> > +
> > 	/* allocate buffer_heads to read bitmaps */
> > 	if (groups_per_page > 1) {
> > 		err = -ENOMEM;
> > @@ -880,22 +924,25 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
> > 		 * get set with buffer lock held.
> > 		 */
> > 		set_bitmap_uptodate(bh[i]);
> > -		bh[i]->b_end_io = end_buffer_read_sync;
> > +		csd[i].cd_sb = sb;
> > +		csd[i].cd_group = first_group + i;
> > +		bh[i]->b_private = csd + i;
> > +		bh[i]->b_end_io = ext4_end_buffer_read_sync;
> 
> It seems to be allocating this extra csd[] and calling the more complex
> ext4_end_buffer_read_sync() callback regardless of whether the checksum
> code is enabled or not.  Would it be better to only set the custom
> callback if we need to verify the checksum?

Yep, we could go straight to end_buffer_read_sync in the no-csum case.

--D
