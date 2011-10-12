From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 11/28] ext4: Calculate and verify inode checksums
Date: Wed, 12 Oct 2011 14:03:42 -0700
Message-ID: <20111012210342.GO12447@tux1.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075456.20506.47319.stgit@elm3c44.beaverton.ibm.com> <1CCC75F1-41BE-49E9-8A03-372FC76E0202@dilger.ca>
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
In-Reply-To: <1CCC75F1-41BE-49E9-8A03-372FC76E0202@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 12, 2011 at 12:45:01PM -0700, Andreas Dilger wrote:
> On 2011-10-08, at 12:54 AM, Darrick J. Wong wrote:
> > This patch introduces to ext4 the ability to calculate and verify inode
> > checksums.  This requires the use of a new ro compatibility flag and some
> > accompanying e2fsprogs patches to provide the relevant features in tune2fs and
> > e2fsck.
> > 
> > +static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
> > +			      struct ext4_inode_info *ei)
> > +{
> > +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> > +	__u16 crc_lo;
> > +	__u16 crc_hi = 0;
> > +	__u32 crc;
> > +
> > +	crc_lo = raw->i_checksum_lo;
> > +	raw->i_checksum_lo = 0;
> > +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> > +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
> > +		crc_hi = raw->i_checksum_hi;
> > +		raw->i_checksum_hi = 0;
> > +	}
> > +
> > +	crc = ext4_chksum(sbi, ei->i_uuid_inum_crc, (__u8 *)raw,
> > +			  EXT4_INODE_SIZE(inode->i_sb));
> > +
> > +	raw->i_checksum_lo = crc_lo;
> > +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> > +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
> > +		raw->i_checksum_hi = crc_hi;
> > +
> > +	return crc;
> > +}
> 
> This computes both the _lo and _hi parts of the checksum and overwrites what
> is in the inode...

I don't follow your logic ... for the _lo component, first I save the old
i_checksum_lo contents in crc_lo.  Then I stuff zero into i_checksum_lo.  Next
I perform the checksum computation (with the checksum field effectively "zero")
and put the results into crc.  Then I copy whatever I saved in crc_lo back into
i_checksum_lo.

crc_lo, crc_hi, and crc are three separate variables, and neither crc_lo nor
crc_hi are ever assigned any part of crc.  Therefore crc_lo and crc_hi should
always contain the old checksum contents.

Did I miss something?  Afaict the contents of raw should be the same before and
after the call to ext4_inode_csum(), but maybe I've been looking at this too
long. :)

> > +static int ext4_inode_csum_verify(struct inode *inode, struct ext4_inode *raw,
> > +				  struct ext4_inode_info *ei)
> > +{
> > +	__u32 provided, calculated;
> > +
> > +	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> > +	    cpu_to_le32(EXT4_OS_LINUX) ||
> > +	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +		return 1;
> > +
> > +	provided = le16_to_cpu(raw->i_checksum_lo);
> > +	calculated = ext4_inode_csum(inode, raw, ei);
> 
> This only saves the _lo part of the checksum before computing the new
> checksum (which overwrites both _lo and _hi fields), so the _hi part
> of the checksum is never properly validated below.
> 
> > +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> > +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
> > +		provided |= ((__u32)le16_to_cpu(raw->i_checksum_hi)) << 16;
> 
> This should be moved up to save _hi before calling ext4_inode_csum().
> 
> > +	else
> > +		calculated &= 0xFFFF;
> > +
> > +	return provided == calculated;
> > +}
> 
> > +static void ext4_inode_csum_set(struct inode *inode, struct ext4_inode *raw,
> > +				struct ext4_inode_info *ei)
> > +{
> > +	__u32 crc;
> > +
> > +	if (EXT4_SB(inode->i_sb)->s_es->s_creator_os !=
> > +	    cpu_to_le32(EXT4_OS_LINUX) ||
> > +	    !EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +		return;
> > +
> > +	crc = ext4_inode_csum(inode, raw, ei);
> > +	raw->i_checksum_lo = cpu_to_le16(crc & 0xFFFF);
> > +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
> > +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
> > +		raw->i_checksum_hi = cpu_to_le16(crc >> 16);
> 
> What is the point of storing the returned crc into raw->i_checksum_lo
> and raw->i_checksum_hi, if this is done internal to ext4_inode_csum()
> already?

It shouldn't be doing that (see above).

> Also, would it be better to call the temporary variable "csum" instead
> of "crc", since we may use something other than crc32c as the hash
> function in the future.

I suppose.

--D

