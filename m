From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 2/3] libcrc32c: Expose big-endian version of crc32c
Date: Wed, 28 Sep 2011 09:51:45 -0700
Message-ID: <20110928165133.GQ12086@tux1.beaverton.ibm.com>
References: <20110927221239.21653.17489.stgit@elm3c44.beaverton.ibm.com> <20110927221253.21653.28062.stgit@elm3c44.beaverton.ibm.com> <20110928035356.GA6671@gondor.apana.org.au>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110928035356.GA6671@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 28, 2011 at 01:53:59PM +1000, Herbert Xu wrote:
> On Tue, Sep 27, 2011 at 03:12:53PM -0700, Darrick J. Wong wrote:
> > Provide a big-endian version of crc32c for modules that want it.
> 
> Who is going to use this?

Well, I was using it for jbd2 ... but since you ask, it seems to work just as
well with crc32c-le, so I think I'll just drop the -be version.

--D
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
