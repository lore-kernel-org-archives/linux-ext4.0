From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH] e2fsck: avoid unnecessary close/reopen for non-MMP filesystems
Date: Thu, 22 Mar 2012 18:03:30 -0600
Message-ID: <70E60F63-F78E-49C3-954D-328655550EAF@whamcloud.com>
References: <1332386476-25673-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33334 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab2CWAET (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 20:04:19 -0400
Received: by yenl12 with SMTP id l12so2330204yen.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 17:04:18 -0700 (PDT)
In-Reply-To: <1332386476-25673-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-21, at 21:21, Theodore Ts'o <tytso@mit.edu> wrote:
> For file systems that do not use MMP, there's no reason to close the
> file system and then re-open the file system a second time, since
> EXT2_FLAG_SKIP_MMP has no meaning for non-MMP file systems anyway.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Not sure how those two identical checks ended up next to each other. 

Acked-by: Andreas Dilger <adilger@whamcloud.com>

> ---
> e2fsck/unix.c |    8 +++-----
> 1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 59c52ff..d0b10d4 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -1398,12 +1398,10 @@ failure:
>        (flags & EXT2_FLAG_SKIP_MMP)) {
>        if (e2fsck_check_mmp(fs, ctx))
>            fatal_error(ctx, 0);
> -    }
> 
> -     /*
> -      * Restart in order to reopen fs but this time start mmp.
> -      */
> -    if (flags & EXT2_FLAG_SKIP_MMP) {
> +        /*
> +         * Restart in order to reopen fs but this time start mmp.
> +         */
>        ext2fs_close(fs);
>        ctx->fs = NULL;
>        flags &= ~EXT2_FLAG_SKIP_MMP;
> -- 
> 1.7.9.107.g97f9a
> 
