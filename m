From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5.2 00/14] crc32c: Add faster algorithm and self-test
	code
Date: Fri, 2 Dec 2011 08:23:58 +0800
Message-ID: <20111202002358.GA19842@gondor.apana.org.au>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201202053.GG1495@noexit.corp.google.com> <20111201203122.GC23175@tux1.beaverton.ibm.com>
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
Received: from helcar.apana.org.au ([209.40.204.226]:57648 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab1LBAYZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Dec 2011 19:24:25 -0500
Content-Disposition: inline
In-Reply-To: <20111201203122.GC23175@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 01, 2011 at 12:31:22PM -0800, Darrick J. Wong wrote:
.
> They seem to call crc32c(), which is in crypto/crc32c.  If you're interested in

Nope, the crypto API layer will use the SSE implementation
where available.  Only when it isn't available will the C version
in crypto/ be used.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
