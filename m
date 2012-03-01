From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] REQ_META set during meta data write
Date: Thu, 1 Mar 2012 13:33:27 -0500
Message-ID: <20120301183327.GA32588@thunk.org>
References: <1330625463-5683-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	saugata.das@linaro.org, arnd.bergmann@linaro.org,
	adilger@whamcloud.com
To: Saugata Das <saugata.das@stericsson.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43148 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028Ab2CASdb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Mar 2012 13:33:31 -0500
Content-Disposition: inline
In-Reply-To: <1330625463-5683-1-git-send-email-saugata.das@stericsson.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 01, 2012 at 11:41:03PM +0530, Saugata Das wrote:
> From: Saugata Das <saugata.das@linaro.org>
> 
> Today, storage devices like eMMC has special features like data tagging
> (introduced in MMC-4.5 version) in order to improve performance of some
> specific writes. On MMC stack, data tagging is used for all writes which has
> REQ_META flag set. On EXT4, however, currently REQ_META is set only for read.
> This patch adds the capability to add REQ_META flag during meta data write.
> This patch adds new function set_buffer_meta, which is used to set a bit
> BH_Meta in the b_state field when meta data and super block is made dirty.
> 
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2926,6 +2926,9 @@ int submit_bh(int rw, struct buffer_head * bh)
>  	if (test_set_buffer_req(bh) && (rw & WRITE))
>  		clear_buffer_write_io_error(bh);
>  
> +	if (buffer_meta(bh) && (rw & WRITE))
> +		rw |= REQ_META;
> +

I know it's not necessary for your purposes as stated in the commit
description, but wouldn't it be better if buffer_meta() always caused
REQ_META to be set, regardless of whether we are doing a read or a
write?

					- Ted
