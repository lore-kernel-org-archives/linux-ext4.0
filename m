From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 1/2] fscrypto: don't use on-stack buffer for filename
 encryption
Date: Mon, 7 Nov 2016 14:15:37 +0100
Message-ID: <5e29849c-158b-0492-380e-7dc9fbef95df@nod.at>
References: <1478210582-86338-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        luto@kernel.org
To: Eric Biggers <ebiggers@google.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from b.ns.miles-group.at ([95.130.255.144]:44724 "EHLO radon.swed.at"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752759AbcKGNPl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 7 Nov 2016 08:15:41 -0500
In-Reply-To: <1478210582-86338-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03.11.2016 23:03, Eric Biggers wrote:
> With the new (in 4.9) option to use a virtually-mapped stack
> (CONFIG_VMAP_STACK), stack buffers cannot be used as input/output for
> the scatterlist crypto API because they may not be directly mappable to
> struct page.  For short filenames, fname_encrypt() was encrypting a

As Kent and Andy pointed out, they are but here are dragons.
The pages can be non-linear and on platforms with different cache architectures
extra flush operations may be needed.

> stack buffer holding the padded filename.  Fix it by encrypting the
> filename in-place in the output buffer, thereby making the temporary
> buffer unnecessary.
> 
> This bug could most easily be observed in a CONFIG_DEBUG_SG kernel
> because this allowed the BUG in sg_set_buf() to be triggered.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/fname.c | 53 +++++++++++++++++++++--------------------------------
>  1 file changed, 21 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 9a28133..9b774f4 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -39,65 +39,54 @@ static void fname_crypt_complete(struct crypto_async_request *req, int res)
>  static int fname_encrypt(struct inode *inode,
>  			const struct qstr *iname, struct fscrypt_str *oname)
>  {
> -	u32 ciphertext_len;
>  	struct skcipher_request *req = NULL;
>  	DECLARE_FS_COMPLETION_RESULT(ecr);
>  	struct fscrypt_info *ci = inode->i_crypt_info;
>  	struct crypto_skcipher *tfm = ci->ci_ctfm;
>  	int res = 0;
>  	char iv[FS_CRYPTO_BLOCK_SIZE];
> -	struct scatterlist src_sg, dst_sg;
> +	struct scatterlist sg;
>  	int padding = 4 << (ci->ci_flags & FS_POLICY_FLAGS_PAD_MASK);
> -	char *workbuf, buf[32], *alloc_buf = NULL;
> -	unsigned lim;
> +	unsigned int lim;
> +	unsigned int cryptlen;
>  
>  	lim = inode->i_sb->s_cop->max_namelen(inode);
>  	if (iname->len <= 0 || iname->len > lim)
>  		return -EIO;
>  
> -	ciphertext_len = max(iname->len, (u32)FS_CRYPTO_BLOCK_SIZE);
> -	ciphertext_len = round_up(ciphertext_len, padding);
> -	ciphertext_len = min(ciphertext_len, lim);
> +	/*
> +	 * Copy the filename to the output buffer for encrypting in-place and
> +	 * pad it with the needed number of NUL bytes.
> +	 */
> +	cryptlen = max_t(unsigned int, iname->len, FS_CRYPTO_BLOCK_SIZE);
> +	cryptlen = round_up(cryptlen, padding);
> +	cryptlen = min(cryptlen, lim);
> +	memcpy(oname->name, iname->name, iname->len);
> +	memset(oname->name + iname->len, 0, cryptlen - iname->len);
>  
> -	if (ciphertext_len <= sizeof(buf)) {
> -		workbuf = buf;
> -	} else {
> -		alloc_buf = kmalloc(ciphertext_len, GFP_NOFS);
> -		if (!alloc_buf)
> -			return -ENOMEM;
> -		workbuf = alloc_buf;
> -	}
> +	/* Initialize the IV */
> +	memset(iv, 0, FS_CRYPTO_BLOCK_SIZE);

You can initialize it with iv = {0} at the beginning such that you don't
need the memset here.

> -	/* Allocate request */
> +	/* Set up the encryption request */
>  	req = skcipher_request_alloc(tfm, GFP_NOFS);
>  	if (!req) {
>  		printk_ratelimited(KERN_ERR
> -			"%s: crypto_request_alloc() failed\n", __func__);
> -		kfree(alloc_buf);
> +			"%s: skcipher_request_alloc() failed\n", __func__);
>  		return -ENOMEM;
>  	}
>  	skcipher_request_set_callback(req,
>  			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
>  			fname_crypt_complete, &ecr);
> +	sg_init_one(&sg, oname->name, cryptlen);
> +	skcipher_request_set_crypt(req, &sg, &sg, cryptlen, iv);
>  
> -	/* Copy the input */
> -	memcpy(workbuf, iname->name, iname->len);
> -	if (iname->len < ciphertext_len)
> -		memset(workbuf + iname->len, 0, ciphertext_len - iname->len);
> -
> -	/* Initialize IV */
> -	memset(iv, 0, FS_CRYPTO_BLOCK_SIZE);
> -
> -	/* Create encryption request */
> -	sg_init_one(&src_sg, workbuf, ciphertext_len);
> -	sg_init_one(&dst_sg, oname->name, ciphertext_len);
> -	skcipher_request_set_crypt(req, &src_sg, &dst_sg, ciphertext_len, iv);
> +	/* Do the encryption */
>  	res = crypto_skcipher_encrypt(req);
>  	if (res == -EINPROGRESS || res == -EBUSY) {
> +		/* Request is being completed asynchronously; wait for it */
>  		wait_for_completion(&ecr.completion);
>  		res = ecr.res;
>  	}
> -	kfree(alloc_buf);
>  	skcipher_request_free(req);
>  	if (res < 0) {
>  		printk_ratelimited(KERN_ERR
> @@ -105,7 +94,7 @@ static int fname_encrypt(struct inode *inode,
>  		return res;
>  	}
>  
> -	oname->len = ciphertext_len;
> +	oname->len = cryptlen;
>  	return 0;
>  }

Reviewed-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
