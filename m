From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/7] e2fsprogs: Add discard function into struct_io_manager
Date: Tue, 16 Nov 2010 12:28:37 -0600
Message-ID: <4CE2CD55.9070207@redhat.com>
References: <1288115658-7004-1-git-send-email-lczerner@redhat.com> <1288115658-7004-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab0KPS2t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 13:28:49 -0500
In-Reply-To: <1288115658-7004-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/26/10 12:54 PM, Lukas Czerner wrote:
> In order to provide generic "discard" function for all e2fsprogs tools
> add a discard function prototype into struct_io_manager. Specific
> function for specific io managers can be crated that way.
> 
> This commit also creates unix_discard function which uses BLKDISCARD
> ioctl to discard data blocks on the block device and bind it into
> unit_io_manager structure to be available for all e2fsprogs tools.
> Note that BLKDISCARD is still Linux specific ioctl, however other
> unix systems may provide similar functionality. So far the
> unix_discard() remains linux specific hence is embedded in #ifdef
> __linux__ macro.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  lib/ext2fs/ext2_io.h |    2 ++
>  lib/ext2fs/unix_io.c |   41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
> index ccc9c8b..d202007 100644
> --- a/lib/ext2fs/ext2_io.h
> +++ b/lib/ext2fs/ext2_io.h
> @@ -83,6 +83,8 @@ struct struct_io_manager {
>  					int count, void *data);
>  	errcode_t (*write_blk64)(io_channel channel, unsigned long long block,
>  					int count, const void *data);
> +	errcode_t (*discard)(io_channel channel, unsigned long long block,
> +			     unsigned long long count, const void *data);
>  	long	reserved[16];
>  };
>  
> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index 1df1fdd..5b6cdec 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -115,6 +115,8 @@ static errcode_t unix_read_blk64(io_channel channel, unsigned long long block,
>  			       int count, void *data);
>  static errcode_t unix_write_blk64(io_channel channel, unsigned long long block,
>  				int count, const void *data);
> +static errcode_t unix_discard(io_channel channel, unsigned long long block,
> +			      unsigned long long count, const void *data);
>  
>  static struct struct_io_manager struct_unix_manager = {
>  	EXT2_ET_MAGIC_IO_MANAGER,
> @@ -130,6 +132,7 @@ static struct struct_io_manager struct_unix_manager = {
>  	unix_get_stats,
>  	unix_read_blk64,
>  	unix_write_blk64,
> +	unix_discard,
>  };
>  
>  io_manager unix_io_manager = &struct_unix_manager;
> @@ -834,3 +837,41 @@ static errcode_t unix_set_option(io_channel channel, const char *option,
>  	}
>  	return EXT2_ET_INVALID_ARGUMENT;
>  }
> +
> +#ifdef __linux__
> +
> +#ifndef BLKDISCARD
> +#define BLKDISCARD	_IO(0x12,119)
> +#endif
> +
> +static errcode_t unix_discard(io_channel channel, unsigned long long block,
> +			     unsigned long long count, const void *data)
> +{
> +
> +	struct struct_ext2_filsys *fs;
> +	struct unix_private_data *u_priv;
> +	errcode_t	retval = 0;
> +	__uint64_t	range[2];
> +	int		blocksize;
> +
> +	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
> +	u_priv = (struct unix_private_data *) channel->private_data;
> +	EXT2_CHECK_MAGIC(u_priv, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
> +
> +	fs = (struct struct_ext2_filsys *) data;
> +	if (!fs)
> +		return EXT2_ET_INVALID_ARGUMENT;
> +
> +	blocksize = EXT2_BLOCK_SIZE(fs->super);

This seems a little convoluted; you pass in *data, which gets you the fs,
from which you get the super, from which you get the blocksize,
which is all that you ever actually use here:

> +	range[0] = (__uint64_t)(block);
> +	range[1] = (__uint64_t)(count);
> +	range[0] *= (__uint64_t)(blocksize);
> +	range[1] *= (__uint64_t)(blocksize);

any reason to not just pass in the blocksize?

Maybe this is for flexibility for not-linux, but I guess we don't know what
they need anyway...?

And if you do that you can change "u_priv" to "data" just to match the
other handlers, perhaps.

-Eric

> +	return ioctl(u_priv->dev, BLKDISCARD, &range);
> +}
> +
> +#else
> +#define unix_discard(channel, block, count)	EXT2_ET_UNIMPLEMENTED
> +#endif

