From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ext4 crypto: remove unneeded assignation
Date: Wed, 08 Jul 2015 12:55:39 -0700
Message-ID: <1436385339.2682.93.camel@perches.com>
References: <1436385075-22559-1-git-send-email-laurent.navet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Laurent Navet <laurent.navet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436385075-22559-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2015-07-08 at 21:51 +0200, Laurent Navet wrote:
> Return value of ext4_derive_key_aes() is stored but never used before
> being overwritten.
> Also fix coverity CID 1309760.
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  fs/ext4/crypto_key.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
> index 442d24e..92f9172 100644
> --- a/fs/ext4/crypto_key.c
> +++ b/fs/ext4/crypto_key.c
> @@ -218,7 +218,7 @@ retry:
>  	BUILD_BUG_ON(EXT4_AES_128_ECB_KEY_SIZE !=
>  		     EXT4_KEY_DERIVATION_NONCE_SIZE);
>  	BUG_ON(master_key->size != EXT4_AES_256_XTS_KEY_SIZE);
> -	res = ext4_derive_key_aes(ctx.nonce, master_key->raw,
> +	ext4_derive_key_aes(ctx.nonce, master_key->raw,
>  				  raw_key);

More likely this should be:

	res = ext4_derive_key_aes(,,,);
	if (res)
		goto out;

>  got_key:
>  	ctfm = crypto_alloc_ablkcipher(cipher_str, 0, 0);
