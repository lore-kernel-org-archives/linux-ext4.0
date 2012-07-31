From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 7/7] libext2fs: enforce the block group descriptor size in ext2fs_open()
Date: Tue, 31 Jul 2012 11:38:47 -0700
Message-ID: <B4B1A06B-F856-4248-8A7E-3BFF8F3E7267@whamcloud.com>
References: <20120628024356.GB17989@thor.bakeyournoodle.com> <1343684862-13181-1-git-send-email-tytso@mit.edu> <1343684862-13181-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"tony@bakeyournoodle.com" <tony@bakeyournoodle.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34560 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2GaSkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Jul 2012 14:40:40 -0400
Received: by ghrr11 with SMTP id r11so6386325ghr.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 11:40:39 -0700 (PDT)
In-Reply-To: <1343684862-13181-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-30, at 14:47, Theodore Ts'o <tytso@mit.edu> wrote:
> Since various parts of the library depend on the value of s_desc_size,
> check to make sure it is the correct, expected value based on the file
> system features.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> lib/ext2fs/ext2_err.et.in |  3 +++
> lib/ext2fs/openfs.c       | 15 +++++++++++++++
> 2 files changed, 18 insertions(+)
> 
> diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> index ccf1894..5987185 100644
> --- a/lib/ext2fs/ext2_err.et.in
> +++ b/lib/ext2fs/ext2_err.et.in
> @@ -443,4 +443,7 @@ ec    EXT2_ET_MMP_CHANGE_ABORT,
> ec    EXT2_ET_MMP_OPEN_DIRECT,
>    "MMP: open with O_DIRECT failed"
> 
> +ec    EXT2_ET_BAD_DESC_SIZE,
> +    "Block group descriptor size incorrect"
> +
>    end
> diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
> index 482e4ab..fbe9acd 100644
> --- a/lib/ext2fs/openfs.c
> +++ b/lib/ext2fs/openfs.c
> @@ -263,6 +263,21 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
>        retval = EXT2_ET_CORRUPT_SUPERBLOCK;
>        goto cleanup;
>    }
> +
> +    /* Enforce the block group descriptor size */
> +    if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) {
> +        if (fs->super->s_desc_size != EXT2_MIN_DESC_SIZE_64BIT) {

It doesn't necessarily make sense to limit this to the minimum size, only that it is at least the minimum size. 

Cheers, Andreas

> +            retval = EXT2_ET_BAD_DESC_SIZE;
> +            goto cleanup;
> +        }
> +    } else {
> +        if (fs->super->s_desc_size &&
> +            fs->super->s_desc_size != EXT2_MIN_DESC_SIZE) {
> +            retval = EXT2_ET_BAD_DESC_SIZE;
> +            goto cleanup;
> +        }
> +    }
> +
>    fs->cluster_ratio_bits = fs->super->s_log_cluster_size -
>        fs->super->s_log_block_size;
>    if (EXT2_BLOCKS_PER_GROUP(fs->super) !=
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
