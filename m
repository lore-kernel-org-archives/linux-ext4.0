From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 15/28] ext4: Calculate and verify block bitmap checksum
Date: Wed, 9 Nov 2011 16:57:12 -0800
Message-ID: <20111110005656.GX12447@tux1.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075522.20506.22239.stgit@elm3c44.beaverton.ibm.com> <AE869D1A-2A06-4849-8752-74924B0C05BD@dilger.ca> <20111013071631.GQ12447@tux1.beaverton.ibm.com> <20111107200008.GW12447@tux1.beaverton.ibm.com> <EEB33371-CE71-4283-A5B1-E09083F08DCB@dilger.ca>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35234 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab1KJA5D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Nov 2011 19:57:03 -0500
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 9 Nov 2011 19:57:02 -0500
Content-Disposition: inline
In-Reply-To: <EEB33371-CE71-4283-A5B1-E09083F08DCB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 07, 2011 at 02:44:02PM -0700, Andreas Dilger wrote:
> On 2011-11-07, at 1:00 PM, Darrick J. Wong wrote:
> > On Thu, Oct 13, 2011 at 12:16:31AM -0700, Darrick J. Wong wrote:
> >> On Wed, Oct 12, 2011 at 06:00:40PM -0600, Andreas Dilger wrote:
> >>> I've been thinking a while that we should add per-group error flags
> >>> for the block and inode bitmaps.  That way, if we detect errors with
> >>> either one, we can set the flag in the group descriptor and avoid
> >>> using it for any allocations in the future.  Otherwise, we try to
> >>> read the bitmap in repeatedly.
> >> 
> >> I think there's some code in ext4 somewhere that does that.  I also wonder if
> >> the possibility that we're seeing a transient corruption error is worth
> >> rechecking the block until it fails?  (I suspect not, but I decided to throw
> >> that out there anyway.)
> > 
> > There's a bit of code in ext4_init_block_bitmap that makes a block group
> > unwritable if the bg checksum fails to verify:
> > 
> > /* If checksum is bad mark all blocks used to prevent allocation
> > * essentially implementing a per-group read-only flag. */
> > if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
> > 	ext4_error(sb, "Checksum bad for group %u",
> > 			block_group);
> > 	ext4_free_blks_set(sb, gdp, 0);
> > 	ext4_free_inodes_set(sb, gdp, 0);
> > 	ext4_itable_unused_set(sb, gdp, 0);
> > 	memset(bh->b_data, 0xff, sb->s_blocksize);
> > 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
> > 				   EXT4_BLOCKS_PER_GROUP(sb) /
> > 				   8);
> > 	return 0;
> > }
> > 
> > Do people think that doing this in the event of a block/inode bitmap checksum
> > failure is a good idea?
> 
> For me, yes.  The sanity checks we do on the block bitmaps are only very
> basic (e.g. bits for bitmaps themselves are set, for inode table).  Blocking
> any allocation from a single group with a bad checksum is not harmful in the
> long term, and can avoid an explosion of corruption if blocks would otherwise
> be allocated multiple times.

On second thought, let's see what happens with groups that fail checksums ...
it seems that ext4_check_descriptors() fails the mount in the event of a group
descriptor failing checksum.  Both ext4_read_inode_bitmap() and
ext4_read_block_bitmap() return NULL if the respective bitmap fails checksum.
It looks like most of ext4's block {de,}allocate functions will fail on NULL
bitmap pointer, so it shouldn't be possible to allocate (or deallocate) from a
broken group.

There is one small deficiency: we need an explicit flag that marks the group
dead.  That way if either bitmap fails checksum, the other _bitmap_read()
function will know to just return NULL, and the group becomes totally frozen to
allocation activity.

I think ext4_new_inode need to be taught to continue scanning groups if it
encounters a "dead" group?  I'm not sure yet if the same thing needs to be
applied to the block allocation code.

I'm actually wondering how it is that a group could pass checksum verification
at mount time but fail it later, which is what that code snippet seems designed
to catch.  Maybe something related to online resize?   Either way, I'm now
wondering if we really need something like that for the simple case of bitmaps
failing checksum.  I think we're already covered, but maybe I missed something?

--D
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

