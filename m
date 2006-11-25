From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC][PATCH 4/4] BIG_BG: block group descriptor modifications
Date: Sat, 25 Nov 2006 02:23:46 -0700
Message-ID: <20061125092346.GA4241@schatzie.adilger.int>
References: <1164386918.17961.79.camel@ckrm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:64993 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S966312AbWKYJXs
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Nov 2006 04:23:48 -0500
To: Valerie Clement <Valerie.Clement@bull.net>
Content-Disposition: inline
In-Reply-To: <1164386918.17961.79.camel@ckrm>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Nov 24, 2006  17:48 +0100, Valerie Clement wrote:
> @@ -133,6 +133,9 @@ struct ext4_group_desc
>  	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
>  	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
>  	__le32	bg_inode_table_hi;	/* Inodes table block MSB */
> +	__le16	bg_free_blocks_count_hi;	/* Free blocks count MSB */
> +	__le16	bg_free_inodes_count_hi;	/* Free inodes count MSB */
> +	__le16	bg_used_dirs_count_hi;	/* Directories count MSB */
>  };

Does the ext4 code already avoid using "sizeof(struct ext4_group_desc)"
or "sizeof(*gdp)" everywhere?  Otherwise this is very dangerous.

Also note that the on-disk layout of this struct in e2fsprogs is a bit
incorrect - it has the above 3 __u16, but then immediately __u32 bg_reserved
so those fields are padded incorrectly.  I think it isn't a fatal problem,
just something to be aware of and fix.

> +#define EXT4_READ_SPLIT_LE32(__sb, __field)	\
> +	((__u32)le16_to_cpu(__field) +		\
> +	 (EXT4_HAS_INCOMPAT_FEATURE((__sb), EXT4_FEATURE_INCOMPAT_64BIT) ? \
> +	 (__u32)le16_to_cpu(__field##_hi) << 16 : 0))

Is it better to make this INCOMPAT_64BIT or s_desc_size?  Does INCOMPAT_64BIT
always imply s_desc_size > 32?  Hmm, I guess it does, or we have no place to
store the _hi part of the block addresses for a group.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
