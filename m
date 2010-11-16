From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 7/7] mke2fs: Use io_manager discard_zeroes_data property
Date: Tue, 16 Nov 2010 15:18:06 -0600
Message-ID: <4CE2F50E.5010208@redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com> <1288115658-7004-8-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932474Ab0KPVSK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 16:18:10 -0500
In-Reply-To: <1288115658-7004-8-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/26/10 12:54 PM, Lukas Czerner wrote:
> We already have discard_zeroes_data variable in struct_io_manager
> structure, so we do nod need mke2fs_discard_zeroes_data() function
> anymore.

OK in spirit I think but I think you may need a new home for
discard_zeroes_data.  :)

-Eric

> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  misc/mke2fs.c |   27 +--------------------------
>  1 files changed, 1 insertions(+), 26 deletions(-)
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 09ce711..114987c 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1900,31 +1900,6 @@ static int mke2fs_setup_tdb(const char *name, io_manager *io_ptr)
>  	return retval;
>  }
>  
> -#ifdef __linux__
> -
> -#ifndef BLKDISCARDZEROES
> -#define BLKDISCARDZEROES _IO(0x12,124)
> -#endif
> -
> -static int mke2fs_discard_zeroes_data(ext2_filsys fs)
> -{
> -	int fd;
> -	int ret;
> -	int discard_zeroes_data = 0;
> -
> -	fd = open64(fs->device_name, O_RDWR);
> -
> -	if (fd > 0) {
> -		ioctl(fd, BLKDISCARDZEROES, &discard_zeroes_data);
> -		close(fd);
> -	}
> -	return discard_zeroes_data;
> -}
> -#else
> -#define mke2fs_discard_blocks(fs)	1
> -#define mke2fs_discard_zeroes_data(fs)	0
> -#endif
> -
>  int main (int argc, char *argv[])
>  {
>  	errcode_t	retval = 0;
> @@ -1997,7 +1972,7 @@ int main (int argc, char *argv[])
>  				printf(_("succeeded.\n"));
>  		}
>  
> -		if (!retval && mke2fs_discard_zeroes_data(fs)) {
> +		if (!retval && io_ptr->discard_zeroes_data) {
>  			if (verbose)
>  				printf(_("Discard succeeded and will return 0s "
>  					 " - skipping inode table wipe\n"));

