From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] libext2fs: support BLKZEROOUT/FALLOC_FL_ZERO_RANGE
 in ext2fs_zero_blocks
Date: Tue, 13 May 2014 13:11:26 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1405131310470.2070@localhost.localdomain>
References: <20140501231222.31890.82860.stgit@birch.djwong.org> <20140501231407.31890.3876.stgit@birch.djwong.org> <alpine.LFD.2.00.1405061736390.2255@localhost.localdomain> <20140506195938.GD25745@birch.djwong.org> <alpine.LFD.2.00.1405071045090.2128@localhost.localdomain>
 <20140507213704.GA8923@birch.djwong.org> <20140508001337.GC8923@birch.djwong.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1329019339-1399979489=:2070"
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758855AbaEMLLc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 May 2014 07:11:32 -0400
In-Reply-To: <20140508001337.GC8923@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1329019339-1399979489=:2070
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Wed, 7 May 2014, Darrick J. Wong wrote:

> Date: Wed, 7 May 2014 17:13:37 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: Luká¨ Czerner <lczerner@redhat.com>
> Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
> Subject: [PATCH 1/2] libext2fs: support BLKZEROOUT/FALLOC_FL_ZERO_RANGE in
>     ext2fs_zero_blocks
> 
> Here's the first part, which teaches the IO manager how to connect with the
> zero out ioctls.
> 
> --D
> ---
> Plumb a new call into the IO manager to support translating
> ext2fs_zero_blocks calls into the equivalent kernel-level BLKZEROOUT
> ioctl or FALLOC_FL_ZERO_RANGE fallocate flag primitives.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/ext2_io.h    |    7 +++++-
>  lib/ext2fs/io_manager.c |   11 ++++++++++
>  lib/ext2fs/mkjournal.c  |    6 +++++
>  lib/ext2fs/unix_io.c    |   54 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 77 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/ext2fs/ext2_io.h b/lib/ext2fs/ext2_io.h
> index 1894fb8..98d56aa 100644
> --- a/lib/ext2fs/ext2_io.h
> +++ b/lib/ext2fs/ext2_io.h
> @@ -90,7 +90,9 @@ struct struct_io_manager {
>  					int count, const void *data);
>  	errcode_t (*discard)(io_channel channel, unsigned long long block,
>  			     unsigned long long count);
> -	long	reserved[16];
> +	errcode_t (*zeroout)(io_channel channel, unsigned long long block,
> +			     unsigned long long count);
> +	long	reserved[15];
>  };
>  
>  #define IO_FLAG_RW		0x0001
> @@ -122,6 +124,9 @@ extern errcode_t io_channel_write_blk64(io_channel channel,
>  extern errcode_t io_channel_discard(io_channel channel,
>  				    unsigned long long block,
>  				    unsigned long long count);
> +extern errcode_t io_channel_zeroout(io_channel channel,
> +				    unsigned long long block,
> +				    unsigned long long count);
>  extern errcode_t io_channel_alloc_buf(io_channel channel,
>  				      int count, void *ptr);
>  
> diff --git a/lib/ext2fs/io_manager.c b/lib/ext2fs/io_manager.c
> index 34e4859..569d16a 100644
> --- a/lib/ext2fs/io_manager.c
> +++ b/lib/ext2fs/io_manager.c
> @@ -112,6 +112,17 @@ errcode_t io_channel_discard(io_channel channel, unsigned long long block,
>  	return EXT2_ET_UNIMPLEMENTED;
>  }
>  
> +errcode_t io_channel_zeroout(io_channel channel, unsigned long long block,
> +			     unsigned long long count)
> +{
> +	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
> +
> +	if (channel->manager->zeroout)
> +		return (channel->manager->zeroout)(channel, block, count);
> +
> +	return EXT2_ET_UNIMPLEMENTED;
> +}
> +
>  errcode_t io_channel_alloc_buf(io_channel io, int count, void *ptr)
>  {
>  	size_t	size;
> diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> index 884d9c0..339c7e1 100644
> --- a/lib/ext2fs/mkjournal.c
> +++ b/lib/ext2fs/mkjournal.c
> @@ -167,6 +167,12 @@ errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
>  		}
>  		return 0;
>  	}
> +
> +	/* Try a zero out command, if supported */
> +	retval = io_channel_zeroout(fs->io, blk, num);
> +	if (retval == 0)
> +		return 0;

I guess that this should have been in the second patch ? But it's
not a big deal. It looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!
-Lukas

> +
>  	/* Allocate the zeroizing buffer if necessary */
>  	if (!buf) {
>  		buf = malloc(fs->blocksize * STRIDE_LENGTH);
> diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
> index c3185b6..d070cb0 100644
> --- a/lib/ext2fs/unix_io.c
> +++ b/lib/ext2fs/unix_io.c
> @@ -922,6 +922,59 @@ unimplemented:
>  	return EXT2_ET_UNIMPLEMENTED;
>  }
>  
> +#if defined(__linux__) && !defined(BLKZEROOUT)
> +#define BLKZEROOUT		_IO(0x12,127)
> +#endif
> +
> +#if defined(__linux__) && !defined(FALLOC_FL_ZERO_RANGE)
> +#define FALLOC_FL_ZERO_RANGE    0x10
> +#endif
> +
> +static errcode_t unix_zeroout(io_channel channel, unsigned long long block,
> +			      unsigned long long count)
> +{
> +	struct unix_private_data *data;
> +	int		ret;
> +
> +	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
> +	data = (struct unix_private_data *) channel->private_data;
> +	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
> +
> +	if (channel->flags & CHANNEL_FLAGS_BLOCK_DEVICE) {
> +#ifdef BLKZEROOUT
> +		__u64 range[2];
> +
> +		range[0] = (__u64)(block) * channel->block_size;
> +		range[1] = (__u64)(count) * channel->block_size;
> +
> +		ret = ioctl(data->dev, BLKZEROOUT, &range);
> +#else
> +		goto unimplemented;
> +#endif
> +	} else {
> +#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_ZERO_RANGE)
> +		/*
> +		 * If we are not on block device, try to use the zero out
> +		 * primitive.
> +		 */
> +		ret = fallocate(data->dev,
> +				FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
> +				(off_t)(block) * channel->block_size,
> +				(off_t)(count) * channel->block_size);
> +#else
> +		goto unimplemented;
> +#endif
> +	}
> +	if (ret < 0) {
> +		if (errno == EOPNOTSUPP)
> +			goto unimplemented;
> +		return errno;
> +	}
> +	return 0;
> +unimplemented:
> +	return EXT2_ET_UNIMPLEMENTED;
> +}
> +
>  static struct struct_io_manager struct_unix_manager = {
>  	EXT2_ET_MAGIC_IO_MANAGER,
>  	"Unix I/O Manager",
> @@ -937,6 +990,7 @@ static struct struct_io_manager struct_unix_manager = {
>  	unix_read_blk64,
>  	unix_write_blk64,
>  	unix_discard,
> +	unix_zeroout,
>  };
>  
>  io_manager unix_io_manager = &struct_unix_manager;
> 
--8323328-1329019339-1399979489=:2070--
