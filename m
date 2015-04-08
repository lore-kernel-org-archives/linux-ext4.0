From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [patch] ext4 crypto: testing the wrong variable
Date: Wed, 8 Apr 2015 12:15:37 -0600
Message-ID: <2555D7A9-9B9C-4F8D-A1CA-282FB5FE6C59@dilger.ca>
References: <20150408085338.GA8837@mwanda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Michael Halcrow <mhalcrow@google.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20150408085338.GA8837@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Apr 8, 2015, at 2:53 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> The intention was to check "IS_ERR(*buf)" instead of "IS_ERR(buf)".
> It's never an ERR_PTR() in the current code so this is a harmless
> mistake.

I was a little confused about this patch, thinking that the ext4 crypto
code had already been merged into master for some reason.  It would
probably have been better as a review comment on the actual patch
"[PATCH 14/22] ext4 crypto: filename encryption facilities" so it isn't
missed when the series is refreshed?

Cheers, Andreas

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> I have a static checker warning for when people check IS_ERR() and it's
> not an error pointer.  Adding these extra checks introduces deliberate
> warnings and makes my work harder which means that bugs are missed.
> 
> Also there is no good reason to pass an ERR_PTR to
> ext4_fname_crypto_free_buffer() but eventually someone will take
> advantage of this feature to write ugly code.  Ugly code is going to be
> buggy.
> 
> At least do a "if (WARN_ON(IS_ERR(*buf))) return;".  I could filter out
> impossible conditions which are inside a WARN_ON() and it will mean
> people don't actually pass error pointers here.
> 
> diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
> index 5fda403..f076b52 100644
> --- a/fs/ext4/crypto_fname.c
> +++ b/fs/ext4/crypto_fname.c
> @@ -558,7 +558,7 @@ int ext4_fname_crypto_alloc_buffer(struct ext4_fname_crypto_ctx *ctx,
>  */
> void ext4_fname_crypto_free_buffer(void **buf)
> {
> -	if (*buf == NULL || IS_ERR(buf))
> +	if (*buf == NULL || IS_ERR(*buf))
> 		return;
> 	kfree(*buf);
> 	*buf = NULL;


Cheers, Andreas





