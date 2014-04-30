From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 6/7] mke2fs: check for pre-existing file system
Date: Wed, 30 Apr 2014 13:50:13 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404301346460.2100@localhost.localdomain>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu> <1398556834-31913-6-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371AbaD3NU4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2014 09:20:56 -0400
In-Reply-To: <1398556834-31913-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 26 Apr 2014, Theodore Ts'o wrote:

> Date: Sat, 26 Apr 2014 20:00:33 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 6/7] mke2fs: check for pre-existing file system
> 
> Warn the system administrator if there is an existing file system on
> the block device, and give the administrator an opportunity to abort
> the mkfs operation.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  misc/mke2fs.c |  4 +++-
>  misc/util.c   | 29 +++++++++++++++++++++++++++++
>  misc/util.h   |  1 +
>  3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 799132a..3694ce5 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1753,7 +1753,9 @@ profile_error:
>  	profile_get_integer(profile, "options", "proceed_delay", 0, 5,
>  			    &proceed_delay);
>  
> -	if (!check_plausibility(device_name, CREATE_FILE,
> +	/* The isatty() test is so we don't break existing scripts */
> +	if (!check_plausibility(device_name, CREATE_FILE |
> +				(isatty(0) ? CHECK_FS_EXIST : 0),
>  				&is_device) && !force)
>  		proceed_question(proceed_delay);
>  
> diff --git a/misc/util.c b/misc/util.c
> index afb0058..be16ebe 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -113,6 +113,9 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  	int fd, is_dev = 0;
>  	ext2fs_struct_stat s;
>  	int fl = O_RDONLY;
> +	blkid_cache cache = NULL;
> +	char *fs_type = NULL;
> +	char *fs_label = NULL;
>  
>  	if (flags & CREATE_FILE)
>  		fl |= O_CREAT;
> @@ -148,6 +151,32 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  		return 0;
>  	}
>  
> +	if ((flags & CHECK_FS_EXIST) && blkid_get_cache(&cache, NULL) >= 0) {
> +		fs_type = blkid_get_tag_value(cache, "TYPE", device);
> +		if (fs_type)
> +			fs_label = blkid_get_tag_value(cache, "LABEL", device);
> +		blkid_put_cache(cache);
> +	}
> +
> +	if (fs_type) {
> +		if (fs_label)
> +			printf(_("%s contains a %s file system "
> +				 "labelled '%s'\n"), device, fs_type, fs_label);
> +		else
> +			printf(_("%s contains a %s file system\n"), device,
> +			       fs_type);
> +		free(fs_type);
> +		free(fs_label);
> +		return 0;
> +	}
> +
> +	/*
> +	 * We should eventually replace this with a test for the
> +	 * presence of a partition table.  Unfortunately the blkid
> +	 * library doesn't test for partition tabels, and checking for
> +	 * valid GPT and MBR and possibly others isn't quite trivial.
> +	 */

That is not true. libblkid definitely can scan for partition or any
other signature for that matter (lvm, mdraid, ...) and we should
definitely utilize that.

It is true that "our" blkid library can not do that, but we should
actually stop using that and possibly remove it from e2fsprogs since
it's really out-of-date comparing to upstream libblkid from
util-linux.

I have some patches to do that, I can revive and resent it.

Thanks!
-Lukas

> +
>  #ifdef HAVE_LINUX_MAJOR_H
>  #ifndef MAJOR
>  #define MAJOR(dev)	((dev)>>8)
> diff --git a/misc/util.h b/misc/util.h
> index 9de3fbf..745568e 100644
> --- a/misc/util.h
> +++ b/misc/util.h
> @@ -20,6 +20,7 @@ extern char	*journal_location_string;
>   */
>  #define CHECK_BLOCK_DEV	0x0001
>  #define CREATE_FILE	0x0002
> +#define CHECK_FS_EXIST	0x0004
>  
>  #ifndef HAVE_STRCASECMP
>  extern int strcasecmp (char *s1, char *s2);
> 
