From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] crypto: allow to assign gfp_t for __crypto_alloc_tfm
Date: Tue, 19 May 2015 00:59:05 -0700
Message-ID: <20150519075905.GA40521@jaegeuk-mac02.hsd1.ca.comcast.net>
References: <1432014416-39326-1-git-send-email-jaegeuk@kernel.org>
 <20150519054945.GA28060@gondor.apana.org.au>
 <20150519062430.GA39588@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519063211.GA28347@gondor.apana.org.au>
 <20150519065812.GA40012@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519065929.GA28610@gondor.apana.org.au>
 <20150519071317.GB40012@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519071521.GA28862@gondor.apana.org.au>
 <20150519072740.GA40281@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519073012.GA29030@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ecryptfs@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150519073012.GA29030@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 19, 2015 at 03:30:12PM +0800, Herbert Xu wrote:
> On Tue, May 19, 2015 at 12:27:40AM -0700, Jaegeuk Kim wrote:
> >
> > So, IMHO, it can consume memory too much, since tfm should be allocated for
> > every inodes and be alive until inode eviction.
> 
> Are you sure this is a real problem? Have you actually looked at
> how much memory it consumes?

I didn't measure the memory footprint. I can't tell it is a real problem,
but at least, I hope it can reduce somewhat memory consumption.
Because, already per-inode crypto structure consumes at least 84 bytes.

> 
> > Apart from giving GFP_NOFS, do you mean that it is a wrong approach?
> 
> Allocating the tfm and setting a key on the data path is not
> acceptable.

Ok, I'll check it again and investigate in more detail how not to break
this rule.

Thank you very much for the comments.

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
