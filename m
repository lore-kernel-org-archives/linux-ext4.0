From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v4] crc32c: Implement CRC32c with slicing-by-8 algorithm
Date: Mon, 3 Oct 2011 17:55:10 -0700
Message-ID: <20111004005510.GB12447@tux1.beaverton.ibm.com>
References: <20110930192956.4176.29905.stgit@elm3c44.beaverton.ibm.com> <OF54094699.6F5CF2B6-ONC125791C.004C901C-C125791C.004D1A61@transmode.se> <20111003153634.GA12447@tux1.beaverton.ibm.com> <OFA190E2A9.231A7DD6-ONC125791E.006F1765-C125791E.00705758@transmode.se> <20111003203513.GA10346@gondor.apana.org.au>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Mingming Cao <cmm@us.ibm.com>,
	David Miller <davem@davemloft.net>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	Theodore Tso <tytso@mit.edu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111003203513.GA10346@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 03, 2011 at 09:35:13PM +0100, Herbert Xu wrote:
> On Mon, Oct 03, 2011 at 10:27:03PM +0200, Joakim Tjernlund wrote:
> >
> > > > Start from Bobs latest patches and add crc32c to lib/crc32.c
> > >
> > > If I did that, how should I handle patching in the hardware accelerated version
> > > on Intel systems?  That switcheroo ability seems to have been Herbert Xu's
> > > motivation for moving crc32c into crypto/ in the first place:
> > 
> > I don't know, I haven't looked at that problem. I suspect it moved because that
> > was the easiest solution. Having an identical impl. of crc32(only the table values differ)
> > in crypto compared to the one in lib is not the way forward though.
> 
> You can always get crypto/crc32c.c to use call helpers from
> lib/crc32.c.

So what I think I'm hearing is...

1. Apply Bob's slice-by-8 algorithm patch to regular crc32.
2. Adapt crc32's build code to generate crc32c as well.
3. Remove crypto/crc32c.c's implementation and have it wrap the code generated
   by #2.
4. Retain the current libcrc32c.  I guess if you don't configure CRYPTO and
   CRYPTO_CRC32C then it could also just reference the generated crc32c functions
   directly.

Is this a satisfactory way to move forward?

--D
