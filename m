From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH V2] e2fsprogs: misc/mke2fs.c: return error when failed to
 populate fs
Date: Sun, 30 Mar 2014 17:08:25 +0800
Message-ID: <20140330090825.GA4394@gmail.com>
References: <1395885787-25947-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54736 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaC3JHv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Mar 2014 05:07:51 -0400
Received: by mail-pb0-f48.google.com with SMTP id md12so6855900pbc.21
        for <linux-ext4@vger.kernel.org>; Sun, 30 Mar 2014 02:07:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1395885787-25947-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 27, 2014 at 10:03:07AM +0800, Robert Yang wrote:
> We need return retval when "mke2fs -d" failed, otherwise the "$?" would
> be 0 which is misleading.
> 
> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>

Thanks for fixing this.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  misc/mke2fs.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index aecd5d5..60e7466 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2990,10 +2990,11 @@ no_journal:
>  
>  		retval = populate_fs(fs, EXT2_ROOT_INO, root_dir,
>  				     EXT2_ROOT_INO);
> -		if (retval)
> -			fprintf(stderr, "%s",
> -				_("\nError while populating file system"));
> -		else if (!quiet)
> +		if (retval) {
> +			com_err(program_name, retval, "%s",
> +				_("\nError while populating file system\n"));
> +			exit(1);
> +		} else if (!quiet)
>  			printf("%s", _("done\n"));
>  	}
>  
> -- 
> 1.8.3.1
> 
