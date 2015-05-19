From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] crypto: allow to assign gfp_t for __crypto_alloc_tfm
Date: Mon, 18 May 2015 23:58:12 -0700
Message-ID: <20150519065812.GA40012@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1432014416-39326-1-git-send-email-jaegeuk@kernel.org>
 <20150519054945.GA28060@gondor.apana.org.au>
 <20150519062430.GA39588@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519063211.GA28347@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ecryptfs@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519063211.GA28347@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 19, 2015 at 02:32:11PM +0800, Herbert Xu wrote:
> On Mon, May 18, 2015 at 11:24:30PM -0700, Jaegeuk Kim wrote:
> >
> > The call path in fs/ext4/crypto.c is:
> >  - writepage
> >   - ext4_encrypt
> >    - ext4_get_crypto_ctx
> >     - crypto_alloc_ablkcipher
> > 
> > AFAIK, this way can achieve to reduce memory footprint gracefully.
> > Just before submitting bios, fs allocates the required memory, and then end_io
> > will free them in pair.
> 
> So where does the key get generated? The crypto tfm should be
> allocated when you generate the key.

In fs/ext4/crypto.c,

 - writepage
   - ext4_encrypt
     - ext4_get_crypto_ctx
       - crypto_alloc_ablkcipher
     - ext4_page_crypto
       - crypto_ablkcipher_setkey
       - ablkcipher_request_alloc(GFP_NOFS)
       - ablkcipher_request_set_crypt(PAGE_CACHE_SIZE)
       - crypto_ablkcipher_encrypt

 - end_io
   - crypto_free_tfm

Thanks,

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
