From: "Yury V. Zaytsev" <yury@shurup.com>
Subject: Re: [PATCH] mke2fs: check that auto-detected blocksize <=
 sys_page_size
Date: Fri, 01 Jul 2011 10:31:38 +0200
Message-ID: <1309509098.4859.12.camel@newpride>
References: <1307524998.2467.41.camel@newpride>
	 <BANLkTikGv=OZgV0iwZroDDnPi+TiyxDzVg@mail.gmail.com>
	 <1307918791.2872.18.camel@newpride>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Amir Goldstein <amir73il@gmail.com>,
	Mike Snitzer <snitzer@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailgateway3.uni-freiburg.de ([132.230.2.213]:36805 "EHLO
	mailgateway3.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755447Ab1GAIbm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 04:31:42 -0400
In-Reply-To: <1307918791.2872.18.camel@newpride>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

On Mon, 2011-06-13 at 00:46 +0200, Yury V. Zaytsev wrote:

> I have refreshed patch against the latest "next" branch since it no
> longer properly applied and hopefully it can now be included!

I would highly appreciate if the trivial patch that nonetheless fixes an
important issue to my mind posted last month could be looked at.

Is there anything else I could do to help with the inclusion? Sorry if I
am bumping the thread too fast, but I see other patches flowing in which
makes me think that I've done something wrong; if this is the case
please do let me know, I am willing to rectify it.

Thanks!

-- 
Sincerely yours,
Yury V. Zaytsev

> From 1f8e5ad235694f2918fb442135619d4988366434 Mon Sep 17 00:00:00 2001
> From: "Yury V. Zaytsev" <yury@shurup.com>
> Date: Mon, 13 Jun 2011 00:35:05 +0200
> Subject: [PATCH] mke2fs: check that auto-detected blocksize <= sys_page_size
> 
> Block size can be specified manually via the -b option or deduced
> automatically. Unfortunately, the check that it is still smaller than
> the system page size is only performed right after the command line
> options are parsed.
> 
> Therefore, if buggy or inappropriately installed/configured hardware
> hints that larger block sizes have to be used, mkfs will silently create
> a file system which can not be mounted on the system in question.
> 
> By moving the check beyond the last assignment to blocksize it is now
> ensured, that mkfs will issue a warning even if inappropriate blocksize
> was auto-detected.
> 
> The new behavior can be easily tested, by exporting the following
> variables before running mkfs:
> 
>     export MKE2FS_DEVICE_SECTSIZE=8912
>     export MKE2FS_DEVICE_PHYS_SECTSIZE=8912
> 
> Signed-off-by: Yury V. Zaytsev <yury@shurup.com>
> ---
>  misc/mke2fs.c |   24 +++++++++++++-----------
>  1 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 5ff3f9f..d699b46 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1516,17 +1516,6 @@ profile_error:
>  		ext2fs_close(jfs);
>  	}
>  
> -	if (blocksize > sys_page_size) {
> -		if (!force) {
> -			com_err(program_name, 0,
> -				_("%d-byte blocks too big for system (max %d)"),
> -				blocksize, sys_page_size);
> -			proceed_question();
> -		}
> -		fprintf(stderr, _("Warning: %d-byte blocks too big for system "
> -				  "(max %d), forced to continue\n"),
> -			blocksize, sys_page_size);
> -	}
>  	if (optind < argc) {
>  		fs_blocks_count = parse_num_blocks2(argv[optind++],
>  						   fs_param.s_log_block_size);
> @@ -1825,6 +1814,19 @@ profile_error:
>  
>  	blocksize = EXT2_BLOCK_SIZE(&fs_param);
>  
> +	/* This check should happen beyond the last assignment to blocksize */
> +	if (blocksize > sys_page_size) {
> +		if (!force) {
> +			com_err(program_name, 0,
> +				_("%d-byte blocks too big for system (max %d)"),
> +				blocksize, sys_page_size);
> +			proceed_question();
> +		}
> +		fprintf(stderr, _("Warning: %d-byte blocks too big for system "
> +				  "(max %d), forced to continue\n"),
> +			blocksize, sys_page_size);
> +	}
> +
>  	lazy_itable_init = 0;
>  	if (access("/sys/fs/ext4/features/lazy_itable_init", R_OK) == 0)
>  		lazy_itable_init = 1;


