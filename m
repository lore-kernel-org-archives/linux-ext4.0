From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 2/2] ext4: Support large files
Date: Fri, 12 Oct 2007 01:01:29 -0600
Message-ID: <20071012070129.GD8122@schatzie.adilger.int>
References: <1192163815-8721-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1192163815-8721-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:35109 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbXJLHBc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Oct 2007 03:01:32 -0400
Content-Disposition: inline
In-Reply-To: <1192163815-8721-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 12, 2007  10:06 +0530, Aneesh Kumar K.V wrote:
> We add a RO_COMPAT feature to the super
> block to indicate that some of the inode have i_blocks
> represented as file system block size units. Super block
> with this feature set cannot be mounted read write on a kernel
> with CONFIG_LSF disabled.
> 
> Super block flag EXT4_FEATURE_RO_COMPAT_HUGE_FILE
> inode flag  EXT4_HUGE_FILE_FL

I was wondering where this part of the patch went...

> @@ -2905,10 +2912,32 @@ static int ext4_inode_blocks_set(handle_t *handle,
>  		/* i_block is stored in the split  48 bit fields */
>  		raw_inode->i_blocks_lo   = cpu_to_le32((u32)i_blocks);
>  		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);

I don't think we need to cast (u32) here, since cpu_to_le32() should do
that already?

> +	} else {
> +		/*
> +		 * i_blocks should be represented in a 48 bit variable
> +		 * as multiple of  file system block size
> +		 */
> +		if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +					EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
> +
> +			err = ext4_journal_get_write_access(handle,
> +					EXT4_SB(sb)->s_sbh);
> +			if (err)
> +				goto err_out;
> +			ext4_update_dynamic_rev(sb);
> +			EXT4_SET_RO_COMPAT_FEATURE(sb,
> +					EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
> +			sb->s_dirt = 1;
> +			handle->h_sync = 1;
> +			err = ext4_journal_dirty_metadata(handle,
> +					EXT4_SB(sb)->s_sbh);
> +		}
> +		ei->i_flags |= EXT4_HUGE_FILE_FL;
> +		/* i_block is stored in file system block size */
> +		i_blocks = i_blocks >> (inode->i_blkbits - 9);
> +		raw_inode->i_blocks_lo   = cpu_to_le32((u32)i_blocks);
> +		raw_inode->i_blocks_high = cpu_to_le16(i_blocks >> 32);
>  	}

This "else" clause is a LOT like the previous case, maybe they can be
merges?  Having the feature helper I suggested will reduce that a lot,
but it still seems like most of it is the same except for the shift.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
