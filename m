From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
Date: Mon, 25 Jun 2012 20:32:18 +0100
Message-ID: <20120625193218.GZ21859@amd.home.annexia.org>
References: <4FDEC3C2.4060909@secunet.com>
 <20120625113457.GA1289@amd.home.annexia.org>
 <x49r4t3z6s4.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49r4t3z6s4.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 25, 2012 at 12:38:03PM -0400, Jeff Moyer wrote:
> Please try the attached patch instead.  The patch I had originally
> posted for this allowed marking the first buffer beyond EOD as
> uptodate.  This isn't correct.  The patch I've attached below fixes the
> infinite loop in __getblk_slow.

This patch appears to fix both problems, thanks.

Rich.

> Cheers,
> Jeff
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 838a9cf..c7062c8 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1036,6 +1036,9 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
>  static struct buffer_head *
>  __getblk_slow(struct block_device *bdev, sector_t block, int size)
>  {
> +	int ret;
> +	struct buffer_head *bh;
> +
>  	/* Size must be multiple of hard sectorsize */
>  	if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
>  			(size < 512 || size > PAGE_SIZE))) {
> @@ -1048,20 +1051,21 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
>  		return NULL;
>  	}
>  
> -	for (;;) {
> -		struct buffer_head * bh;
> -		int ret;
> +retry:
> +	bh = __find_get_block(bdev, block, size);
> +	if (bh)
> +		return bh;
>  
> +	ret = grow_buffers(bdev, block, size);
> +	if (ret == 0) {
> +		free_more_memory();
> +		goto retry;
> +	} else if (ret > 0) {
>  		bh = __find_get_block(bdev, block, size);
>  		if (bh)
>  			return bh;
> -
> -		ret = grow_buffers(bdev, block, size);
> -		if (ret < 0)
> -			return NULL;
> -		if (ret == 0)
> -			free_more_memory();
>  	}
> +	return NULL;
>  }
>  
>  /*

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
