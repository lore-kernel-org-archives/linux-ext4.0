From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/4] e2fsck: Do not discard when in read only mode
Date: Mon, 05 Mar 2012 13:33:56 -0600
Message-ID: <4F551524.60809@redhat.com>
References: <1330933776-2696-1-git-send-email-lczerner@redhat.com> <1330933776-2696-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481Ab2CETd6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2012 14:33:58 -0500
In-Reply-To: <1330933776-2696-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/05/2012 01:49 AM, Lukas Czerner wrote:
> When argument '-n' was specified and should run in read-only mode, we
> should not attempt to discard anything. In order to do that we have to
> check for E2F_OPT_NO flag and clear E2F_OPT_DISCARD flag if E2F_OPT_NO
> is set.
> 
> This commit fixes the problem when we would mark inode tables as zeroed
> (EXT2_BG_INODE_ZEROED) even when e2fsck is running in read-only mode. We
> also move the check for E2F_OPT_NO so we can clear E2F_OPT_DISCARD as
> early as possible.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Probably no need to test (ctx->options & E2F_OPT_DISCARD) before
clearing it, but no big deal.

> ---
>  e2fsck/pass5.c |    5 ++---
>  e2fsck/unix.c  |    5 +++++
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index 37bbac2..741e6dd 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -88,8 +88,7 @@ static void e2fsck_discard_blocks(e2fsck_t ctx, blk64_t start,
>  	if (ext2fs_test_changed(fs))
>  		ctx->options &= ~E2F_OPT_DISCARD;
>  
> -	if (!(ctx->options & E2F_OPT_NO) &&
> -	    (ctx->options & E2F_OPT_DISCARD) &&
> +	if ((ctx->options & E2F_OPT_DISCARD) &&
>  	    (io_channel_discard(fs->io, start, count)))
>  		ctx->options &= ~E2F_OPT_DISCARD;
>  }
> @@ -117,7 +116,7 @@ static void e2fsck_discard_inodes(e2fsck_t ctx, int group,
>  		ctx->options &= ~E2F_OPT_DISCARD;
>  	}
>  
> -	if ((ctx->options & E2F_OPT_NO) || !(ctx->options & E2F_OPT_DISCARD))
> +	if (!(ctx->options & E2F_OPT_DISCARD))
>  		return;
>  
>  	/*
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 6f97b0f..b31a1e3 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -903,6 +903,11 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
>  	profile_set_syntax_err_cb(syntax_err_report);
>  	profile_init(config_fn, &ctx->profile);
>  
> +	/* Turn off discard in read-only mode */
> +	if ((ctx->options & E2F_OPT_NO) &&
> +	    (ctx->options & E2F_OPT_DISCARD))
> +		ctx->options &= ~E2F_OPT_DISCARD;
> +
>  	if (flush) {
>  		fd = open(ctx->filesystem_name, O_RDONLY, 0);
>  		if (fd < 0) {

