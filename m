From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] mke2fs: print a message when creating a regular
 file
Date: Mon, 5 May 2014 15:41:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405051532280.2223@localhost.localdomain>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbaEENlG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 09:41:06 -0400
In-Reply-To: <1399295044-24489-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 5 May 2014, Theodore Ts'o wrote:

> Date: Mon,  5 May 2014 09:04:02 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 1/3] mke2fs: print a message when creating a regular file

Description is missing.

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  misc/mke2fs.c |  6 ++++--
>  misc/util.c   | 11 +++++++----
>  misc/util.h   |  1 +
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 2c51999..51532ef 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -103,6 +103,7 @@ static int	quotatype = -1;  /* Initialize both user and group quotas by default
>  static __u64	offset;
>  static blk64_t journal_location = ~0LL;
>  static int	proceed_delay = -1;
> +static blk64_t	dev_size;
>  
>  static struct ext2_super_block fs_param;
>  static char *fs_uuid = NULL;
> @@ -1402,7 +1403,6 @@ static void PRS(int argc, char *argv[])
>  	char *		extended_opts = 0;
>  	char *		fs_type = 0;
>  	char *		usage_types = 0;
> -	blk64_t		dev_size;
>  	/*
>  	 * NOTE: A few words about fs_blocks_count and blocksize:
>  	 *
> @@ -1768,6 +1768,8 @@ profile_error:
>  	flags = CREATE_FILE;
>  	if (isatty(0) && isatty(1))
>  		flags |= CHECK_FS_EXIST;
> +	if (!quiet)
> +		flags |= VERBOSE_CREATE;
>  	if (!check_plausibility(device_name, flags, &is_device) && !force)
>  		proceed_question(proceed_delay);
>  
> @@ -2573,7 +2575,7 @@ int main (int argc, char *argv[])
>  		journal_blocks = figure_journal_size(journal_size, fs);
>  
>  	/* Can't undo discard ... */
> -	if (!noaction && discard && (io_ptr != undo_io_manager)) {
> +	if (!noaction && discard && dev_size && (io_ptr != undo_io_manager)) {

I wonder whether it's possible not to have dev_size set at this point ?

>  		retval = mke2fs_discard_device(fs);
>  		if (!retval && io_channel_discard_zeroes_data(fs->io)) {
>  			if (verbose)
> diff --git a/misc/util.c b/misc/util.c
> index be16ebe..15b4ce5 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -106,7 +106,7 @@ void proceed_question(int delay)
>  }
>  
>  /*
> - * return 1 if the device looks plausible
> + * return 1 if the device looks plausible, creating the file if necessary
>   */
>  int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  {
> @@ -117,10 +117,13 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  	char *fs_type = NULL;
>  	char *fs_label = NULL;
>  
> -	if (flags & CREATE_FILE)
> -		fl |= O_CREAT;
> -
>  	fd = open(device, fl, 0666);

Ah, so you're building on a previous patches. It's a bit confusing.

> +	if ((fd < 0) && (errno == ENOENT) && (flags & CREATE_FILE)) {
> +		fl |= O_CREAT;
> +		fd = open(device, fl, 0666);
> +		if (fd >= 0 && (flags & VERBOSE_CREATE))

Do we have to use VERBOSE_CREATE ? quiet is global variable so we
can as well just test that here, or am I missing something ?

Thanks!
-Lukas

> +			printf(_("Creating regular file %s\n"), device);
> +	}
>  	if (fd < 0) {
>  		fprintf(stderr, _("Could not open %s: %s\n"),
>  			device, error_message(errno));
> diff --git a/misc/util.h b/misc/util.h
> index 745568e..476164b 100644
> --- a/misc/util.h
> +++ b/misc/util.h
> @@ -21,6 +21,7 @@ extern char	*journal_location_string;
>  #define CHECK_BLOCK_DEV	0x0001
>  #define CREATE_FILE	0x0002
>  #define CHECK_FS_EXIST	0x0004
> +#define VERBOSE_CREATE	0x0008
>  
>  #ifndef HAVE_STRCASECMP
>  extern int strcasecmp (char *s1, char *s2);
> 
