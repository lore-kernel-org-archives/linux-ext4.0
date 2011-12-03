From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5.2 00/14] crc32c: Add faster algorithm and self-test
	code
Date: Sat, 3 Dec 2011 19:00:50 +0800
Message-ID: <20111203110049.GA31151@gondor.apana.org.au>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201202053.GG1495@noexit.corp.google.com> <20111201203122.GC23175@tux1.beaverton.ibm.com> <20111202002358.GA19842@gondor.apana.org.au> <20111203023037.GA16577@tux1.beaverton.ibm.com>
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
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:46634 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab1LCLBQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Dec 2011 06:01:16 -0500
Content-Disposition: inline
In-Reply-To: <20111203023037.GA16577@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 02, 2011 at 06:30:37PM -0800, Darrick J. Wong wrote:
> On Fri, Dec 02, 2011 at 08:23:58AM +0800, Herbert Xu wrote:
> > On Thu, Dec 01, 2011 at 12:31:22PM -0800, Darrick J. Wong wrote:
> > .
> > > They seem to call crc32c(), which is in crypto/crc32c.  If you're interested in
> > 
> > Nope, the crypto API layer will use the SSE implementation
> > where available.  Only when it isn't available will the C version
> > in crypto/ be used.
> 
> There's a SSE version other than what's in crc32c-intel?

crc32c-intel is what I meant.  My point is that it'll be used
automatically.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
