From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v4] crc32c: Implement CRC32c with slicing-by-8 algorithm
Date: Tue, 4 Oct 2011 16:54:46 -0700
Message-ID: <20111004235446.GC12447@tux1.beaverton.ibm.com>
References: <20110930192956.4176.29905.stgit@elm3c44.beaverton.ibm.com> <OF54094699.6F5CF2B6-ONC125791C.004C901C-C125791C.004D1A61@transmode.se> <20111003153634.GA12447@tux1.beaverton.ibm.com> <OFA190E2A9.231A7DD6-ONC125791E.006F1765-C125791E.00705758@transmode.se> <20111003203513.GA10346@gondor.apana.org.au> <20111004005510.GB12447@tux1.beaverton.ibm.com> <20111004065953.GA16606@gondor.apana.org.au>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:56280 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933983Ab1JDXyk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Oct 2011 19:54:40 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 4 Oct 2011 17:54:40 -0600
Content-Disposition: inline
In-Reply-To: <20111004065953.GA16606@gondor.apana.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 04, 2011 at 07:59:53AM +0100, Herbert Xu wrote:
> On Mon, Oct 03, 2011 at 05:55:10PM -0700, Darrick J. Wong wrote:
> >
> > So what I think I'm hearing is...
> > 
> > 1. Apply Bob's slice-by-8 algorithm patch to regular crc32.
> > 2. Adapt crc32's build code to generate crc32c as well.
> > 3. Remove crypto/crc32c.c's implementation and have it wrap the code generated
> >    by #2.
> > 4. Retain the current libcrc32c.  I guess if you don't configure CRYPTO and
> >    CRYPTO_CRC32C then it could also just reference the generated crc32c functions
> >    directly.
> > 
> > Is this a satisfactory way to move forward?
> 
> All good except that you don't really have to touch libcrc32c
> at all.

Ok, let's see what you think of my v5 patchset. :)

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

