From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 2/2] ext4: fix up ext4_try_to_write_inline_data()
Date: Tue, 6 Jun 2017 20:54:42 -0700
Message-ID: <20170607035442.GB594@zzz>
References: <20170606000359.16794-1-tytso@mit.edu>
 <20170606000359.16794-2-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        gnehzuil.liu@gmail.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33785 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751252AbdFGDyo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jun 2017 23:54:44 -0400
Received: by mail-pg0-f65.google.com with SMTP id a70so227838pge.0
        for <linux-ext4@vger.kernel.org>; Tue, 06 Jun 2017 20:54:44 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170606000359.16794-2-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 05, 2017 at 08:03:59PM -0400, Theodore Ts'o wrote:
> There were a number of bugs in ext4_try_to_write_inline_data() and the
> ext4_convert_inline_data_to_extent() function (which was only used by
> ext4_try_to_write_inline_data).
> 
> For ext4_convert_inline_data_to_extent():
> 
> * It didn't handle the dioread_nolock case correctly
>   * It didn't convert the extent tree entry from unwritten to written.
>   * It didn't correctly handle racing DIO reads
> * It didn't handle data=journal case correctly -- it doesn't follow
>   the block modification correctly by failing to call
>   ext4_handle_dirty_metadata() on the data block.
> 
> We fix this by eliminating ext4_convert_inline_data_to_extent()
> completely, and use reg_convert_inline_data_nolock() since it has been
> fixed to be Completely Correct (tm).  :-)
> 

Is ext4_da_convert_inline_data_to_extent() broken too?

>  /*
>   * Try to write data in the inode.
>   * If the inode has inline data, check whether the new write can be
> @@ -662,13 +553,19 @@ int ext4_try_to_write_inline_data(struct address_space *mapping,
>  	struct page *page;
>  	struct ext4_iloc iloc;
>  
> -	if (pos + len > ext4_get_max_inline_size(inode))
> -		goto convert;
> -
>  	ret = ext4_get_inode_loc(inode, &iloc);
>  	if (ret)
>  		return ret;
>  
> +	page = grab_cache_page_write_begin(mapping, 0, flags);
> +	if (!page) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +

Likewise, doesn't the page lock rank below transaction start?  Also this jumps
to 'out' which looks at 'handle' before it's been initialized.

Eric
