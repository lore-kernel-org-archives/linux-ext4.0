From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Thu, 1 Sep 2011 18:24:22 -0400
Message-ID: <20110901222422.GA5771@infradead.org>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com>
 <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com>
 <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
 <20110901221854.GA12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bob Pearson <rpearson@systemfabricworks.com>,
	'Andreas Dilger' <adilger.kernel@dilger.ca>,
	'Herbert Xu' <herbert@gondor.apana.org.au>,
	'Theodore Tso' <tytso@mit.edu>,
	'David Miller' <davem@davemloft.net>,
	'linux-kernel' <linux-kernel@vger.kernel.org>,
	'Mingming Cao' <cmm@us.ibm.com>,
	'linux-crypto' <linux-crypto@vger.kernel.org>,
	'linux-fsdevel' <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110901221854.GA12086@tux1.beaverton.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 01, 2011 at 03:18:54PM -0700, Darrick J. Wong wrote:
> I suspect it would be pretty easy to adapt the Makefile to generate the
> relevant .c and .h files; in particular it could be useful to use the crypto
> framework for crc32 on the off chance anyone wants to provide hwaccel for that
> too.

crc32 or crc32c?  Note that there already is a hardware optimized crc32c
for recent Intel CPUs in arch/x86/crypto/crc32c-intel.c.
