From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2 -v2] e2image: attempt to use ftruncate64 to set i_size
 for raw images
Date: Fri, 17 Feb 2012 21:19:43 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202172119270.10691@dhcp-27-109.brq.redhat.com>
References: <1329489163-21918-2-git-send-email-tytso@mit.edu> <1329489350-22260-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab2BQUTs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 15:19:48 -0500
In-Reply-To: <1329489350-22260-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 17 Feb 2012, Theodore Ts'o wrote:

> If ftruncate64() exists, try to use it to set i_size.  This isn't
> guaranteed to work, per SuSv3, but if it doesn't work, it's guaranteed
> to return an error.  So for file systems and/or operating systems that
> don't support extending i_size via ftruncate64(), fall back to writing
> the trailing null.

Looks good, thanks.

-Lukas

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
> 
> Oops, sent the wrong version of the patch.  My bad.
> 
>  misc/e2image.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/misc/e2image.c b/misc/e2image.c
> index 3cb92fe..93359cf 100644
> --- a/misc/e2image.c
> +++ b/misc/e2image.c
> @@ -510,8 +510,19 @@ static void output_meta_data_blocks(ext2_filsys fs, int fd)
>  			}
>  		}
>  	}
> +#ifdef HAVE_FTRUNCATE64
> +	if (sparse) {
> +		ext2_loff_t offset = ext2fs_llseek(fd, sparse, SEEK_CUR);
> +
> +		if (offset < 0)
> +			lseek_error_and_exit(errno);
> +		if (ftruncate64(fd, offset) < 0)
> +			write_block(fd, zero_buf, -1, 1, -1);
> +	}
> +#else
>  	if (sparse)
>  		write_block(fd, zero_buf, sparse-1, 1, -1);
> +#endif
>  	ext2fs_free_mem(&zero_buf);
>  	ext2fs_free_mem(&buf);
>  }
> 

