From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/3] mke2fs: print extra information about existing
 ext2/3/4 file systems
Date: Mon, 5 May 2014 15:45:17 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405051541080.2223@localhost.localdomain>
References: <1399295044-24489-1-git-send-email-tytso@mit.edu> <1399295044-24489-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932382AbaEENpV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 09:45:21 -0400
In-Reply-To: <1399295044-24489-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 5 May 2014, Theodore Ts'o wrote:

> Date: Mon,  5 May 2014 09:04:03 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 2/3] mke2fs: print extra information about existing ext2/3/4
>     file systems

Description missing.

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  misc/util.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/misc/util.c b/misc/util.c
> index 15b4ce5..d63e21b 100644
> --- a/misc/util.c
> +++ b/misc/util.c
> @@ -105,6 +105,41 @@ void proceed_question(int delay)
>  	signal(SIGALRM, SIG_IGN);
>  }
>  
> +static void print_ext2_info(const char *device)
> +
> +{
> +	struct ext2_super_block	*sb;
> +	ext2_filsys		fs;
> +	errcode_t		retval;
> +	time_t 			tm;
> +	char			buf[80];
> +
> +	retval = ext2fs_open2(device, 0, 0, 0, 0, unix_io_manager, &fs);
> +	if (retval)
> +		return;
> +	sb = fs->super;
> +
> +	if (sb->s_mtime) {
> +		tm = sb->s_mtime;
> +		if (sb->s_last_mounted[0]) {
> +			memset(buf, 0, sizeof(buf));
> +			strncpy(buf, sb->s_last_mounted,
> +				sizeof(sb->s_last_mounted));
> +			printf(_("\tlast mounted on %s on %s"), buf,
> +			       ctime(&tm));
> +		} else
> +			printf(_("\tlast mounted on %s"), ctime(&tm));
> +	} else if (sb->s_mkfs_time) {
> +		tm = sb->s_mkfs_time;
> +		printf(_("\tcreated on %s"), ctime(&tm));
> +	} else if (sb->s_mkfs_time) {
> +		tm = sb->s_mtime;
> +		printf(_("\tlast modified on %s"), ctime(&tm));
> +	}
> +	ext2fs_close(fs);
> +}
> +
> +
>  /*
>   * return 1 if the device looks plausible, creating the file if necessary
>   */
> @@ -168,6 +203,8 @@ int check_plausibility(const char *device, int flags, int *ret_is_dev)
>  		else
>  			printf(_("%s contains a %s file system\n"), device,
>  			       fs_type);
> +		if (strncmp(fs_type, "ext", 3) == 0)
> +			print_ext2_info(device);

Now I am actually confused, sorry. Which patches do I need to get this
context? I do not see this in the next branch.

Thanks!
-Lukas

>  		free(fs_type);
>  		free(fs_label);
>  		return 0;
> 
