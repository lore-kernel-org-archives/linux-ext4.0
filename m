From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 3/6] libext2fs: iterate past lower extents during punch
Date: Tue, 21 Jan 2014 15:40:11 +0800
Message-ID: <20140121074011.GD1819@gmail.com>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
 <20140121062158.20507.50066.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33638 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaAUHfs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 02:35:48 -0500
Received: by mail-pd0-f174.google.com with SMTP id z10so2561203pdj.5
        for <linux-ext4@vger.kernel.org>; Mon, 20 Jan 2014 23:35:48 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140121062158.20507.50066.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 20, 2014 at 10:21:58PM -0800, Darrick J. Wong wrote:
> When we're iterating extents during a punch operation, the loop exits
> if the punch region is entirely to the right of the extent we're
> looking at.  This can happen if the punch region starts in the middle
> of a hole and covers mapped extents.  When this happens, we want to
> skip to the next extent, because it might be punchable.
> 
> Also, if we've totally passed the punch range, stop.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
                                                - Zheng

> ---
>  lib/ext2fs/punch.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
> index 25d7953..657cb53 100644
> --- a/lib/ext2fs/punch.c
> +++ b/lib/ext2fs/punch.c
> @@ -288,8 +288,12 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  			   (unsigned long long) end,
>  			   (unsigned long long) next);
>  		if (start <= extent.e_lblk) {
> +			/*
> +			 * Have we iterated past the end of the punch region?
> +			 * If so, we can stop.
> +			 */
>  			if (end < extent.e_lblk)
> -				goto next_extent;
> +				break;
>  			dbg_printf("Case #%d\n", 1);
>  			/* Start of deleted region before extent; 
>  			   adjust beginning of extent */
> @@ -303,8 +307,13 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  			extent.e_lblk += free_count;
>  			extent.e_pblk += free_count;
>  		} else if (end >= next-1) {
> +			/*
> +			 * Is the punch region beyond this extent?  This can
> +			 * happen if start is already inside a hole.  Try to
> +			 * advance to the next extent if this is the case.
> +			 */
>  			if (start >= next)
> -				break;
> +				goto next_extent;
>  			/* End of deleted region after extent;
>  			   adjust end of extent */
>  			dbg_printf("Case #%d\n", 2);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
