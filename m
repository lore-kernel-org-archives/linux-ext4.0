From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/7] mke2fs: don't complain if the regular file is too
 small
Date: Mon, 28 Apr 2014 10:26:12 -0500
Message-ID: <535E7314.8010205@redhat.com>
References: <1398556834-31913-1-git-send-email-tytso@mit.edu> <1398556834-31913-3-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932715AbaD1P0Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2014 11:26:16 -0400
In-Reply-To: <1398556834-31913-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/26/14, 7:00 PM, Theodore Ts'o wrote:
> Don't ask the user if it's OK that a regular file is smaller than the
> requested size.  This test only makes sense if we are creating the
> file system on a block device.  This allow users to not need to
> manually answer the "proceed?" question when creating a file system
> backed by a simple file.

I wonder if it'd be better to just attempt to write the last
block before we start marching through the block groups - then
we can just fail outright if the mkfs won't work, rather than
asking questions based on things we could find out programatically...?

-Eric

> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  misc/mke2fs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 3c62ede..fa61e7b 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1383,7 +1383,7 @@ static void PRS(int argc, char *argv[])
>  	unsigned long	flex_bg_size = 0;
>  	double		reserved_ratio = -1.0;
>  	int		lsector_size = 0, psector_size = 0;
> -	int		show_version_only = 0;
> +	int		show_version_only = 0, is_device = 0;
>  	unsigned long long num_inodes = 0; /* unsigned long long to catch too-large input */
>  	errcode_t	retval;
>  	char *		oldpath = getenv("PATH");
> @@ -1749,7 +1749,7 @@ profile_error:
>  	if (optind < argc)
>  		usage();
>  
> -	if (!check_plausibility(device_name, 0, NULL) && !force)
> +	if (!check_plausibility(device_name, 0, &is_device) && !force)
>  		proceed_question();
>  
>  	check_mount(device_name, force, _("filesystem"));
> @@ -1793,7 +1793,7 @@ profile_error:
>  				fs_blocks_count &= ~((blk64_t) ((sys_page_size /
>  					     EXT2_BLOCK_SIZE(&fs_param))-1));
>  		}
> -	} else if (!force && (fs_blocks_count > dev_size)) {
> +	} else if (!force && is_device && (fs_blocks_count > dev_size)) {
>  		com_err(program_name, 0, "%s",
>  			_("Filesystem larger than apparent device size."));
>  		proceed_question();
> 

