From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Thu, 1 Sep 2011 15:28:14 -0700
Message-ID: <20110901222814.GB12086@tux1.beaverton.ibm.com>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com> <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com> <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com> <20110901221854.GA12086@tux1.beaverton.ibm.com> <20110901222422.GA5771@infradead.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bob Pearson <rpearson@systemfabricworks.com>,
	"'Andreas Dilger'" <adilger.kernel@dilger.ca>,
	"'Herbert Xu'" <herbert@gondor.apana.org.au>,
	"'Theodore Tso'" <tytso@mit.edu>,
	"'David Miller'" <davem@davemloft.net>,
	"'linux-kernel'" <linux-kernel@vger.kernel.org>,
	"'Mingming Cao'" <cmm@us.ibm.com>,
	"'linux-crypto'" <linux-crypto@vger.kernel.org>,
	"'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60894 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab1IAW2U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 18:28:20 -0400
Content-Disposition: inline
In-Reply-To: <20110901222422.GA5771@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 01, 2011 at 06:24:22PM -0400, Christoph Hellwig wrote:
> On Thu, Sep 01, 2011 at 03:18:54PM -0700, Darrick J. Wong wrote:
> > I suspect it would be pretty easy to adapt the Makefile to generate the
> > relevant .c and .h files; in particular it could be useful to use the crypto
> > framework for crc32 on the off chance anyone wants to provide hwaccel for that
> > too.
> 
> crc32 or crc32c?  Note that there already is a hardware optimized crc32c
> for recent Intel CPUs in arch/x86/crypto/crc32c-intel.c.

crc32, since it currently doesn't use the crypto api at all, and Bob was
interested in implementing slice-by-8 for it.  Though I suppose so long as
there aren't any reasons to override the sw crc32 implementation we could just
fall back to Bob's earlier patch to implement slice-by-8 for crc32?

<shrug> I don't mind implementing faster crc32/crc32c.

(As far as crc32c goes, my motivation is to make sw crc32c faster for the cases
where you don't have Intel hw.)

--D
