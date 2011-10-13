From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 17/28] ext4: Calculate and verify checksums for htree
	nodes
Date: Thu, 13 Oct 2011 00:21:58 -0700
Message-ID: <20111013072158.GR12447@tux1.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075536.20506.13681.stgit@elm3c44.beaverton.ibm.com> <F6453844-06CC-4245-BB39-EBA4327D4C92@dilger.ca>
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
Received: from e37.co.us.ibm.com ([32.97.110.158]:55118 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1JMHVs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Oct 2011 03:21:48 -0400
Content-Disposition: inline
In-Reply-To: <F6453844-06CC-4245-BB39-EBA4327D4C92@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 12, 2011 at 05:27:29PM -0600, Andreas Dilger wrote:
> On 2011-10-08, at 1:55 AM, Darrick J. Wong wrote:
> > Calculate and verify the checksum for directory index tree (htree) node blocks.  The checksum is stored in the last 4 bytes of the htree block and requires the dx_entry array to stop 1 dx_entry short of the end of the block.
> > 
> > +/*
> > + * This goes at the end of each htree block.  If you want to use the
> > + * reserved field, you'll have to update the checksum code to include it.
> > + */
> > +struct dx_tail {
> > +	u32 reserved;
> > +	u32 checksum;	/* crc32c(uuid+inum+dirblock) */
> > +};
> 
> Why exclude the reserved field from the checksum?  That would mean that
> the checksum value will depend on whether the other feature is in use
> or not, which will make everything more complicated in the future.
> 
> Better to always set it to zero for now, and if it is used in the future
> then it can be set to whatever value is needed and the checksum code
> will remain the same in both the kernel and e2fsprogs.

As a minor speed optimization, the htree checksum only covers the fake dirent
structures, the htree block header, and header.count dx_entry structs, which
means that in the common case it won't come anywhere close to checksumming all
4096 bytes.  But you do make a compelling case to cover that reserved field
even if it's zero now.

> > +/* checksumming functions */
> > +static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
> > +					       struct ext4_dir_entry *dirent,
> > +					       int *offset)
> > +{
> > +	if (le16_to_cpu(dirent->rec_len) == EXT4_BLOCK_SIZE(inode->i_sb))
> > +		count_offset = 8;
> > +	else if (le16_to_cpu(dirent->rec_len) == 12) {
> > +		dp = (struct ext4_dir_entry *)(((void *)dirent) + 12);
> > +		if (le16_to_cpu(dp->rec_len) !=
> > +		    EXT4_BLOCK_SIZE(inode->i_sb) - 12)
> > +			return NULL;
> > +		root = (struct dx_root_info *)(((void *)dp + 12));
> > +		if (root->reserved_zero ||
> > +		    root->info_length != sizeof(struct dx_root_info))
> > +			return NULL;
> > +		count_offset = 32;
> > +	} else
> > +		return NULL;
> 
> (style) if one branch of an if-else has braces, they all should

Ok.

> > +static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
> > +{
> > +	struct dx_countlimit *c;
> > +	struct dx_tail *t;
> > +	int count_offset, limit, count;
> > +
> > +	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> 
> It would be nice to add some macros to clean up the feature flag checks
> (in a separate patch, but this long line reminded me of it):
> 
> #define EXT4_ROCOMPAT(sb, feature) \
> 	EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_ ## feature)
> 
> Then the code can be changed to use:
> 
> 	if (!EXT4_ROCOMPAT(inode->i_sb, METADATA_CSUM))
> 
> which is not only shorter and has a chance of fitting on one line, but
> also avoids the occasional hard-to-find bug that uses a mismatched mask
> and flag word, like:
> 
> 	if (!EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> 					EXT4_FEATURE_INCOMPAT_FLEX_BG)
> 
> With the helper macros, this would fail at compile time, because
> EXT4_FEATURE_ROCOMPAT_FLEX_BG does not exist.

Yes, that would make a nice (separate) cleanup patch.

--D
