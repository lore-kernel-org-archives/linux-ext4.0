From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Thu, 1 Sep 2011 15:18:54 -0700
Message-ID: <20110901221854.GA12086@tux1.beaverton.ibm.com>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com> <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com> <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
	"'Herbert Xu'" <herbert@gondor.apana.org.au>,
	"'Theodore Tso'" <tytso@mit.edu>,
	"'David Miller'" <davem@davemloft.net>,
	"'linux-kernel'" <linux-kernel@vger.kernel.org>,
	"'Mingming Cao'" <cmm@us.ibm.com>,
	"'linux-crypto'" <linux-crypto@vger.kernel.org>,
	"'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Bob Pearson <rpearson@systemfabricworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 01, 2011 at 12:40:08AM -0500, Bob Pearson wrote:
> Hi Darrick,
> 
> The same code in crc32.c was helpful to measure performance and help code
> tuning as well as indicate correctness. Otherwise the code in crypto may be
> enough to test all the corner cases. If this survives the review I wonder if
> there is a way to combine crc32 and crc32c together somehow. I like yours
> because you can load/unload and not need the memory permanently.

I suspect it would be pretty easy to adapt the Makefile to generate the
relevant .c and .h files; in particular it could be useful to use the crypto
framework for crc32 on the off chance anyone wants to provide hwaccel for that
too.

That said, merging libcrc32c-test vectors with the existing one (sorry, I
didn't realize that existed) shouldn't be too difficult.

--D
