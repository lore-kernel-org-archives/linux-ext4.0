From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 13/15] mke2fs: fix potential memory leak in
 mke2fs_setup_tdb()
Date: Tue, 30 Nov 2010 14:02:32 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011301350290.3004@dhcp-lab-213.englab.brq.redhat.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com> <1291020917-8671-14-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059Ab0K3NCi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Nov 2010 08:02:38 -0500
In-Reply-To: <1291020917-8671-14-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 29 Nov 2010, Namhyung Kim wrote:

> 'tmp_name' allocated by strdup() should also be freed if error.
> Also check return value of set_undo_io_backup_file() for possible
> memory failure. A whitespace fix is added too.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  misc/mke2fs.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 6e2092d..644b287 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1882,15 +1882,17 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>  
>  	tmp_name = strdup(name);
>  	if (!tmp_name) {
> -	alloc_fn_fail:
> -		com_err(program_name, ENOMEM, 
> +alloc_fn_fail:
> +		com_err(program_name, ENOMEM,
>  			_("Couldn't allocate memory for tdb filename\n"));
>  		return ENOMEM;
>  	}

What about putting the alloc_fn_fail at the end of the function ? after return
retval?

>  	device_name = basename(tmp_name);
>  	tdb_file = malloc(strlen(tdb_dir) + 8 + strlen(device_name) + 7 + 1);
> -	if (!tdb_file)
> +	if (!tdb_file) {
> +		free(tmp_name);

What about adding

if (tmp_name)
	free(tmp_name);

in alloc_fs_fail context ?

>  		goto alloc_fn_fail;
> +	}
>  	sprintf(tdb_file, "%s/mke2fs-%s.e2undo", tdb_dir, device_name);
>  
>  	if (!access(tdb_file, F_OK)) {
> @@ -1899,6 +1901,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>  			com_err(program_name, retval,
>  				_("while trying to delete %s"),
>  				tdb_file);
> +			free(tmp_name);
>  			free(tdb_file);
>  			return retval;
>  		}
> @@ -1906,7 +1909,7 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>  
>  	set_undo_io_backing_manager(*io_ptr);
>  	*io_ptr = undo_io_manager;
> -	set_undo_io_backup_file(tdb_file);
> +	retval = set_undo_io_backup_file(tdb_file);

You should probably return ENOMEM when this fails, moreover when
set_undo_io_backup() you'll try to free not allocated space.

>  	printf(_("Overwriting existing filesystem; this can be undone "
>  		 "using the command:\n"
>  		 "    e2undo %s %s\n\n"), tdb_file, name);
> 

Thanks
-Lukas
