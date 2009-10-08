From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] debugfs: open with EXT2_FLAG_64BITS
Date: Thu, 08 Oct 2009 15:17:00 -0500
Message-ID: <4ACE48BC.7010505@redhat.com>
References: <4AAA6A44.90902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbZJHUR1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Oct 2009 16:17:27 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n98KH1m3008108
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 16:17:01 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n98KH0HX030339
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 16:17:00 -0400
In-Reply-To: <4AAA6A44.90902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Pointing debugfs from the pu branch at a large filesystem is
> still failing with:
> 
>  Filesystem too large to use legacy bitmaps while reading block bitmap
> 
> We need to open with EXT2_FLAG_64BITS; I'm not sure if this
> should be a switch based on the size of the fs or not?
> 
> But in any case the below gets things moving enough to
> use debugfs on a large filesystem.

ping?

Thanks,
-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> index 3bb309f..fbebae7 100644
> --- a/debugfs/debugfs.c
> +++ b/debugfs/debugfs.c
> @@ -127,7 +127,7 @@ void do_open_filesys(int argc, char **argv)
>  	int	catastrophic = 0;
>  	blk64_t	superblock = 0;
>  	blk64_t	blocksize = 0;
> -	int	open_flags = EXT2_FLAG_SOFTSUPP_FEATURES;
> +	int	open_flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS; 
>  	char	*data_filename = 0;
>  
>  	reset_getopt();
> @@ -2148,7 +2148,7 @@ int main(int argc, char **argv)
>  	int		sci_idx;
>  	const char	*usage = "Usage: %s [-b blocksize] [-s superblock] [-f cmd_file] [-R request] [-V] [[-w] [-c] device]";
>  	int		c;
> -	int		open_flags = EXT2_FLAG_SOFTSUPP_FEATURES;
> +	int		open_flags = EXT2_FLAG_SOFTSUPP_FEATURES | EXT2_FLAG_64BITS;
>  	char		*request = 0;
>  	int		exit_status = 0;
>  	char		*cmd_file = 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

