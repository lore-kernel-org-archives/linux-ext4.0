From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Thu, 1 Sep 2011 11:51:21 +1000
Message-ID: <20110901015120.GA26182@gondor.apana.org.au>
References: <035501cc6845$66a0ad20$33e20760$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: djwong@us.ibm.com, adilger.kernel@dilger.ca, tytso@mit.edu,
	davem@davemloft.net, linux-kernel@vger.kernel.org, cmm@us.ibm.com,
	linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Bob Pearson <rpearson@systemfabricworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <035501cc6845$66a0ad20$33e20760$@systemfabricworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Bob Pearson <rpearson@systemfabricworks.com> wrote:
> Could you elaborate a little on this?

Sure, we already have a self-test infrastructure under crypto
in testmgr.*.  It even includes test vectors for crc32c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
