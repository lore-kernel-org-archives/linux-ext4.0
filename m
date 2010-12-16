From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2 12/15] mke2fs: add some error checks into PRS()
Date: Thu, 16 Dec 2010 13:19:57 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012161318100.2781@dhcp-lab-213.englab.brq.redhat.com>
References: <1291205003.1684.12.camel@leonhard> <1292492440-6778-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab0LPMUF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Dec 2010 07:20:05 -0500
In-Reply-To: <1292492440-6778-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 16 Dec 2010, Namhyung Kim wrote:

> Check return value of some functions and exit if unhandled error occurred.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  misc/mke2fs.c |   26 ++++++++++++++++++++++----
>  1 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index b88decfc2f27..6e2092dc051e 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1108,6 +1108,10 @@ static void PRS(int argc, char *argv[])
>  	if (oldpath)
>  		pathlen += strlen(oldpath);
>  	newpath = malloc(pathlen);
> +	if (!newpath) {
> +		fprintf(stderr, _("Couldn't allocate memory for new PATH.\n"));
> +		exit(1);
> +	}
>  	strcpy(newpath, PATH_SET);
>  
>  	/* Update our PATH to include /sbin  */
> @@ -1138,14 +1142,28 @@ static void PRS(int argc, char *argv[])
>  	profile_set_syntax_err_cb(syntax_err_report);
>  	retval = profile_init(config_fn, &profile);
>  	if (retval == ENOENT) {
> -		profile_init(default_files, &profile);
> -		profile_set_default(profile, mke2fs_default_profile);
> +		retval = profile_init(default_files, &profile);
> +		if (retval)
> +			goto profile_error;
> +		retval = profile_set_default(profile, mke2fs_default_profile);
> +		if (retval)
> +			goto profile_error;
> +	} else if (retval) {
> +profile_error:
> +		fprintf(stderr, _("Couldn't init profile successfully"
> +				  " (error: %ld).\n"), retval);
> +		exit(1);
>  	}
>  
>  	setbuf(stdout, NULL);
>  	setbuf(stderr, NULL);
> -	add_error_table(&et_ext2_error_table);
> -	add_error_table(&et_prof_error_table);
> +	retval = add_error_table(&et_ext2_error_table);
> +	if (!retval)
> +		retval = add_error_table(&et_prof_error_table);
> +	if (retval) {
> +		fprintf(stderr, _("Unable to add error information.\n"));
> +		exit(1);
> +	}
>  	memset(&fs_param, 0, sizeof(struct ext2_super_block));
>  	fs_param.s_rev_level = 1;  /* Create revision 1 filesystems now */
>  
> 

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!

-Lukas
