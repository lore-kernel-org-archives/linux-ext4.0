From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] e2fsck: journal-replay-only
Date: Fri, 12 Nov 2010 17:11:13 -0700
Message-ID: <5EBEF687-AA92-475D-9B5A-E4BAAD34C927@dilger.ca>
References: <201011130009.08641.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:7579 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0KMALO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Nov 2010 19:11:14 -0500
In-Reply-To: <201011130009.08641.bs_lists@aakef.fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-11-12, at 16:09, Bernd Schubert wrote:
> e2fsck: journal-replay-only
> 
> As recently discussed on linux-ext4@vger.kernel.org add an option to e2fsck
> to allow to replay the journal only. That will allow scripts, such as 
> pacemakers 'Filesystem' RA to first replay the journal and if that sets
> an error state from the journal replay, further check for that error 
> (dumpe2fh -h | grep "Filesystem state:") and if that shows and error
> to refuse to mount. It also allows automatic e2fsck scripts to first
> replay the journal and on a second run after the real pass1 to passX checks
> to test for the return code.
> 
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>

I'm definitely in favour of this patch.  We've needed something similar as well.

It wouldn't be a terrible idea if tune2fs also would replay the journal on an unmounted filesystem before changing the superblock, if needed, otherwise any changes made to the superblock will be lost (unlike when they are made to the mounted filesystem).  That is for a separate patch, however...

> diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
> index 3fb15e6..d948f4c 100644
> --- a/e2fsck/e2fsck.8.in
> +++ b/e2fsck/e2fsck.8.in
> @@ -186,6 +186,9 @@ Set the version of the extended attribute blocks which
> will require while checking the filesystem.  The version number may 
> be 1 or 2.  The default extended attribute version format is 2.
> .TP
> +.BI journal_only
> +Only replay the journal if required, but do not run any further repair action.
> +.TP
> .BI fragcheck
> During pass 1, print a detailed report of any discontiguous blocks for
> files in the filesystem.
> diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
> index d4df5f3..d8038a5 100644
> --- a/e2fsck/e2fsck.h
> +++ b/e2fsck/e2fsck.h
> @@ -155,6 +155,7 @@ struct resource_track {
> #define E2F_OPT_WRITECHECK	0x0200
> #define E2F_OPT_COMPRESS_DIRS	0x0400
> #define E2F_OPT_FRAGCHECK	0x0800
> +#define E2F_OPT_JOURNAL_ONLY	0x1000 /* only replay the journal */
> 
> /*
>  * E2fsck flags
> diff --git a/e2fsck/unix.c b/e2fsck/unix.c
> index 7eb269c..e3fee9a 100644
> --- a/e2fsck/unix.c
> +++ b/e2fsck/unix.c
> @@ -308,6 +308,10 @@ static void check_if_skip(e2fsck_t ctx)
> 	if ((ctx->options & E2F_OPT_FORCE) || bad_blocks_file || cflag)
> 		return;
> 
> +	if (ctx->options & E2F_OPT_JOURNAL_ONLY) {
> +		goto skip;
> +	}
> +
> 	lastcheck = fs->super->s_lastcheck;
> 	if (lastcheck > ctx->now)
> 		lastcheck -= ctx->time_fudge;
> @@ -372,6 +376,7 @@ static void check_if_skip(e2fsck_t ctx)
> 			printf(_(" (check in %ld mounts)"), next_check);
> 	}
> 	fputc('\n', stdout);
> +skip:
> 	ext2fs_close(fs);
> 	ctx->fs = NULL;
> 	e2fsck_free_context(ctx);
> @@ -594,6 +599,13 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
> 		} else if (strcmp(token, "fragcheck") == 0) {
> 			ctx->options |= E2F_OPT_FRAGCHECK;
> 			continue;
> +
> +		} else if (strcmp(token, "journal_only") == 0) {
> +			if (arg) {
> +				extended_usage++;
> +				continue;
> +			}
> +			ctx->options |= E2F_OPT_JOURNAL_ONLY;
> 		} else {
> 			fprintf(stderr, _("Unknown extended option: %s\n"),
> 				token);
> @@ -609,6 +621,7 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
> 		       "Valid extended options are:\n"), stderr);
> 		fputs(("\tea_ver=<ea_version (1 or 2)>\n"), stderr);
> 		fputs(("\tfragcheck\n"), stderr);
> +		fputs(("\tjournal_only\n"), stderr);
> 		fputc('\n', stderr);
> 		exit(1);
> 	}
> 
> 
> 
> -- 
> Bernd Schubert
> DataDirect Networks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





