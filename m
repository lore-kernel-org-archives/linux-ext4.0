From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/2] ext4: Add support for 48 bit inode i_blocks.
Date: Fri, 12 Oct 2007 00:48:59 -0600
Message-ID: <20071012064859.GC8122@schatzie.adilger.int>
References: <1192163815-8721-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:48708 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760134AbXJLGtE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Oct 2007 02:49:04 -0400
Content-Disposition: inline
In-Reply-To: <1192163815-8721-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 12, 2007  10:06 +0530, Aneesh Kumar K.V wrote:
> use the __le16  l_i_reserved1 field of the linux2
> struct of ext4_inode to represet the higher 16
> bits for i_blocks. With this change max_file size becomes
> (2**48 -1 )* 512 bytes.
> 
> +static int ext4_inode_blocks_set(handle_t *handle,
> +					struct ext4_inode *raw_inode,
> +					struct ext4_inode_info *ei)

CodingStyle would suggest aligning the continued lines with the '('.

> +{
> +	} else if (i_blocks <= 0xffffffffffffULL) {
> +		if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> +					EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
> +
> +			err = ext4_journal_get_write_access(handle,
> +					EXT4_SB(sb)->s_sbh);
> +			if (err)
> +				goto  err_out;
> +			ext4_update_dynamic_rev(sb);
> +			EXT4_SET_RO_COMPAT_FEATURE(sb,
> +					EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
> +			sb->s_dirt = 1;
> +			handle->h_sync = 1;
> +			err = ext4_journal_dirty_metadata(handle,
> +					EXT4_SB(sb)->s_sbh);
> +		}

Can you please make a helper function for this, like:

    int ext4_update_feature(sb, __u32 compat, __u32 rocompat, __u32 incompat)

as we have similar code in a few places already (HTREE, LARGE_FILE, EXTENTS).
That could be done in a prerequisite patch.

> +	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
> +		/*
> +		 * Large file size enabled file system can only be
> +		 * mount if kernel is build with CONFIG_LSF
> +		 */
> +		if (sizeof(root->i_blocks) < sizeof(u64) &&
> +				!(sb->s_flags & MS_RDONLY)) {
> +			printk(KERN_ERR "EXT4-fs: %s: Having huge file with "
> +					"LSF off, you must mount filesystem "
> +					"read-only.\n", sb->s_id);

What do you think about changing the wording:

"Filesystem with huge files cannot mount read-write without CONFIG_LSF."

>  #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
>  #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
> +#define EXT4_FEATURE_INCOMPAT_MMP               0x0100
>  #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200

Note that it is fine to add the #define for this flag.

>  					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
>  					 EXT4_FEATURE_INCOMPAT_64BIT| \
> +					 EXT4_FEATURE_INCOMPAT_MMP|\
>  					 EXT4_FEATURE_INCOMPAT_FLEX_BG)

Note it is NOT OK to add INCOMPAT_MMP to the INCOMPAT_SUPP flags, or you
defeat the entire purpose of having the feature flag.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
