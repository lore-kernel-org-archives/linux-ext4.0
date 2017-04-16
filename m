From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] e2fsck: allow extent tree optimization to be disabled
Date: Sun, 16 Apr 2017 12:24:30 -0700
Message-ID: <20170416192430.GB5185@birch.djwong.org>
References: <20170415134118.17808-1-tytso@mit.edu>
 <20170415134118.17808-3-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50645 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756597AbdDPTYf (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 16 Apr 2017 15:24:35 -0400
Content-Disposition: inline
In-Reply-To: <20170415134118.17808-3-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 15, 2017 at 09:41:18AM -0400, Theodore Ts'o wrote:
> Add an extended option, -E no_optimize_extents, as well as a
> e2fsck.conf profile option, to disable extent tree optimization.
> 
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  e2fsck/e2fsck.8.in      | 4 ++++
>  e2fsck/e2fsck.conf.5.in | 4 ++++
>  e2fsck/e2fsck.h         | 1 +
>  e2fsck/extents.c        | 3 +++
>  e2fsck/unix.c           | 8 ++++++++
>  5 files changed, 20 insertions(+)
> 
> diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
> index 915273d8..4ad575f4 100644
> --- a/e2fsck/e2fsck.8.in
> +++ b/e2fsck/e2fsck.8.in
> @@ -226,6 +226,10 @@ option may prevent you from further manual data recovery.
>  Do not attempt to discard free blocks and unused inode blocks. This option is
>  exactly the opposite of discard option. This is set as default.
>  .TP
> +.BI no_optimize_extents
> +Do not offer to optimize the extent tree by eliminating unnecessary
> +width or depth.
> +.TP
>  .BI readahead_kb
>  Use this many KiB of memory to pre-fetch metadata in the hopes of reducing
>  e2fsck runtime.  By default, this is set to the size of two block groups' inode
> diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
> index 0bfc76ab..94525baf 100644
> --- a/e2fsck/e2fsck.conf.5.in
> +++ b/e2fsck/e2fsck.conf.5.in
> @@ -205,6 +205,10 @@ of that type are squelched.  This can be useful if the console is slow
>  (i.e., connected to a serial port) and so a large amount of output could
>  end up delaying the boot process for a long time (potentially hours).
>  .TP
> +.I no_optimize_extents
> +Do not offer to optimize the extent tree by eliminating unnecessary
> +width or depth.

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

/me wonders if there's a way to detect that we're being run by
initscripts/systemd/whatever on a device that is mounted ro, and skip
the optimization step to avoid the reboot.

OTOH I wonder why the initramfs (if available) doesn't just build in
e2fsck and fsck the root device before mounting the fs...

--D

> +.TP
>  .I readahead_mem_pct
>  Use this percentage of memory to try to read in metadata blocks ahead of the
>  main e2fsck thread.  This should reduce run times, depending on the speed of
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index ecd3b1e1..a4b5fb24 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -169,6 +169,7 @@ struct resource_track {
>  #define E2F_OPT_DISCARD		0x2000
>  #define E2F_OPT_CONVERT_BMAP	0x4000 /* convert blockmap to extent */
>  #define E2F_OPT_FIXES_ONLY	0x8000 /* skip all optimizations */
> +#define E2F_OPT_NOOPT_EXTENTS	0x10000 /* don't optimize extents */
>  
>  /*
>   * E2fsck flags
> diff --git a/e2fsck/extents.c b/e2fsck/extents.c
> index 1df31d71..d9410028 100644
> --- a/e2fsck/extents.c
> +++ b/e2fsck/extents.c
> @@ -518,6 +518,9 @@ errcode_t e2fsck_should_rebuild_extents(e2fsck_t ctx,
>  	if (eti->force_rebuild)
>  		goto rebuild;
>  
> +	if (ctx->options & E2F_OPT_NOOPT_EXTENTS)
> +		return 0;
> +
>  	extents_per_block = (ctx->fs->blocksize -
>  			     sizeof(struct ext3_extent_header)) /
>  			    sizeof(struct ext3_extent);
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index b7322bc6..b6025535 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -709,6 +709,9 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
>  		} else if (strcmp(token, "nodiscard") == 0) {
>  			ctx->options &= ~E2F_OPT_DISCARD;
>  			continue;
> +		} else if (strcmp(token, "no_optimize_extents") == 0) {
> +			ctx->options |= E2F_OPT_NOOPT_EXTENTS;
> +			continue;
>  		} else if (strcmp(token, "log_filename") == 0) {
>  			if (!arg)
>  				extended_usage++;
> @@ -1007,6 +1010,11 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
>  	if (c)
>  		verbose = 1;
>  
> +	profile_get_boolean(ctx->profile, "options", "no_optimize_extents",
> +			    0, 0, &c);
> +	if (c)
> +		ctx->options |= E2F_OPT_NOOPT_EXTENTS;
> +
>  	if (ctx->readahead_kb == ~0ULL) {
>  		profile_get_integer(ctx->profile, "options",
>  				    "readahead_mem_pct", 0, -1, &c);
> -- 
> 2.11.0.rc0.7.gbe5a750
> 
