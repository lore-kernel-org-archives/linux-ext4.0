From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] deny partial write for loop dev fd
Date: Mon, 18 Jun 2007 04:39:11 +0200
Message-ID: <20070618023911.GA27707@wotan.suse.de>
References: <20070613134631.GB13815@localhost.sw.ru> <Pine.LNX.4.64.0706131426070.4539@blonde.wat.veritas.com> <20070613172939.GE13815@localhost.sw.ru> <Pine.LNX.4.64.0706131543380.10580@blonde.wat.veritas.com> <20070616153917.GC14349@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
	mark.fasheh@oracle.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXFRCjQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jun 2007 22:39:16 -0400
Content-Disposition: inline
In-Reply-To: <20070616153917.GC14349@localhost.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 16, 2007 at 07:39:17PM +0400, Dmitriy Monakhov wrote:
> Partial write can be easily supported by LO_CRYPT_NONE mode, but
> it is not easy in LO_CRYPT_CRYPTOAPI case, because of its block nature.
> I don't know who still used cryptoapi, but theoretically it is possible.
> So let's leave things as they are. Loop device doesn't support partial
> write before Nick's "write_begin/write_end" patch set, and let's it 
> behave the same way after.

OK... but just bailing out here doesn't exactly solve the problem,
does it? Some data is already written at this point, so failing
just means that the underlying file just gets corrupted instead.

OTOH, my attempt to support partial writes isn't right anyway,
because it doesn't get propogated back to the caller correctly
anyway.

So we'll go with your patch, thanks.


> 
> Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
> ---
>  drivers/block/loop.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 4bab9b1..de122f3 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -244,10 +244,8 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
>  
>  		ret = pagecache_write_end(file, mapping, pos, size, copied,
>  							page, fsdata);
> -		if (ret < 0)
> +		if (ret < 0 || ret != copied)
>  			goto fail;
> -		if (ret < copied)
> -			copied = ret;
>  
>  		if (unlikely(transfer_result))
>  			goto fail;
> -- 
> 1.5.2
> 
