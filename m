From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] e2fsprogs: misc/mke2fs.c: return error when failed to
 populate fs
Date: Sat, 22 Mar 2014 12:11:21 +0800
Message-ID: <20140322041121.GA22353@gmail.com>
References: <1395295766-10637-1-git-send-email-liezhi.yang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36797 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaCVEFL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Mar 2014 00:05:11 -0400
Received: by mail-pb0-f51.google.com with SMTP id uo5so3202912pbc.38
        for <linux-ext4@vger.kernel.org>; Fri, 21 Mar 2014 21:05:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1395295766-10637-1-git-send-email-liezhi.yang@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 20, 2014 at 02:09:26PM +0800, Robert Yang wrote:
> We need return retval when "mke2fs -d" failed, otherwise the "$?" would
> be 0 which is misleading.
> 
> Signed-off-by: Robert Yang <liezhi.yang@windriver.com>
> ---
>  misc/mke2fs.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index aecd5d5..f659e6f 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -2990,10 +2990,11 @@ no_journal:
>  
>  		retval = populate_fs(fs, EXT2_ROOT_INO, root_dir,
>  				     EXT2_ROOT_INO);
> -		if (retval)
> +		if (retval) {
>  			fprintf(stderr, "%s",
> -				_("\nError while populating file system"));
                        ^^^
Using com_err() is sane.  After we get an error, the user can know which
error has occured.
> -		else if (!quiet)
> +				_("\nError while populating file system\n"));
> +			return retval;
                        ^^^^
Maybe exit(1) is better.  We just need to notify the user that an error
has occured.  An internal error of libext2fs should not be returned
to user.

Regards,
                                                - Zheng

> +		} else if (!quiet)
>  			printf("%s", _("done\n"));
>  	}
>  
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
