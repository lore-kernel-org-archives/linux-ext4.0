From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/2] ext4: Calculate and verify inode checksums
Date: Fri, 8 Apr 2011 12:12:48 -0700
Message-ID: <20110408191250.GD24354@tux1.beaverton.ibm.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224547.GT32706@tux1.beaverton.ibm.com> <86716762-8041-4209-961C-5C0BAB139C5B@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45177 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab1DHTMx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 15:12:53 -0400
Content-Disposition: inline
In-Reply-To: <86716762-8041-4209-961C-5C0BAB139C5B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 08, 2011 at 02:58:27AM -0600, Andreas Dilger wrote:
> On 2011-04-06, at 4:45 PM, Darrick J. Wong wrote:
> > This patch introduces to ext4 the ability to calculate and verify inode
> > checksums.  This requires the use of a new ro compatibility flag and some
> > accompanying e2fsprogs patches to provide the relevant features in tune2fs and
> > e2fsck.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > 
> > fs/ext4/ext4.h  |    6 ++++--
> > fs/ext4/inode.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
> > 2 files changed, 55 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > index 4daaf2b..8815928 100644
> > --- a/fs/ext4/ext4.h
> > +++ b/fs/ext4/ext4.h
> > @@ -617,7 +617,7 @@ struct ext4_inode {
> > 		} masix2;
> > 	} osd2;				/* OS dependent 2 */
> > 	__le16	i_extra_isize;
> > -	__le16	i_pad1;
> > +	__le16  i_checksum;		/* crc16(sb_uuid+inodenum+inode) */
> 
> In previous discussions, we thought about using part/all of the l_i_reserved2
> field to store the inode checksum.  The inode checksum is important enough to
> warrant a field in the core inode, so that it also works on upgraded
> filesystems.

Hmm, yes, I better like using that field too, it'll simplify the code.  Does
anyone know which of the s_creator_os codes map to the Linux format?  I'm going
to guess 1 and 2 don't... for now I suppose the mount code can check for a
Linux creator code if the inode checksum feature is set, and fail the mount if
it finds 1 or 2.  I'm not sure which version of the osd2 union FreeBSD or
"Lites" use.

> > +static __le16 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
> > +{
> > +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> > +	struct ext4_inode_info *ei = EXT4_I(inode);
> > +	int offset = offsetof(struct ext4_inode, i_checksum);
> > +	__le32 inum = cpu_to_le32(inode->i_ino);
> > +	__u16 crc = 0;
> > +
> > +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> > +		EXT4_FEATURE_RO_COMPAT_INODE_CSUM) &&
> > +	    le16_to_cpu(raw->i_extra_isize) >= 4) {
> 
> If this field remains in the large part of the inode, then this check is
> incorrect.  i_extra_isize is itself only valid if (s_inode_size is >
> EXT4_GOOD_OLD_INODE_SIZE), otherwise it points at the next inode's i_mode.
> 
> Also, instead of hard-coding ">= 4" here, it would be better to use
> EXT4_FITS_IN_INODE(raw, EXT4_I(inode), i_checksum).  Probably no reason to
> put "ei" on the stack at all.

As always, thank you for the feedback!

--D
