From: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
Date: Wed, 20 Jun 2012 08:14:01 +0200
Message-ID: <4FE16A29.9050508@secunet.com>
References: <4FDEC3C2.4060909@secunet.com> <x49fw9smohy.fsf@segfault.boston.devel.redhat.com> <4FE0155A.6010404@secunet.com> <x49ehpbjiyp.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jaxboe@fusionio.com>,
	Nick Piggin <npiggin@kernel.dk>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49ehpbjiyp.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am 19.06.2012 19:43, schrieb Jeff Moyer:

[...]

> diff --git a/fs/buffer.c b/fs/buffer.c
> index 838a9cf..769b30b 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -930,7 +930,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
>  			bh->b_blocknr = block;
>  			if (uptodate)
>  				set_buffer_uptodate(bh);
> -			if (block < end_block)
> +			if (block <= end_block)
>  				set_buffer_mapped(bh);
>  		}
>  		block++;

I can confirm that this patch fixes the problem for my test case too.
Here is the kernel output when performing the mount operation:

attempt to access beyond end of device
sda4: rw=0, want=4, limit=2
EXT3-fs (sda4): error: unable to read superblock

	Torsten
