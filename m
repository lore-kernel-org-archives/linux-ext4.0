From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] e2fsprogs: fix endian handling of ext3_extent_header
Date: Thu, 23 Oct 2014 15:03:05 -0700
Message-ID: <20141023220305.GA10047@birch.djwong.org>
References: <54497296.8000708@redhat.com>
 <544972C4.2040204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29235 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaJWWDM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2014 18:03:12 -0400
Content-Disposition: inline
In-Reply-To: <544972C4.2040204@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 23, 2014 at 04:27:32PM -0500, Eric Sandeen wrote:
> 
> 
> This turned up when trying to resize a filesystem containing
> a file with many extents on PPC64.
> 
> Fix all locations where ext3_extent_header members aren't
> handled in an endian-safe manner.

Looks ok to me (and fixed resize2fs on ${BE}64), so
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  lib/ext2fs/ext3_extents.h |   15 ++++++++++-----
>  lib/ext2fs/inline_data.c  |    2 +-
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
> index 4163436..a18d705 100644
> --- a/lib/ext2fs/ext3_extents.h
> +++ b/lib/ext2fs/ext3_extents.h
> @@ -106,15 +106,20 @@ struct ext3_ext_path {
>  	((struct ext3_extent_idx *) (((char *) (__hdr__)) +	\
>  				     sizeof(struct ext3_extent_header)))
>  #define EXT_HAS_FREE_INDEX(__path__) \
> -	((__path__)->p_hdr->eh_entries < (__path__)->p_hdr->eh_max)
> +	(ext2fs_le16_to_cpu((__path__)->p_hdr->eh_entries) < \
> +	 ext2fs_le16_to_cpu((__path__)->p_hdr->eh_max))
>  #define EXT_LAST_EXTENT(__hdr__) \
> -	(EXT_FIRST_EXTENT((__hdr__)) + (__hdr__)->eh_entries - 1)
> +	(EXT_FIRST_EXTENT((__hdr__)) + \
> +	ext2fs_le16_to_cpu((__hdr__)->eh_entries) - 1)
>  #define EXT_LAST_INDEX(__hdr__) \
> -	(EXT_FIRST_INDEX((__hdr__)) + (__hdr__)->eh_entries - 1)
> +	(EXT_FIRST_INDEX((__hdr__)) + \
> +	ext2fs_le16_to_cpu((__hdr__)->eh_entries) - 1)
>  #define EXT_MAX_EXTENT(__hdr__) \
> -	(EXT_FIRST_EXTENT((__hdr__)) + (__hdr__)->eh_max - 1)
> +	(EXT_FIRST_EXTENT((__hdr__)) + \
> +	ext2fs_le16_to_cpu((__hdr__)->eh_max) - 1)
>  #define EXT_MAX_INDEX(__hdr__) \
> -	(EXT_FIRST_INDEX((__hdr__)) + (__hdr__)->eh_max - 1)
> +	(EXT_FIRST_INDEX((__hdr__)) + \
> +	ext2fs_le16_to_cpu((__hdr__)->eh_max) - 1)
>  
>  #endif /* _LINUX_EXT3_EXTENTS */
>  
> diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
> index 7eb8b94..8167b76 100644
> --- a/lib/ext2fs/inline_data.c
> +++ b/lib/ext2fs/inline_data.c
> @@ -420,7 +420,7 @@ ext2fs_inline_data_file_expand(ext2_filsys fs, ext2_ino_t ino,
>  		eh = (struct ext3_extent_header *) &inode->i_block[0];
>  		eh->eh_depth = 0;
>  		eh->eh_entries = 0;
> -		eh->eh_magic = EXT3_EXT_MAGIC;
> +		eh->eh_magic = ext2fs_cpu_to_le16(EXT3_EXT_MAGIC);
>  		i = (sizeof(inode->i_block) - sizeof(*eh)) /
>  			sizeof(struct ext3_extent);
>  		eh->eh_max = ext2fs_cpu_to_le16(i);
> -- 1.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
