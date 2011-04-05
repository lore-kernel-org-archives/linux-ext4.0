From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: don't set stripe/stride to 1 block in mkfs
Date: Mon, 4 Apr 2011 22:10:19 -1000
Message-ID: <F8519658-E9FA-4DD5-9980-59006CDACC8C@dilger.ca>
References: <4D9A17F8.4000406@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Zeev Tarantov <zeev.tarantov@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63389 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1DEIKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 04:10:21 -0400
In-Reply-To: <4D9A17F8.4000406@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-04, at 9:11 AM, Eric Sandeen wrote:
> Block devices may set minimum or optimal IO hints equal to
> blocksize; in this case there is really nothing for ext4
> to do with this information (i.e. search for a block-aligned
> allocation?) so don't set fs geometry with single-block
> values.
> 
> Zeev also reported that with a block-sized stripe, the
> ext4 allocator spends time spinning in ext4_mb_scan_aligned(),
> oddly enough.
> 
> Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 9798b88..74b838c 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1135,8 +1135,11 @@ static int get_device_geometry(const char *file,
> 	if ((opt_io == 0) && (psector_size > blocksize))
> 		opt_io = psector_size;
> 
> -	fs_param->s_raid_stride = min_io / blocksize;
> -	fs_param->s_raid_stripe_width = opt_io / blocksize;
> +	/* setting stripe/stride to blocksize is pointless */
> +	if (min_io > blocksize)
> +		fs_param->s_raid_stride = min_io / blocksize;
> +	if (opt_io > blocksize)
> +		fs_param->s_raid_stripe_width = opt_io / blocksize;

I don't think it is harmful to specify an mballoc alignment that is an even multiple of the underlying device IO size (e.g. at least 256kB or 512kB).

If the underlying device (e.g. zram) is reporting 16kB or 64kB opt_io size because that is PAGE_SIZE, but blocksize is 4kB, then we will have the same performance problem again.

Cheers, Andreas





