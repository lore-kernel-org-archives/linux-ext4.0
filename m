From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 01/02] ext2: reserve INCOMPAT_INLINEDATA feature flag
Date: Tue, 6 Dec 2011 16:39:32 -0800
Message-ID: <20111207003932.GI7137@tux1.beaverton.ibm.com>
References: <BC7EBC84-486E-4BD5-A952-51C2B71BF455@whamcloud.com> <E8BB5200-9BE3-49FE-AFC2-18B2E7BBA5A8@whamcloud.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Liang Zhen <liang@whamcloud.com>, Tao Ma <tm@tao.ma>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:60813 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab1LGAkx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 19:40:53 -0500
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 6 Dec 2011 17:40:52 -0700
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pB70dYdZ173610
	for <linux-ext4@vger.kernel.org>; Tue, 6 Dec 2011 17:39:34 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pB70dXsZ007356
	for <linux-ext4@vger.kernel.org>; Tue, 6 Dec 2011 17:39:33 -0700
Content-Disposition: inline
In-Reply-To: <E8BB5200-9BE3-49FE-AFC2-18B2E7BBA5A8@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 06, 2011 at 05:13:51PM -0700, Andreas Dilger wrote:
> Reserve the EXT4_FEATURE_INCOMPAT_INLINEDATA feature flag for use
> with storing small file data in the i_blocks field (up to 60 bytes)
> and/or the large xattr space (after i_extra_isize, up to the large
> inode size).  On typical filesystems this can save 1-3% of the space,
> and more importantly it also avoids seeking to read the data block.
> 
> This will become increasingly important with bigalloc filesystems,
> since they consume a full cluster of blocks for each file, including
> small directories that could easily fit into the inode itself.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
> Originally-by: Tao Ma <tm@tao.ma>
> ---
>  lib/ext2fs/ext2_fs.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index 0f8cde8..6cf47f9 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -719,6 +719,7 @@ struct ext2_super_block {
>  #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
>  #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
>  #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
> +#define EXT4_FEATURE_INCOMPAT_INLINEDATA	0x2000 /* data in inode */

I was using 0x2000 for EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM, to change the
block group checksum to use crc32c.

--D
> 
>  #define EXT2_FEATURE_COMPAT_SUPP	0
>  #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
> -- 
> 1.7.2
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

