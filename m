From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] uninitialized groups ported - kernel
Date: Tue, 19 Jun 2007 01:50:34 -0600
Message-ID: <20070619075034.GQ5181@schatzie.adilger.int>
References: <1181065733.5219.8.camel@mathur-dsktp> <4665AFEF.3060602@redhat.com> <20070605212005.GM5181@schatzie.adilger.int> <467755D3.8030802@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Girish Shilamkar <girish@clusterfs.com>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:41730 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbXFSHuh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 03:50:37 -0400
Content-Disposition: inline
In-Reply-To: <467755D3.8030802@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 18, 2007  21:04 -0700, Avantika Mathur wrote:
> Here is the uninitialized block group patch, rebased to the ext4 git 
> tree, after ext4_remove_subdirs_limit.patch.
> Andreas, please let me know if there are any issues with the patch

> +__le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
> +			    struct ext4_group_desc *gdp)
> +{
> +	__u16 crc = 0;
> +
> +	if (sbi->s_es->s_feature_ro_compat &
> +	    cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
> +		int offset = offsetof(struct ext4_group_desc, bg_checksum);
> +		__le32 le_group = cpu_to_le32(block_group);
> +
> +		crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
> +		crc = crc16(crc, (__u8 *)&le_group, sizeof(le_group));
> +		crc = crc16(crc, (__u8 *)gdp, offset);
> +		offset += sizeof(gdp->bg_checksum); /* skip checksum */
> +		/*BUG_ON(offset != sizeof(*gdp)); /* XXX handle s_desc_size */
> +		/* for checksum of struct ext4_group_desc do the rest...*/
> +		if (offset < sbi->s_es->s_desc_size) {

This is missing an le16_to_cpu(sbi->s_es->s_desc_size) conversion.  I missed
it in my sparse checking because it was commented out.  Also, s_desc_size is
only valid in conjunction with INCOMPAT_64BIT I think, so that should be
checked also.

> @@ -681,6 +687,7 @@ static inline int ext4_valid_inum(struct
>  #define EXT4_FEATURE_COMPAT_EXT_ATTR		0x0008
>  #define EXT4_FEATURE_COMPAT_RESIZE_INODE	0x0010
>  #define EXT4_FEATURE_COMPAT_DIR_INDEX		0x0020
> +#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0040

This is the wrong feature number.  It should be 0x0010 as in the original
patch, and as reserved in the upstream e2fsprogs.  The confusion is because
you added this to the "FEATURE_COMPAT" section instead of the
FEATURE_RO_COMPAT section of the headers.

I've asked Girish to send an incremental patch.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
