From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [patch] ext4 crypto: testing the wrong variable
Date: Wed, 8 Apr 2015 11:51:42 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1504081150401.9503@hadrien>
References: <20150408085338.GA8837@mwanda>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Theodore Ts'o <tytso@mit.edu>,
	Michael Halcrow <mhalcrow@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150408085338.GA8837@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>  void ext4_fname_crypto_free_buffer(void **buf)
>  {
> -	if (*buf == NULL || IS_ERR(buf))
> +	if (*buf == NULL || IS_ERR(*buf))

Why not use IS_ERR_OR_NULL?

julia

>  		return;
>  	kfree(*buf);
>  	*buf = NULL;
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
