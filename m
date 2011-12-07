From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 01/02] ext2: reserve INCOMPAT_INLINEDATA feature flag
Date: Wed, 07 Dec 2011 09:43:46 +0800
Message-ID: <4EDEC4D2.7080100@tao.ma>
References: <BC7EBC84-486E-4BD5-A952-51C2B71BF455@whamcloud.com> <E8BB5200-9BE3-49FE-AFC2-18B2E7BBA5A8@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:59625 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751744Ab1LGBnw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Dec 2011 20:43:52 -0500
In-Reply-To: <E8BB5200-9BE3-49FE-AFC2-18B2E7BBA5A8@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/07/2011 08:13 AM, Andreas Dilger wrote:
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
I am fine with it. Thanks.

Tao
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
>  
>  #define EXT2_FEATURE_COMPAT_SUPP	0
>  #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \

