From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 4/7] mke2fs: create a regular file if necessary
Date: Mon, 05 May 2014 10:17:30 -0500
Message-ID: <5367AB8A.8000408@redhat.com>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu> <1398556834-31913-4-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaEEPRd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 11:17:33 -0400
In-Reply-To: <1398556834-31913-4-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/26/14, 7:00 PM, Theodore Ts'o wrote:
> This is useful when creating a filesystem for use with a VM, for
> example.

Ok, backing up to here from the "print if we're creating a file" thread.

Considering the questions about typos in /dev/$FOO etc, why is it desirable
to create the file within mke2fs?  If you're making it for a VM, wouldn't
you want to control the creation (i.e. fallocated vs. sparse, for example,
as well as permissions) and not just have things magically happen?

fallocate -l 8g myfile; mkfs.ext4 myfile
or
truncate -s 8589934592 myfile; mkfs.ext4 myfile

doesn't seem all that onerous.

-Eric

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  misc/mke2fs.c |  3 ++-
>  misc/util.c   | 20 ++++++++++++++++----
>  misc/util.h   |  1 +
>  3 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index fa61e7b..a2b1f65 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1749,7 +1749,8 @@ profile_error:
>  	if (optind < argc)
>  		usage();
>  
> -	if (!check_plausibility(device_name, 0, &is_device) && !force)
> +	if (!check_plausibility(device_name, CREATE_FILE,
> +				&is_device) && !force)
>  		proceed_question();
>  
>  	check_mount(device_name, force, _("filesystem"));
> diff --git a/misc/util.c b/misc/util.c
> index 08ec761..f85942e 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -13,6 +13,7 @@
>  #define _LARGEFILE64_SOURCE
>  
>  #include "config.h"
> +#include <fcntl.h>
>  #include <stdio.h>
>  #include <string.h>
>  #ifdef HAVE_ERRNO_H
> @@ -21,6 +22,7 @@
>  #ifdef HAVE_LINUX_MAJOR_H
>  #include <linux/major.h>
>  #endif
> +#include <sys/types.h>
>  #ifdef HAVE_SYS_STAT_H
>  #include <sys/stat.h>
>  #endif
> @@ -85,19 +87,29 @@ void proceed_question(void)
>   */
>  int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  {
> -	int val, is_dev = 0;
> +	int fd, is_dev = 0;
>  	ext2fs_struct_stat s;
> +	int fl = O_RDONLY;
>  
> -	val = ext2fs_stat(device, &s);
> +	if (flags & CREATE_FILE)
> +		fl |= O_CREAT;
>  
> -	if(val == -1) {
> -		fprintf(stderr, _("Could not stat %s --- %s\n"),
> +	fd = open(device, fl, 0666);
> +	if (fd < 0) {
> +		fprintf(stderr, _("Could not open %s: %s\n"),
>  			device, error_message(errno));
>  		if (errno == ENOENT)
>  			fputs(_("\nThe device apparently does not exist; "
>  				"did you specify it correctly?\n"), stderr);
>  		exit(1);
>  	}
> +
> +	if (ext2fs_fstat(fd, &s) < 0) {
> +		perror("stat");
> +		exit(1);
> +	}
> +	close(fd);
> +
>  	if (S_ISBLK(s.st_mode))
>  		is_dev = 1;
>  #if defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
> diff --git a/misc/util.h b/misc/util.h
> index 867f4b0..b80d489 100644
> --- a/misc/util.h
> +++ b/misc/util.h
> @@ -19,6 +19,7 @@ extern char	*journal_location_string;
>   * Flags for check_plausibility()
>   */
>  #define CHECK_BLOCK_DEV	0x0001
> +#define CREATE_FILE	0x0002
>  
>  #ifndef HAVE_STRCASECMP
>  extern int strcasecmp (char *s1, char *s2);
> 

