From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/4] crc32: Bolt on crc32c
Date: Fri, 21 Oct 2011 09:57:03 -0700
Message-ID: <20111021165703.GS12447@tux1.beaverton.ibm.com>
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com> <20111004235403.1560.55503.stgit@elm3c44.beaverton.ibm.com> <20111021122803.GA15803@gondor.apana.org.au>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111021122803.GA15803@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 21, 2011 at 02:28:03PM +0200, Herbert Xu wrote:
> On Tue, Oct 04, 2011 at 04:54:03PM -0700, Darrick J. Wong wrote:
> > Reuse the existing crc32 code to stamp out a crc32c implementation.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> Did you want this to go through my tree? If so then there is a
> problem since it doesn't apply at all.

My patchset builds upon Bob Pearson's crc32 patchset from early September.  Do
my patches fail to apply after applying his patchset?

Or, to speed things along, should I simply repost both Bob's and my patches as
one big series?

Bob, have you sent out a new iteration of your patches since September 6th?

--D
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
