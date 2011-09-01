From: "Bob Pearson" <rpearson@systemfabricworks.com>
Subject: RE: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Wed, 31 Aug 2011 20:20:55 -0500
Message-ID: <035501cc6845$66a0ad20$33e20760$@systemfabricworks.com>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com> <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com> <20110901010737.GA25658@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
	"'Theodore Tso'" <tytso@mit.edu>,
	"'David Miller'" <davem@davemloft.net>,
	"'linux-kernel'" <linux-kernel@vger.kernel.org>,
	"'Mingming Cao'" <cmm@us.ibm.com>,
	"'linux-crypto'" <linux-crypto@vger.kernel.org>,
	"'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>,
	"'Darrick J. Wong'" <djwong@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
In-Reply-To: <20110901010737.GA25658@gondor.apana.org.au>
Content-Language: en-us
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Could you elaborate a little on this?

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Wednesday, August 31, 2011 8:08 PM
> To: Darrick J. Wong
> Cc: Andreas Dilger; Theodore Tso; David Miller; Bob Pearson; linux-kernel;
> Mingming Cao; linux-crypto; linux-fsdevel; linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
> 
> On Wed, Aug 31, 2011 at 05:33:36PM -0700, Darrick J. Wong wrote:
> > This is a loadable module that will self-test the CRC32c code.
> >
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> Please use the existing crypto testing framework.
> 
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
