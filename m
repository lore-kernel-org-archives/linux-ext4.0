From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4 crypto: remove unneeded assignation
Date: Wed, 8 Jul 2015 13:01:08 -0700
Message-ID: <20150708200108.GC10037@birch.djwong.org>
References: <1436385075-22559-1-git-send-email-laurent.navet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Laurent Navet <laurent.navet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436385075-22559-1-git-send-email-laurent.navet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 08, 2015 at 09:51:15PM +0200, Laurent Navet wrote:
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

I don't think it's a good idea to drop the error code on the floor and keep
going as if nothing bad had happened.

--D

>  got_key:
>  	ctfm = crypto_alloc_ablkcipher(cipher_str, 0, 0);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
