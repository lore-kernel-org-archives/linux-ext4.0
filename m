From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] crypto: allow to assign gfp_t for __crypto_alloc_tfm
Date: Mon, 18 May 2015 23:24:30 -0700
Message-ID: <20150519062430.GA39588@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1432014416-39326-1-git-send-email-jaegeuk@kernel.org>
 <20150519054945.GA28060@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ecryptfs@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <ecryptfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519054945.GA28060@gondor.apana.org.au>
Sender: ecryptfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 19, 2015 at 01:49:45PM +0800, Herbert Xu wrote:
> On Mon, May 18, 2015 at 10:46:56PM -0700, Jaegeuk Kim wrote:
> > This patch adds a parameter, gfp_t, for __crypto_alloc_tfm.
> > Now EXT4 and F2FS use the crypto engine to encrypt a page when writing it to the
> > disk.
> > That happens during ->writepage and it needs to allocate memory with
> > GFP_NOFS.
> > 
> > Otherwise, in the f2fs case, kernel reports such the following warning.
> 
> Normally crypto structures should only be allocated on control
> paths where sleeping or swapping is not an issue.  Why is ext4
> doing crypto allocations on the data path?
> 

Recently, Ted introduced per-file encryption feature as follows.

https://lwn.net/Articles/639427/

The call path in fs/ext4/crypto.c is:
 - writepage
  - ext4_encrypt
   - ext4_get_crypto_ctx
    - crypto_alloc_ablkcipher

AFAIK, this way can achieve to reduce memory footprint gracefully.
Just before submitting bios, fs allocates the required memory, and then end_io
will free them in pair.

Thanks,

> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
