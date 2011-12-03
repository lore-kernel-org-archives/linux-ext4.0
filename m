From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v5.2 00/14] crc32c: Add faster algorithm and self-test
	code
Date: Fri, 2 Dec 2011 18:30:37 -0800
Message-ID: <20111203023037.GA16577@tux1.beaverton.ibm.com>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201202053.GG1495@noexit.corp.google.com> <20111201203122.GC23175@tux1.beaverton.ibm.com> <20111202002358.GA19842@gondor.apana.org.au>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	Bob Pearson <rpearson@systemfabricworks.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59247 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab1LCCao (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Dec 2011 21:30:44 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Fri, 2 Dec 2011 21:30:43 -0500
Content-Disposition: inline
In-Reply-To: <20111202002358.GA19842@gondor.apana.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 02, 2011 at 08:23:58AM +0800, Herbert Xu wrote:
> On Thu, Dec 01, 2011 at 12:31:22PM -0800, Darrick J. Wong wrote:
> .
> > They seem to call crc32c(), which is in crypto/crc32c.  If you're interested in
> 
> Nope, the crypto API layer will use the SSE implementation
> where available.  Only when it isn't available will the C version
> in crypto/ be used.

There's a SSE version other than what's in crc32c-intel?

(I suspect we're talking about the same thing?)

--D
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

