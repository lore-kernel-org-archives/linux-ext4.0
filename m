From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] REQ_META set during meta data write
Date: Sat, 3 Mar 2012 04:34:41 -0500
Message-ID: <20120303093441.GB8417@infradead.org>
References: <1330692309-6187-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	saugata.das@linaro.org, arnd.bergmann@linaro.org, tytso@mit.edu,
	adilger@whamcloud.com, venkat@linaro.org
To: Saugata Das <saugata.das@stericsson.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48866
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab2CCJen (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Mar 2012 04:34:43 -0500
Content-Disposition: inline
In-Reply-To: <1330692309-6187-1-git-send-email-saugata.das@stericsson.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 02, 2012 at 06:15:09PM +0530, Saugata Das wrote:
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2926,6 +2926,9 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	if (test_set_buffer_req(bh) && (rw & WRITE))
>  		clear_buffer_write_io_error(bh);
>  
> +	if (buffer_meta(bh))
> +		rw |= REQ_META;
> +

submit_bh has a perfectly valid rw argument where you can pass REQ_META.
Please use that instead of abusing a buffer state bit for an I/O
submission flag.

