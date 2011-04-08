From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 1/2] ext4: Calculate and verify inode checksums
Date: Fri, 8 Apr 2011 02:58:27 -0600
Message-ID: <86716762-8041-4209-961C-5C0BAB139C5B@dilger.ca>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224547.GT32706@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110406224547.GT32706@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-04-06, at 4:45 PM, Darrick J. Wong wrote:
> This patch introduces to ext4 the ability to calculate and verify inode
> checksums.  This requires the use of a new ro compatibility flag and some
> accompanying e2fsprogs patches to provide the relevant features in tune2fs and
> e2fsck.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
> fs/ext4/ext4.h  |    6 ++++--
> fs/ext4/inode.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
> 2 files changed, 55 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 4daaf2b..8815928 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -617,7 +617,7 @@ struct ext4_inode {
> 		} masix2;
> 	} osd2;				/* OS dependent 2 */
> 	__le16	i_extra_isize;
> -	__le16	i_pad1;
> +	__le16  i_checksum;		/* crc16(sb_uuid+inodenum+inode) */

In previous discussions, we thought about using part/all of the l_i_reserved2 field to store the inode checksum.  The inode checksum is important enough to warrant a field in the core inode, so that it also works on upgraded filesystems.

> +static __le16 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	int offset = offsetof(struct ext4_inode, i_checksum);
> +	__le32 inum = cpu_to_le32(inode->i_ino);
> +	__u16 crc = 0;
> +
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +		EXT4_FEATURE_RO_COMPAT_INODE_CSUM) &&
> +	    le16_to_cpu(raw->i_extra_isize) >= 4) {

If this field remains in the large part of the inode, then this check is incorrect.  i_extra_isize is itself only valid if (s_inode_size is > EXT4_GOOD_OLD_INODE_SIZE), otherwise it points at the next inode's i_mode.

Also, instead of hard-coding ">= 4" here, it would be better to use EXT4_FITS_IN_INODE(raw, EXT4_I(inode), i_checksum).  Probably no reason to put "ei" on the stack at all.

> +		crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
> +		crc = crc16(crc, (__u8 *)&inum, sizeof(inum));
> +		crc = crc16(crc, (__u8 *)raw, offset);
> +		offset += sizeof(raw->i_checksum); /* skip checksum */
> +		/* for checksum of struct ext4_inode do the rest...*/
> +		if (ei->i_extra_isize > 4)
> +			crc = crc16(crc, (__u8 *)raw + offset,
> +				    ei->i_extra_isize - 4);


> +	}
> +
> +	return cpu_to_le16(crc);
> +}
> +
> +static int ext4_inode_csum_verify(struct inode *inode, struct ext4_inode *raw)
> +{
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +		EXT4_FEATURE_RO_COMPAT_INODE_CSUM) &&
> +	    (raw->i_checksum != ext4_inode_csum(inode, raw)))
> +		return 0;
> +
> +	return 1;
> +}
> +
> static inline int ext4_begin_ordered_truncate(struct inode *inode,
> 					      loff_t new_size)
> {
> @@ -4802,7 +4837,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> 	struct ext4_inode *raw_inode;
> 	struct ext4_inode_info *ei;
> 	struct inode *inode;
> -	journal_t *journal = EXT4_SB(sb)->s_journal;
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	journal_t *journal = sbi->s_journal;
> 	long ret;
> 	int block;
> 
> @@ -4916,6 +4952,14 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
> 	} else
> 		ei->i_extra_isize = 0;
> 
> +	if (!ext4_inode_csum_verify(inode, raw_inode)) {
> +		EXT4_ERROR_INODE(inode, "checksum invalid (%u != %u)",
> +		       le16_to_cpu(ext4_inode_csum(inode, raw_inode)),
> +		       le16_to_cpu(raw_inode->i_checksum));
> +		ret = -EIO;
> +		goto bad_inode;
> +	}
> +
> 	EXT4_INODE_GET_XTIME(i_ctime, inode, raw_inode);
> 	EXT4_INODE_GET_XTIME(i_mtime, inode, raw_inode);
> 	EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
> @@ -5138,6 +5182,12 @@ static int ext4_do_update_inode(handle_t *handle,
> 			raw_inode->i_version_hi =
> 			cpu_to_le32(inode->i_version >> 32);
> 		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
> +
> +		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +			EXT4_FEATURE_RO_COMPAT_INODE_CSUM) &&
> +		    EXT4_FITS_IN_INODE(raw_inode, ei, i_checksum))
> +			raw_inode->i_checksum =
> +				ext4_inode_csum(inode, raw_inode);
> 	}
> 
> 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");


Cheers, Andreas
