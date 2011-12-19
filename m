From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 04/51] libext2fs: Add inode checksum support
Date: Mon, 19 Dec 2011 12:05:03 -0800
Message-ID: <20111219200503.GK8233@tux1.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011343.20947.52860.stgit@elm3c44.beaverton.ibm.com> <4CD3617E-A647-4CAF-9C35-DF24656CB440@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34547 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1LSUFk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 15:05:40 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 19 Dec 2011 15:05:39 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBJK56bd3285230
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 15:05:07 -0500
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBJK53VZ031923
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 13:05:05 -0700
Content-Disposition: inline
In-Reply-To: <4CD3617E-A647-4CAF-9C35-DF24656CB440@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 19, 2011 at 03:12:03PM +0100, Andreas Dilger wrote:
> On 2011-12-13, at 7:13 PM, Darrick J. Wong wrote:
> > diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
> > index 596923e..1f7c641 100644
> > --- a/lib/ext2fs/csum.c
> > +++ b/lib/ext2fs/csum.c
> > @@ -30,6 +30,89 @@
> > #define STATIC static
> > #endif
> > 
> > +static errcode_t ext2fs_inode_csum(ext2_filsys fs, ext2_ino_t inum,
> > +			       struct ext2_inode_large *inode,
> > +			       __u32 *crc, int has_hi)
> > +{
> > +	__u32 ncrc;
> 
> Why use "ncrc" in this function instead of just using "*crc" directly?
> 
> > +	struct ext2_inode_large *desc = inode;
> > +	size_t size = fs->super->s_inode_size;
> > +	__u16 old_lo;
> > +	__u16 old_hi = 0;
> > +	errcode_t retval = 0;
> 
> Also, it seems "retval" isn't useful, since it is always 0, which can
> be returned directly at the end.

In the old days it wasn't automatic that retval is always 0, therefore I
allocated a temporary ncrc in case the function failed.  Since that no longer
happens and ext2fs_inode_csum is a static function now, I will undo all
that.

> > +
> > +	old_lo = inode->i_checksum_lo;
> > +	inode->i_checksum_lo = 0;
> > +	if (has_hi) {
> > +		old_hi = inode->i_checksum_hi;
> > +		inode->i_checksum_hi = 0;
> > +	}
> > +
> > +	inum = ext2fs_cpu_to_le32(inum);
> > +	ncrc = ext2fs_crc32c_le(~0, fs->super->s_uuid,
> > +				sizeof(fs->super->s_uuid));
> > +	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)&inum, sizeof(inum));
> > +	ncrc = ext2fs_crc32c_le(ncrc, (unsigned char *)desc, size);
> > +	*crc = ncrc;
> > +
> > +	inode->i_checksum_lo = old_lo;
> > +	if (has_hi)
> > +		inode->i_checksum_hi = old_hi;
> > +	return retval;
> > +}
> > +
> > +int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
> > +			     struct ext2_inode_large *inode)
> > +{
> > +	errcode_t retval;
> > +	__u32 provided, calculated;
> > +	int has_hi;
> > +
> > +	if (fs->super->s_creator_os != EXT2_OS_LINUX ||
> > +	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> > +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +		return 1;
> > +
> > +	has_hi = (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
> > +		  inode->i_extra_isize >= EXT4_INODE_CSUM_HI_EXTRA_LOCATION);
> > +
> > +	provided = ext2fs_le16_to_cpu(inode->i_checksum_lo);
> > +	retval = ext2fs_inode_csum(fs, inum, inode, &calculated, has_hi);
> > +	if (retval)
> > +		return 0;
> > +	if (has_hi) {
> > +		__u32 hi = ext2fs_le16_to_cpu(inode->i_checksum_hi);
> > +		provided |= hi << 16;
> 
> It seems a bit odd to get the low bytes of "provided" before calculating
> the checksum, but the high bytes of after calculating the checksum.  It
> isn't incorrect since the checksum is preserved over the call to
> ext2fs_inode_csum(), but seems a bit strange.

I think this is a merge error.

> > diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> > index ce2fd66..4bcf1de 100644
> > --- a/lib/ext2fs/ext2_fs.h
> > +++ b/lib/ext2fs/ext2_fs.h
> > @@ -459,6 +459,10 @@ struct ext2_inode_large {
> > 	__u32	i_version_hi;	/* high 32 bits for 64-bit version */
> > };
> > 
> > +#define EXT4_INODE_CSUM_HI_EXTRA_LOCATION	\
> > +	(offsetof(struct ext2_inode_large, i_checksum_hi) + sizeof(__u16) - \
> > +	 EXT2_GOOD_OLD_INODE_SIZE)
> 
> It also makes sense to call this EXT4_INODE_CSUM_HI_END or similar, since
> _LOCATION incorrectly implies (to me at least) that this is the offset of
> the i_checksum_hi field, when it is actually the byte beyond the end.

_END it is.

--D

