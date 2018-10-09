Return-Path: <SRS0=WpiV=MV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55150 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725749AbeJIHkM (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2018 03:40:12 -0400
Date: Mon, 8 Oct 2018 17:23:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: nicholas.clark@gmail.com
Cc: linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/2] Fuse2fs: fix 'mount' entry in some cases.
Message-ID: <20181009002358.GA24099@magnolia>
References: <20181008233952.20965-1-nicholas.clark@gmail.com>
 <20181008233952.20965-2-nicholas.clark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008233952.20965-2-nicholas.clark@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 08, 2018 at 05:39:51PM -0600, nicholas.clark@gmail.com wrote:
> From: Nicholas Clark <nicholas.clark@gmail.com>
> 
> FUSE's parser allows command-line options to be specified before
> or after the device/image and mount-path. This commit changes the
> value of the fsname mount option to be correct even if options are
> specified before the target device/image.
> 
> Signed-off-by: Nicholas Clark <nicholas.clark@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  misc/fuse2fs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
> index 5c73895e..3214be4a 100644
> --- a/misc/fuse2fs.c
> +++ b/misc/fuse2fs.c
> @@ -3845,7 +3845,7 @@ int main(int argc, char *argv[])
>  	/* Set up default fuse parameters */
>  	snprintf(extra_args, BUFSIZ, "-okernel_cache,subtype=ext4,use_ino,"
>  		 "fsname=%s,attr_timeout=0" FUSE_PLATFORM_OPTS,
> -		 argv[1]);
> +		 fctx.device);
>  	if (fctx.no_default_opts == 0)
>  		fuse_opt_add_arg(&args, extra_args);
>  
> -- 
> 2.17.1
> 
