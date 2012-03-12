From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] e2fsck: remove last argument from
 e2fsck_discard_blocks()
Date: Mon, 12 Mar 2012 08:30:37 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1203120829470.5543@dhcp-27-109.brq.redhat.com>
References: <20120311191836.GD1048@thunk.org> <1331494393-21577-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	lczerner@redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab2CLHam (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 03:30:42 -0400
In-Reply-To: <1331494393-21577-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 11 Mar 2012, Theodore Ts'o wrote:

> From: Lukas Czerner <lczerner@redhat.com>
> 
> Simple code cleanup.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Looks good. Thanks!
-Lukas

> ---
>  e2fsck/pass5.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index 9a6a4b0..ca438cb 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -74,8 +74,8 @@ void e2fsck_pass5(e2fsck_t ctx)
>  	print_resource_track(ctx, _("Pass 5"), &rtrack, ctx->fs->io);
>  }
>  
> -static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
> -				  blk64_t start, blk64_t count)
> +static void e2fsck_discard_blocks(e2fsck_t ctx, blk64_t start,
> +				  blk64_t count)
>  {
>  	ext2_filsys fs = ctx->fs;
>  
> @@ -85,7 +85,7 @@ static void e2fsck_discard_blocks(e2fsck_t ctx, io_manager manager,
>  	 * not enough to fix the problem, hence it is not safe to run discard
>  	 * in this case.
>  	 */
> -	if (ext2fs_test_changed(ctx->fs))
> +	if (ext2fs_test_changed(fs))
>  		ctx->options &= ~E2F_OPT_DISCARD;
>  
>  	if (!(ctx->options & E2F_OPT_NO) &&
> @@ -137,7 +137,7 @@ static void e2fsck_discard_inodes(e2fsck_t ctx, int group,
>  	num = count / EXT2_INODES_PER_BLOCK(fs->super);
>  
>  	if (num > 0)
> -		e2fsck_discard_blocks(ctx, fs->io->manager, blk, num);
> +		e2fsck_discard_blocks(ctx, blk, num);
>  }
>  
>  #define NO_BLK ((blk64_t) -1)
> @@ -379,7 +379,7 @@ redo_counts:
>  				first_free = i;
>  		} else {
>  			if (i > first_free)
> -				e2fsck_discard_blocks(ctx, manager, first_free,
> +				e2fsck_discard_blocks(ctx, first_free,
>  						      (i - first_free));
>  			first_free = ext2fs_blocks_count(fs->super);
>  		}
> 

-- 
