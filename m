From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 12/15] mke2fs: add some error checks into PRS()
Date: Tue, 30 Nov 2010 13:46:07 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011301340570.3004@dhcp-lab-213.englab.brq.redhat.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com> <1291020917-8671-13-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab0K3MqM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 07:46:12 -0500
In-Reply-To: <1291020917-8671-13-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 29 Nov 2010, Namhyung Kim wrote:

> Check return value of some functions and exit if unhandled error occurred.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  misc/mke2fs.c |   26 ++++++++++++++++++++++----
>  1 files changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index b88decf..6e2092d 100644
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
> +	} else {

Maybe use "else if (retval)" since profile_init(config_fn, &profile);
might exit successfully (return 0) ?

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

-Lukas
