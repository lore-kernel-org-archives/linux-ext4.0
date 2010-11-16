From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/7] e2fsprogs: Add discard_zeroes_data into struct_io_manager
Date: Tue, 16 Nov 2010 12:46:19 -0600
Message-ID: <4CE2D17B.6020808@redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com> <1288115658-7004-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab0KPSqX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 13:46:23 -0500
In-Reply-To: <1288115658-7004-3-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/26/10 12:54 PM, Lukas Czerner wrote:
> When the device have discard support and simultaneously discard zeroes
> data (and it is properly advertised), then we can take advantage of such
> behavior in several e2fsprogs tools.
> 
> Add new variable discard_zeroes_data into struct_io_manager structure so
> each io_manager can take advantage of this. Set it to 0 by default in
> unix_io_manager and test_io_manager and fill it with BLKDISCARDZEROES
> ioctl in unix_open.
> 
> Every other io_manager which would like to take advantage of this should
> set the default to 0 in its io_manager definition and then check and set
> the value preferably in *_open() function.

Hm, sticking this in struct_io_manager seems a little bit odd.  Wrong,
even ;).

Maybe this can go in the flags on the fs->io_channel?

-Eric

> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  lib/ext2fs/ext2_io.h |    1 +
>  lib/ext2fs/test_io.c |    1 +
>  lib/ext2fs/unix_io.c |   12 ++++++++++++
>  3 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
> index d202007..cc79fda 100644
> --- a/lib/ext2fs/ext2_io.h
> +++ b/lib/ext2fs/ext2_io.h
> @@ -85,6 +85,7 @@ struct struct_io_manager {
>  					int count, const void *data);
>  	errcode_t (*discard)(io_channel channel, unsigned long long block,
>  			     unsigned long long count, const void *data);
> +	int	discard_zeroes_data;
>  	long	reserved[16];
>  };
>  
> diff --git a/lib/ext2fs/test_io.c b/lib/ext2fs/test_io.c
> index 8d887a8..2fac849 100644
> --- a/lib/ext2fs/test_io.c
> +++ b/lib/ext2fs/test_io.c
> @@ -89,6 +89,7 @@ static struct struct_io_manager struct_test_manager = {
>  	test_get_stats,
>  	test_read_blk64,
>  	test_write_blk64,
> +	0,				/* discard zeroes data */
>  };
>  
>  io_manager test_io_manager = &struct_test_manager;
> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index 5b6cdec..b3908dc 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -133,6 +133,7 @@ static struct struct_io_manager struct_unix_manager = {
>  	unix_read_blk64,
>  	unix_write_blk64,
>  	unix_discard,
> +	0,				/* discard zeroes data */
>  };
>  
>  io_manager unix_io_manager = &struct_unix_manager;
> @@ -425,6 +426,12 @@ static errcode_t flush_cached_blocks(io_channel channel,
>  }
>  #endif /* NO_IO_CACHE */
>  
> +#ifdef __linux__
> +#ifndef BLKDISCARDZEROES
> +#define BLKDISCARDZEROES _IO(0x12,124)
> +#endif
> +#endif
> +
>  static errcode_t unix_open(const char *name, int flags, io_channel *channel)
>  {
>  	io_channel	io = NULL;
> @@ -487,6 +494,11 @@ static errcode_t unix_open(const char *name, int flags, io_channel *channel)
>  	}
>  #endif
>  
> +#ifdef BLKDISCARDZEROES
> +	ioctl(data->dev, BLKDISCARDZEROES,
> +		&unix_io_manager->discard_zeroes_data);
> +#endif
> +
>  #if defined(__CYGWIN__) || defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
>  	/*
>  	 * Some operating systems require that the buffers be aligned,

