From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/2] ext4: Calculate and verify inode checksums
Date: Wed, 06 Apr 2011 17:52:43 -0700
Message-ID: <4D9D0ADB.9010005@oracle.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224547.GT32706@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:43511 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab1DGAwu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Apr 2011 20:52:50 -0400
In-Reply-To: <20110406224547.GT32706@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/06/2011 03:45 PM, Darrick J. Wong wrote:
> This patch introduces to ext4 the ability to calculate and verify inode
> checksums.  This requires the use of a new ro compatibility flag and some
> accompanying e2fsprogs patches to provide the relevant features in tune2fs and
> e2fsck.
>
> Signed-off-by: Darrick J. Wong<djwong@us.ibm.com>
> ---
>
>   fs/ext4/ext4.h  |    6 ++++--
>   fs/ext4/inode.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 55 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 4daaf2b..8815928 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -617,7 +617,7 @@ struct ext4_inode {
>   		} masix2;
>   	} osd2;				/* OS dependent 2 */
>   	__le16	i_extra_isize;
> -	__le16	i_pad1;
> +	__le16  i_checksum;		/* crc16(sb_uuid+inodenum+inode) */
>   	__le32  i_ctime_extra;  /* extra Change time      (nsec<<  2 | epoch) */
>   	__le32  i_mtime_extra;  /* extra Modification time(nsec<<  2 | epoch) */
>   	__le32  i_atime_extra;  /* extra Access time      (nsec<<  2 | epoch) */
> @@ -1338,6 +1338,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>   #define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
>   #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
>   #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
> +#define EXT4_FEATURE_RO_COMPAT_INODE_CSUM	0x0400
>
>   #define EXT4_FEATURE_INCOMPAT_COMPRESSION	0x0001
>   #define EXT4_FEATURE_INCOMPAT_FILETYPE		0x0002
> @@ -1364,7 +1365,8 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
>   					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
>   					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
>   					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR |\
> -					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
> +					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE |\
> +					 EXT4_FEATURE_RO_COMPAT_INODE_CSUM)
>
>   /*
>    * Default values for user and/or group using reserved blocks
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 1a86282..dc76f19 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -42,6 +42,7 @@
>   #include<linux/printk.h>
>   #include<linux/slab.h>
>   #include<linux/ratelimit.h>
> +#include<linux/crc16.h>
>
>   #include "ext4_jbd2.h"
>   #include "xattr.h"
> @@ -52,6 +53,40 @@
>
>   #define MPAGE_DA_EXTENT_TAIL 0x01
>
> +static __le16 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> +	struct ext4_inode_info *ei = EXT4_I(inode);
> +	int offset = offsetof(struct ext4_inode, i_checksum);
> +	__le32 inum = cpu_to_le32(inode->i_ino);
> +	__u16 crc = 0;
> +
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +		EXT4_FEATURE_RO_COMPAT_INODE_CSUM)&&
> +	    le16_to_cpu(raw->i_extra_isize)>= 4) {
> +		crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
> +		crc = crc16(crc, (__u8 *)&inum, sizeof(inum));
> +		crc = crc16(crc, (__u8 *)raw, offset);
> +		offset += sizeof(raw->i_checksum); /* skip checksum */
> +		/* for checksum of struct ext4_inode do the rest...*/
> +		if (ei->i_extra_isize>  4)
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
> +		EXT4_FEATURE_RO_COMPAT_INODE_CSUM)&&
> +	    (raw->i_checksum != ext4_inode_csum(inode, raw)))
> +		return 0;
> +
> +	return 1;
> +}
> +
>   static inline int ext4_begin_ordered_truncate(struct inode *inode,
>   					      loff_t new_size)
>   {
> @@ -4802,7 +4837,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>   	struct ext4_inode *raw_inode;
>   	struct ext4_inode_info *ei;
>   	struct inode *inode;
> -	journal_t *journal = EXT4_SB(sb)->s_journal;
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	journal_t *journal = sbi->s_journal;
>   	long ret;
>   	int block;
>
> @@ -4916,6 +4952,14 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>   	} else
>   		ei->i_extra_isize = 0;
>
> +	if (!ext4_inode_csum_verify(inode, raw_inode)) {
> +		EXT4_ERROR_INODE(inode, "checksum invalid (%u != %u)",
> +		       le16_to_cpu(ext4_inode_csum(inode, raw_inode)),
> +		       le16_to_cpu(raw_inode->i_checksum));
> +		ret = -EIO;
> +		goto bad_inode;
> +	}
> +
>   	EXT4_INODE_GET_XTIME(i_ctime, inode, raw_inode);
>   	EXT4_INODE_GET_XTIME(i_mtime, inode, raw_inode);
>   	EXT4_INODE_GET_XTIME(i_atime, inode, raw_inode);
> @@ -5138,6 +5182,12 @@ static int ext4_do_update_inode(handle_t *handle,
>   			raw_inode->i_version_hi =
>   			cpu_to_le32(inode->i_version>>  32);
>   		raw_inode->i_extra_isize = cpu_to_le16(ei->i_extra_isize);
> +
> +		if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
> +			EXT4_FEATURE_RO_COMPAT_INODE_CSUM)&&
> +		    EXT4_FITS_IN_INODE(raw_inode, ei, i_checksum))
> +			raw_inode->i_checksum =
> +				ext4_inode_csum(inode, raw_inode);
>   	}
>
>   	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");

You may want to look into jbd2 buffer triggers. struct jbd2_buffer_trigger_type
Instead of computing checksum on every update, it allows one to compute it
just before the journal write. More efficient.

