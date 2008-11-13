From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 13/17] Support 48-bit file acl blocks
Date: Thu, 13 Nov 2008 13:14:50 -0700
Message-ID: <20081113201109.GX16005@webber.adilger.int>
References: <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <1226461390-5502-12-git-send-email-vaurora@redhat.com>
 <1226461390-5502-13-git-send-email-vaurora@redhat.com>
 <1226461390-5502-14-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42657 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbYKMUPB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 15:15:01 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mADKF0CW018834
	for <linux-ext4@vger.kernel.org>; Thu, 13 Nov 2008 12:15:00 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAA00901FMZO300@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 13 Nov 2008 12:15:00 -0800 (PST)
In-reply-to: <1226461390-5502-14-git-send-email-vaurora@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  19:43 -0800, Valerie Aurora Henson wrote:
> @@ -82,8 +82,8 @@ struct dup_inode {
>  	struct block_el		*block_list;
>  };
>  
> -static int process_pass1b_block(ext2_filsys fs, blk_t	*blocknr,
> -				e2_blkcnt_t blockcnt, blk_t ref_blk,
> +static int process_pass1b_block(ext2_filsys fs, blk64_t	*blocknr,
> +				e2_blkcnt_t blockcnt, blk64_t ref_blk,
>  				int ref_offset, void *priv_data);
>  static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
>  			struct dup_inode *dp, char *block_buf);
> @@ -293,12 +293,15 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
> -			pctx.errcode = ext2fs_block_iterate2(fs, ino,
> +			pctx.errcode = ext2fs_block_iterate3(fs, ino,
>  					     BLOCK_FLAG_READ_ONLY, block_buf,
>  					     process_pass1b_block, &pb);

Several of these changes should probably be part of the previous patch,
since they are not really related to ACLs.

> + * XXX Ignoring 64-bit file system flag - most places where this is
> + * called don't have access to the fs struct, and the high bits should
> + * be 0 in the non-64-bit case anyway.
> + */
> +blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode)
> +{
> +	return (inode->i_file_acl |
> +		(__u64) inode->osd2.linux2.l_i_file_acl_high << 32);
> +}
> +
> +/*
> + * Set the acl block of a file
> + */
> +void ext2fs_file_acl_block_set(struct ext2_inode *inode, blk64_t blk)
> +{
> +	inode->i_file_acl = blk;
> +	inode->osd2.linux2.l_i_file_acl_high = (__u64) blk >> 32;
> +}

Does e2fsck validate the ACL block number is within the filesystem
limits when it is checking the filesystem?

> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index d7d7bdb..3fa7555 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -343,7 +343,7 @@ struct ext2_inode {
> -	__u32	i_dir_acl;	/* Directory ACL */
> +	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
>  	__u32	i_faddr;	/* Fragment address */
>  	union {
>  		struct {
> @@ -390,7 +390,7 @@ struct ext2_inode_large {
> -	__u32	i_dir_acl;	/* Directory ACL */
> +	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
> @@ -419,7 +419,7 @@ struct ext2_inode_large {
> -#define i_size_high	i_dir_acl
> +#define i_dir_acl	i_size_high

These changes should be landed upstream directly, independent of this patch.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

