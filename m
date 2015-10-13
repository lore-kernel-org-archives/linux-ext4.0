From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 02/12] libext2fs: automatically enable meta_bg to avoid filling up BG 0
Date: Mon, 12 Oct 2015 20:34:36 -0600
Message-ID: <6D149520-CD92-4409-B155-8FF587130557@dilger.ca>
References: <20151012215629.29065.24418.stgit@birch.djwong.org> <20151012215642.29065.18353.stgit@birch.djwong.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32872 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbbJMCei (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 22:34:38 -0400
Received: by pabrc13 with SMTP id rc13so5652351pab.0
        for <linux-ext4@vger.kernel.org>; Mon, 12 Oct 2015 19:34:38 -0700 (PDT)
In-Reply-To: <20151012215642.29065.18353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The commit comment says enable meta_bg if 1/2 of the block group
is full, but the code checks for 3/4 of the block group is full.  Which one
Should it be?

Cheers, Andreas

> On Oct 12, 2015, at 15:56, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> If during formatting we'd lose more than half of a block group to
> group descriptors and other metadata, enable the meta_bg feature.
> This enables us to create >500T filesystems with default options.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> lib/ext2fs/initialize.c |    5 +++++
> 1 file changed, 5 insertions(+)
> 
> 
> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index f672a27..b5ca928 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -381,6 +381,11 @@ ipg_retry:
>    overhead = (int) (3 + fs->inode_blocks_per_group +
>              super->s_reserved_gdt_blocks);
> 
> +    /* Enable meta_bg if we'd lose more than 3/4 of a BG to GDT blocks. */
> +    if (super->s_reserved_gdt_blocks + fs->desc_blocks >
> +        super->s_blocks_per_group * 3 / 4)
> +        fs->super->s_feature_incompat |= EXT2_FEATURE_INCOMPAT_META_BG;
> +
>    if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
>        overhead++;
>    else
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
