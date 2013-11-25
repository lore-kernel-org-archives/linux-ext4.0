From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 15/25] e2fsck: print cluster ranges when encountering
 bitmap errors
Date: Mon, 25 Nov 2013 19:56:23 +0800
Message-ID: <20131125115623.GB15056@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045035.7339.86831.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39720 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3KYLxf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Nov 2013 06:53:35 -0500
Received: by mail-pd0-f171.google.com with SMTP id z10so5338800pdj.30
        for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 03:53:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131018045035.7339.86831.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:50:35PM -0700, Darrick J. Wong wrote:
> If pass5 finds bitmap errors in a range of clusters, don't print each
> cluster number individually when we could print only the start and end
> cluster number.  e2fsck already does this for the non-bigalloc case.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  e2fsck/pass5.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index 346c831..30dc70a 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -528,8 +528,8 @@ redo_counts:
>  			save_problem = problem;
>  		} else {
>  			if ((problem == save_problem) &&
> -			    (pctx.blk2 == i-1))
> -				pctx.blk2++;
> +			    (pctx.blk2 == i - EXT2FS_CLUSTER_RATIO(fs)))
> +				pctx.blk2 += EXT2FS_CLUSTER_RATIO(fs);
>  			else {
>  				print_bitmap_problem(ctx, save_problem, &pctx);
>  				pctx.blk = pctx.blk2 = i;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
