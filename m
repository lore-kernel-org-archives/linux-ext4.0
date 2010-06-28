From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] EXT4: move aio completion after unwritten extent
 conversion
Date: Mon, 28 Jun 2010 10:49:56 -0400
Message-ID: <20100628144956.GA21331@infradead.org>
References: <20100624221534.299B62008@ruihe.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: hch@infradead.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, c@google.com
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0F1Ot5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jun 2010 10:49:57 -0400
Content-Disposition: inline
In-Reply-To: <20100624221534.299B62008@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>  	if (io_end->flag != EXT4_IO_UNWRITTEN){
>  		ext4_free_io_end(io_end);
>  		iocb->private = NULL;
> -		goto out;
> +out:
> +		if (is_async)
> +			aio_complete(iocb, ret, 0);
> +		return;

I'd suggest keeping the out label at the end of the function.  Without
that the code gets unreadable very quickly.

>  	io_end->size = size;
> -	io_end->flag = EXT4_IO_UNWRITTEN;

Why is this initialization removed?

