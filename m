Return-Path: <SRS0=dqau=MX=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:50006 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbeJKW40 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2018 18:56:26 -0400
Date: Thu, 11 Oct 2018 08:28:40 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH] fuse2fs: return proper exit code from fuse_main
Message-ID: <20181011152840.GB24099@magnolia>
References: <20181011134336.977-1-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011134336.977-1-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 11, 2018 at 03:43:36PM +0200, Lukas Czerner wrote:
> Currently fuse2fs will always return 0 exit code indicating successful
> operation even though the mount failed either because we failed to
> properly read the file system in the first place, or the fuse_main()
> failed for whatever reason.
> 
> Fix it by using the return code from fuse_main(), or return 32 in case
> we fail because the file system is corrupted, or we encountered a
> problem preventing us mounting the file system. 32 because this is a
> libmount exit code indicating mount failed.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  misc/fuse2fs.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
> index 5c73895e..d7a0b668 100644
> --- a/misc/fuse2fs.c
> +++ b/misc/fuse2fs.c
> @@ -3720,7 +3720,7 @@ int main(int argc, char *argv[])
>  {
>  	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
>  	struct fuse2fs fctx;
> -	errcode_t err;
> +	errcode_t err = 0;
>  	char *logfile;
>  	char extra_args[BUFSIZ];
>  	int ret = 0, flags = EXT2_FLAG_64BITS | EXT2_FLAG_EXCLUSIVE;
> @@ -3753,6 +3753,7 @@ int main(int argc, char *argv[])
>  		fctx.err_fp = fopen(logfile, "a");
>  		if (!fctx.err_fp) {
>  			perror(logfile);
> +			err = errno;
>  			goto out;
>  		}
>  	} else
> @@ -3766,7 +3767,6 @@ int main(int argc, char *argv[])
>  	}
>  
>  	/* Start up the fs (while we still can use stdout) */
> -	ret = 2;
>  	if (!fctx.ro)
>  		flags |= EXT2_FLAG_RW;
>  	err = ext2fs_open2(fctx.device, NULL, flags, 0, 0, unix_io_manager,
> @@ -3779,8 +3779,6 @@ int main(int argc, char *argv[])
>  	fctx.fs = global_fs;
>  	global_fs->priv_data = &fctx;
>  
> -	ret = 3;
> -
>  	if (ext2fs_has_feature_journal_needs_recovery(global_fs->super)) {
>  		if (!fctx.ro) {
>  			printf(_("%s: recovering journal\n"), fctx.device);
> @@ -3797,6 +3795,7 @@ int main(int argc, char *argv[])
>  		} else {
>  			printf("%s", _("Journal needs recovery; running "
>  			       "`e2fsck -E journal_only' is required.\n"));
> +			err = 1;
>  			goto out;
>  		}
>  	}
> @@ -3836,6 +3835,7 @@ int main(int argc, char *argv[])
>  	if (global_fs->super->s_state & EXT2_ERROR_FS) {
>  		printf("%s",
>  		       _("Errors detected; running e2fsck is required.\n"));
> +		err = 1;
>  		goto out;
>  	}
>  
> @@ -3859,11 +3859,16 @@ int main(int argc, char *argv[])
>  	}
>  
>  	pthread_mutex_init(&fctx.bfl, NULL);
> -	fuse_main(args.argc, args.argv, &fs_ops, &fctx);
> +	ret = fuse_main(args.argc, args.argv, &fs_ops, &fctx);

Hmmm, what /does/ fuse_main return?  According to the libfuse github
site it returns 0 for success and "nonzero" for failure.  The source
code seems to return 1 on failure (I think), but we probably ought to
set ret to 1 ("incorrect invocation or permissions") or 32 explicitly
just in case they ever change their minds...

>  	pthread_mutex_destroy(&fctx.bfl);
>  
> -	ret = 0;
>  out:
> +	/*
> +	 * Encountered error reading the file system. Return standard "mount
> +	 * failure" mount exit code (32).
> +	 */
> +	if (err)
> +		ret = 32;

...I guess "mount failure" for libext2fs problems is good enough, though
part of me thinks that we should return 1 if ext2fs_open can't open the
block device due to EPERM/EACCESS.

<shrug>  OTOH "mount failure" is sufficiently vague to hide just about
anything behind. :)

--D

>  	if (global_fs) {
>  		err = ext2fs_close(global_fs);
>  		if (err)
> -- 
> 2.17.1
> 
