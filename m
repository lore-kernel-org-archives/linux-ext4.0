From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/4] crc32: Bolt on crc32c
Date: Tue, 15 Nov 2011 00:48:05 -0800
Message-ID: <20111115084805.GY12447@tux1.beaverton.ibm.com>
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com> <20111004235403.1560.55503.stgit@elm3c44.beaverton.ibm.com> <20111021122803.GA15803@gondor.apana.org.au> <20111021165703.GS12447@tux1.beaverton.ibm.com> <20111021191514.GA3997@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111021191514.GA3997@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 21, 2011 at 09:15:14PM +0200, Herbert Xu wrote:
> On Fri, Oct 21, 2011 at 09:57:03AM -0700, Darrick J. Wong wrote:
> > 
> > My patchset builds upon Bob Pearson's crc32 patchset from early September.  Do
> > my patches fail to apply after applying his patchset?
> > 
> > Or, to speed things along, should I simply repost both Bob's and my patches as
> > one big series?
> > 
> > Bob, have you sent out a new iteration of your patches since September 6th?
> 
> I'm fine with you pushing this through whichever tree that Bob's
> patches are going through.

Well... it's been 2.5 weeks since I last asked about this.  No reply, afaict.
I haven't seen any complaints about Bob's latest patchset, nor any complaints
about my set that sits atop his.  On the other hand, I'm pretty sure I haven't
seen Bob's patches appear in any trees, and Google shows no recent progress.

Herbert, would you object to pushing the whole patchset through the crypto
tree?

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
