From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 2/2] fscrypto: don't use on-stack buffer for key
 derivation
Date: Mon, 7 Nov 2016 14:22:16 +0100
Message-ID: <c6d016e1-2d3d-45cf-b7a6-e10a4434c1ea@nod.at>
References: <1478210582-86338-1-git-send-email-ebiggers@google.com>
 <1478210582-86338-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        luto@kernel.org
To: Eric Biggers <ebiggers@google.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44723 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752511AbcKGNWT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Nov 2016 08:22:19 -0500
In-Reply-To: <1478210582-86338-2-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03.11.2016 23:03, Eric Biggers wrote:
> With the new (in 4.9) option to use a virtually-mapped stack
> (CONFIG_VMAP_STACK), stack buffers cannot be used as input/output for
> the scatterlist crypto API because they may not be directly mappable to
> struct page.  get_crypt_info() was using a stack buffer to hold the

See 1/2. :-)

> output from the encryption operation used to derive the per-file key.
> Fix it by using a heap buffer.
> 
> This bug could most easily be observed in a CONFIG_DEBUG_SG kernel
> because this allowed the BUG in sg_set_buf() to be triggered.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/keyinfo.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> index 82f0285..67fb6d8 100644
> --- a/fs/crypto/keyinfo.c
> +++ b/fs/crypto/keyinfo.c
> @@ -185,7 +185,7 @@ int get_crypt_info(struct inode *inode)
>  	struct crypto_skcipher *ctfm;
>  	const char *cipher_str;
>  	int keysize;
> -	u8 raw_key[FS_MAX_KEY_SIZE];
> +	u8 *raw_key = NULL;
>  	int res;
>  
>  	res = fscrypt_initialize();
> @@ -238,6 +238,15 @@ int get_crypt_info(struct inode *inode)
>  	if (res)
>  		goto out;
>  
> +	/*
> +	 * This cannot be a stack buffer because it is passed to the scatterlist
> +	 * crypto API as part of key derivation.
> +	 */
> +	res = -ENOMEM;
> +	raw_key = kmalloc(FS_MAX_KEY_SIZE, GFP_NOFS);
> +	if (!raw_key)
> +		goto out;
> +
>  	if (fscrypt_dummy_context_enabled(inode)) {
>  		memset(raw_key, 0x42, FS_AES_256_XTS_KEY_SIZE);
>  		goto got_key;
> @@ -276,7 +285,8 @@ int get_crypt_info(struct inode *inode)
>  	if (res)
>  		goto out;
>  
> -	memzero_explicit(raw_key, sizeof(raw_key));
> +	kzfree(raw_key);
> +	raw_key = NULL;
>  	if (cmpxchg(&inode->i_crypt_info, NULL, crypt_info) != NULL) {
>  		put_crypt_info(crypt_info);
>  		goto retry;
> @@ -287,7 +297,7 @@ int get_crypt_info(struct inode *inode)
>  	if (res == -ENOKEY)
>  		res = 0;
>  	put_crypt_info(crypt_info);
> -	memzero_explicit(raw_key, sizeof(raw_key));
> +	kzfree(raw_key);
>  	return res;
>  }

Reviewed-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard

