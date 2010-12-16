From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2 13/15] mke2fs: fix potential memory leak in
 mke2fs_setup_tdb()
Date: Thu, 16 Dec 2010 13:21:24 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1012161320540.2781@dhcp-lab-213.englab.brq.redhat.com>
References: <1291206772.1684.26.camel@leonhard> <1292492525-6829-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab0LPMVa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Dec 2010 07:21:30 -0500
In-Reply-To: <1292492525-6829-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 16 Dec 2010, Namhyung Kim wrote:

> 'tmp_name' allocated by strdup() should also be freed if error.
> Also check return value of set_undo_io_backup_file() for possible
> memory failure. And move label 'alloc_fn_fail' to the end of the
> function.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  misc/mke2fs.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 6e2092dc051e..2150f62c3e4c 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1881,12 +1881,8 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>  		return 0;
>  
>  	tmp_name = strdup(name);
> -	if (!tmp_name) {
> -	alloc_fn_fail:
> -		com_err(program_name, ENOMEM, 
> -			_("Couldn't allocate memory for tdb filename\n"));
> -		return ENOMEM;
> -	}
> +	if (!tmp_name)
> +		goto alloc_fn_fail;
>  	device_name = basename(tmp_name);
>  	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(device_name) + 7 + 1);
>  	if (!tdb_file)
> @@ -1899,6 +1895,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>  			com_err(program_name, retval,
>  				_("while trying to delete %s"),
>  				tdb_file);
> +			free(tmp_name);
>  			free(tdb_file);
>  			return retval;
>  		}
> @@ -1906,7 +1903,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>  
>  	set_undo_io_backing_manager(*io_ptr);
>  	*io_ptr = undo_io_manager;
> -	set_undo_io_backup_file(tdb_file);
> +	retval = set_undo_io_backup_file(tdb_file);
>  	printf(_("Overwriting existing filesystem; this can be undone "
>  		 "using the command:\n"
>  		 "    e2undo %s %s\n\n"), tdb_file, name);
> @@ -1914,6 +1911,12 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>  	free(tdb_file);
>  	free(tmp_name);
>  	return retval;
> +
> +alloc_fn_fail:
> +	free(tmp_name);
> +	com_err(program_name, ENOMEM,
> +		_("Couldn't allocate memory for tdb filename\n"));
> +	return ENOMEM;
>  }
>  
>  #ifdef __linux__
> 

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!

-Lukas
