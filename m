From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 15/28] ext4: Calculate and verify block bitmap checksum
Date: Mon, 7 Nov 2011 14:44:02 -0700
Message-ID: <EEB33371-CE71-4283-A5B1-E09083F08DCB@dilger.ca>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075522.20506.22239.stgit@elm3c44.beaverton.ibm.com> <AE869D1A-2A06-4849-8752-74924B0C05BD@dilger.ca> <20111013071631.GQ12447@tux1.beaverton.ibm.com> <20111107200008.GW12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
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
To: djwong@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111107200008.GW12447@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-11-07, at 1:00 PM, Darrick J. Wong wrote:
> On Thu, Oct 13, 2011 at 12:16:31AM -0700, Darrick J. Wong wrote:
>> On Wed, Oct 12, 2011 at 06:00:40PM -0600, Andreas Dilger wrote:
>>> I've been thinking a while that we should add per-group error flags
>>> for the block and inode bitmaps.  That way, if we detect errors with
>>> either one, we can set the flag in the group descriptor and avoid
>>> using it for any allocations in the future.  Otherwise, we try to
>>> read the bitmap in repeatedly.
>> 
>> I think there's some code in ext4 somewhere that does that.  I also wonder if
>> the possibility that we're seeing a transient corruption error is worth
>> rechecking the block until it fails?  (I suspect not, but I decided to throw
>> that out there anyway.)
> 
> There's a bit of code in ext4_init_block_bitmap that makes a block group
> unwritable if the bg checksum fails to verify:
> 
> /* If checksum is bad mark all blocks used to prevent allocation
> * essentially implementing a per-group read-only flag. */
> if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
> 	ext4_error(sb, "Checksum bad for group %u",
> 			block_group);
> 	ext4_free_blks_set(sb, gdp, 0);
> 	ext4_free_inodes_set(sb, gdp, 0);
> 	ext4_itable_unused_set(sb, gdp, 0);
> 	memset(bh->b_data, 0xff, sb->s_blocksize);
> 	ext4_block_bitmap_csum_set(sb, block_group, gdp, bh,
> 				   EXT4_BLOCKS_PER_GROUP(sb) /
> 				   8);
> 	return 0;
> }
> 
> Do people think that doing this in the event of a block/inode bitmap checksum
> failure is a good idea?

For me, yes.  The sanity checks we do on the block bitmaps are only very basic
(e.g. bits for bitmaps themselves are set, for inode table).  Blocking any
allocation from a single group with a bad checksum is not harmful in the long
term, and can avoid an explosion of corruption if blocks would otherwise be allocated multiple times.

Cheers, Andreas
