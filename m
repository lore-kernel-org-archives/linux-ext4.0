From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 06/22] ext4: Calculate and verify inode checksums
Date: Mon, 5 Dec 2011 11:24:06 -0500
Message-ID: <20111205162406.GB32031@thunk.org>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com>
 <20111128232656.19194.82262.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50868 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab1LEQYM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Dec 2011 11:24:12 -0500
Content-Disposition: inline
In-Reply-To: <20111128232656.19194.82262.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 28, 2011 at 03:26:56PM -0800, Darrick J. Wong wrote:
> +	/* Precompute second piece of csum */
> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
> +		__u32 csum;
> +		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
> +		__le32 inum = cpu_to_le32(inode->i_ino);
> +		__le32 gen = cpu_to_le32(inode->i_generation);
> +		csum = ext4_chksum(sbi, sbi->s_uuid_csum, (__u8 *)&inum,
> +				   sizeof(inum));
> +		ei->i_uuid_inum_csum = ext4_chksum(sbi, csum, (__u8 *)&gen,
> +						   sizeof(gen));
> +	}

Why do we include a copy of i_generation in the precomputed initial
part of the checksum?  Since i_generation is in the raw, on-disk
version of the inode, what's the rationale for including it here?  It
shouldn't *hurt*, but it a few extra CPU cycles, and I'm not seeing
how it helps.

						- Ted
