From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] crypto: allow to assign gfp_t for __crypto_alloc_tfm
Date: Wed, 20 May 2015 10:59:01 -0400
Message-ID: <20150520145901.GI2871@thunk.org>
References: <20150519054945.GA28060@gondor.apana.org.au>
 <20150519062430.GA39588@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519063211.GA28347@gondor.apana.org.au>
 <20150519065812.GA40012@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519065929.GA28610@gondor.apana.org.au>
 <20150519071317.GB40012@jaegeuk-mac02.hsd1.ca.comcast.net>
 <20150519071521.GA28862@gondor.apana.org.au>
 <20150519141430.GD20421@thunk.org>
 <20150519142755.GB32663@gondor.apana.org.au>
 <20150520072118.GN8928@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Jaegeuk Kim <jaegeuk@kernel.org>, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ecryptfs@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150520072118.GN8928@secunet.com>
Sender: ecryptfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 20, 2015 at 09:21:20AM +0200, Steffen Klassert wrote:
> The current pcrypt version is used just for IPsec because it supports
> only AEAD type algorithms and does not support request backlog. But
> I have patches to support ablkcipher algorithms and request backlog.
> I could provide them if there is interest in it.

I don't know the crypto layer well enough, and I certainly don't know
how to deal with things like ARM CPU's with "big-little" architectures
to understand what we might need to do to power optimize things for
mobile handsets.  But if someone has time to look at this, that would
be great.

					- Ted
